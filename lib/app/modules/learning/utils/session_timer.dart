import 'dart:async';
import 'package:get/get.dart';

/// Manages timing for quiz/learning sessions
class SessionTimer {
  Timer? _timer;
  
  // Total elapsed time for the entire session
  final RxInt totalElapsedSeconds = 0.obs;
  
  // Time spent on current item (e.g., question)
  final RxInt currentItemSeconds = 0.obs;
  
  // Individual item timings
  final RxList<int> itemTimings = <int>[].obs;
  
  // Timer state
  final RxBool isRunning = false.obs;
  
  /// Start or resume the timer
  void start() {
    if (isRunning.value) return;
    
    isRunning.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      totalElapsedSeconds.value++;
      currentItemSeconds.value++;
    });
  }
  
  /// Pause the timer
  void pause() {
    _timer?.cancel();
    isRunning.value = false;
  }
  
  /// Stop the timer completely
  void stop() {
    pause();
    _saveCurrentItemTiming();
  }
  
  /// Reset timer for a new item (e.g., new question)
  void resetCurrentItem() {
    currentItemSeconds.value = 0;
  }
  
  /// Save current item timing and reset for next item
  void nextItem() {
    _saveCurrentItemTiming();
    resetCurrentItem();
  }
  
  /// Save current item timing
  void _saveCurrentItemTiming() {
    if (currentItemSeconds.value > 0) {
      itemTimings.add(currentItemSeconds.value);
    }
  }
  
  /// Get formatted total time string
  String get formattedTotalTime {
    final hours = (totalElapsedSeconds.value ~/ 3600);
    final minutes = ((totalElapsedSeconds.value % 3600) ~/ 60);
    final seconds = (totalElapsedSeconds.value % 60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
  
  /// Get formatted current item time string
  String get formattedCurrentItemTime {
    final minutes = (currentItemSeconds.value ~/ 60);
    final seconds = (currentItemSeconds.value % 60);
    
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
  
  /// Get average time per item
  double get averageTimePerItem {
    if (itemTimings.isEmpty) return 0.0;
    final total = itemTimings.reduce((a, b) => a + b);
    return total / itemTimings.length;
  }
  
  /// Get formatted average time per item
  String get formattedAverageTime {
    final avgSeconds = averageTimePerItem.round();
    final minutes = (avgSeconds ~/ 60);
    final seconds = (avgSeconds % 60);
    
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
  
  /// Get total items completed
  int get totalItemsCompleted => itemTimings.length;
  
  /// Get time for a specific item
  int? getItemTime(int index) {
    if (index < 0 || index >= itemTimings.length) return null;
    return itemTimings[index];
  }
  
  /// Reset all timer data
  void reset() {
    pause();
    totalElapsedSeconds.value = 0;
    currentItemSeconds.value = 0;
    itemTimings.clear();
  }
  
  /// Dispose of timer resources
  void dispose() {
    _timer?.cancel();
  }
  
  /// Get session statistics
  Map<String, dynamic> get statistics {
    return {
      'totalTime': totalElapsedSeconds.value,
      'formattedTotalTime': formattedTotalTime,
      'itemsCompleted': totalItemsCompleted,
      'averageTimePerItem': averageTimePerItem,
      'formattedAverageTime': formattedAverageTime,
      'itemTimings': itemTimings.toList(),
    };
  }
}