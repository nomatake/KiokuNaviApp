import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kioku_navi/models/user.dart';
import 'dart:async';

class UserRepository {
  final FlutterSecureStorage storage;
  static const String _userKey = 'current_user';
  
  final _userStreamController = StreamController<User?>.broadcast();
  Stream<User?> get userStream => _userStreamController.stream;
  
  UserRepository({FlutterSecureStorage? storage}) 
      : storage = storage ?? const FlutterSecureStorage() {
    // Initialize stream with null
    _userStreamController.add(null);
  }
  
  Future<void> saveUser(User user) async {
    final userJson = jsonEncode({
      'id': user.id,
      'name': user.name,
      'type': user.type == UserType.student ? 'student' : 'parent',
      'student_id': user.studentId,
      'email': user.email,
      'grade': user.grade,
      'children': user.children?.map((child) => {
        'id': child.id,
        'name': child.name,
        'grade': child.grade,
      }).toList(),
    });
    
    await storage.write(key: _userKey, value: userJson);
    _userStreamController.add(user);
  }
  
  Future<User?> getCurrentUser() async {
    final userJson = await storage.read(key: _userKey);
    if (userJson == null) {
      return null;
    }
    
    try {
      final userData = jsonDecode(userJson);
      return User.fromJson(userData);
    } catch (e) {
      // Invalid data, clear it
      await clearUser();
      return null;
    }
  }
  
  Future<void> clearUser() async {
    await storage.delete(key: _userKey);
    _userStreamController.add(null);
  }
  
  void dispose() {
    _userStreamController.close();
  }
}