import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kioku_navi/models/quiz_session.dart';

class QuizRepository {
  final FlutterSecureStorage storage;
  static const String _currentSessionKey = 'current_quiz_session';
  static const String _historyKey = 'quiz_history';
  static const String _sessionPrefix = 'quiz_session_';
  static const int _maxHistorySize = 50;
  
  QuizRepository({FlutterSecureStorage? storage})
      : storage = storage ?? const FlutterSecureStorage();
  
  // Session Management
  Future<void> saveSession(QuizSession session) async {
    final sessionJson = jsonEncode(session.toJson());
    await storage.write(
      key: '$_sessionPrefix${session.sessionId}',
      value: sessionJson,
    );
  }
  
  Future<QuizSession?> getSession(String sessionId) async {
    final sessionJson = await storage.read(key: '$_sessionPrefix$sessionId');
    if (sessionJson == null) {
      return null;
    }
    
    try {
      final sessionData = jsonDecode(sessionJson);
      return QuizSession.fromJson(sessionData);
    } catch (e) {
      // Invalid data
      return null;
    }
  }
  
  Future<void> deleteSession(String sessionId) async {
    await storage.delete(key: '$_sessionPrefix$sessionId');
  }
  
  // Current Session
  Future<void> saveCurrentSession(QuizSession session) async {
    final sessionJson = jsonEncode(session.toJson());
    await storage.write(key: _currentSessionKey, value: sessionJson);
  }
  
  Future<QuizSession?> getCurrentSession() async {
    final sessionJson = await storage.read(key: _currentSessionKey);
    if (sessionJson == null) {
      return null;
    }
    
    try {
      final sessionData = jsonDecode(sessionJson);
      return QuizSession.fromJson(sessionData);
    } catch (e) {
      // Invalid data, clear it
      await clearCurrentSession();
      return null;
    }
  }
  
  Future<void> clearCurrentSession() async {
    await storage.delete(key: _currentSessionKey);
  }
  
  // Session History
  Future<void> addToHistory(String sessionId) async {
    final history = await getSessionHistory();
    history.add(sessionId);
    
    // Limit history size
    if (history.length > _maxHistorySize) {
      history.removeAt(0);
    }
    
    final historyJson = jsonEncode(history);
    await storage.write(key: _historyKey, value: historyJson);
  }
  
  Future<List<String>> getSessionHistory() async {
    final historyJson = await storage.read(key: _historyKey);
    if (historyJson == null) {
      return [];
    }
    
    try {
      final history = jsonDecode(historyJson) as List;
      return history.cast<String>();
    } catch (e) {
      // Invalid data
      return [];
    }
  }
  
  Future<void> clearHistory() async {
    await storage.delete(key: _historyKey);
  }
  
  // Statistics
  Future<Map<String, dynamic>> getUserStatistics() async {
    final sessionIds = await getSessionHistory();
    
    int totalSessions = 0;
    int totalQuestions = 0;
    int correctAnswers = 0;
    double totalScore = 0;
    final Set<String> subjectsAttempted = {};
    
    for (final sessionId in sessionIds) {
      final session = await getSession(sessionId);
      if (session != null) {
        totalSessions++;
        totalQuestions += session.totalQuestions;
        correctAnswers += session.correctAnswers;
        totalScore += session.score;
        
        for (final question in session.questions) {
          subjectsAttempted.add(question.subject);
        }
      }
    }
    
    final averageScore = totalSessions > 0 ? totalScore / totalSessions : 0;
    
    return {
      'total_sessions': totalSessions,
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'average_score': averageScore,
      'subjects_attempted': subjectsAttempted.toList(),
    };
  }
}