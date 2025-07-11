import 'dart:async';

/// Abstract class defining connectivity service interface
abstract class ConnectivityService {
  /// Stream that emits connectivity status changes
  Stream<bool> get connectivityStream;

  /// Get current connectivity status
  bool get isConnected;

  /// Check if the device is currently connected to the internet
  Future<bool> hasInternetConnection();

  /// Initialize the connectivity service
  Future<void> initialize();

  /// Start continuous monitoring (called when app becomes active)
  void startMonitoring();

  /// Stop monitoring (called when app becomes inactive)
  void stopMonitoring();

  /// Dispose resources
  void dispose();
}
