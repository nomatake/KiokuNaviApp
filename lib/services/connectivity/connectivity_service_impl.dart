import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'connectivity_service.dart';

/// Implementation of connectivity service that monitors network status
///
/// Following connectivity_plus documentation recommendations:
/// - Never rely solely on connectivity status for network requests
/// - Always guard against timeouts and errors
/// - Handle List<ConnectivityResult> properly
class ConnectivityServiceImpl extends GetxService
    implements ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  bool _hasConnection = false;
  bool _isMonitoring = false;

  @override
  Stream<bool> get connectivityStream => _connectivityController.stream;

  @override
  bool get isConnected => _hasConnection;

  @override
  Future<void> initialize() async {
    // Check initial connectivity without starting monitoring
    _hasConnection = await hasInternetConnection();
    _connectivityController.add(_hasConnection);

    if (kDebugMode) {
      print(
          '🌐 ConnectivityService initialized. Initial status: ${_hasConnection ? 'CONNECTED' : 'DISCONNECTED'}');
    }
  }

  @override
  void startMonitoring() {
    if (_isMonitoring) return;

    _isMonitoring = true;

    // Listen to connectivity changes with debouncing
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> connectivityResults) async {
        if (!_isMonitoring) return;

        // Add debouncing to avoid rapid fire events
        await Future.delayed(const Duration(milliseconds: 100));

        final hasConnection = await hasInternetConnection();
        if (_hasConnection != hasConnection) {
          _hasConnection = hasConnection;
          _connectivityController.add(_hasConnection);

          if (kDebugMode) {
            print(
                '🌐 Connectivity changed: ${hasConnection ? 'CONNECTED' : 'DISCONNECTED'}');
          }
        }
      },
    );
  }

  @override
  void stopMonitoring() {
    _isMonitoring = false;
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  @override
  Future<bool> hasInternetConnection() async {
    try {
      // Step 1: Check basic connectivity status
      final List<ConnectivityResult> connectivityResults =
          await _connectivity.checkConnectivity();

      // If completely disconnected, no need to test further
      if (connectivityResults.contains(ConnectivityResult.none) ||
          connectivityResults.isEmpty) {
        return false;
      }

      // Step 2: Actual internet connectivity test
      return await _performInternetConnectivityTest();
    } catch (e) {
      // If connectivity check itself fails, assume no connection
      return false;
    }
  }

  /// Performs actual internet connectivity test with multiple fallbacks
  Future<bool> _performInternetConnectivityTest() async {
    // List of reliable test endpoints
    final testTargets = [
      {'host': 'google.com', 'port': 443},
      {'host': '8.8.8.8', 'port': 53}, // Google DNS
      {'host': '1.1.1.1', 'port': 53}, // Cloudflare DNS
      {'host': 'cloudflare.com', 'port': 443},
    ];

    // Try each target with timeout
    for (final target in testTargets) {
      try {
        final socket = await Socket.connect(
          target['host'] as String,
          target['port'] as int,
          timeout: const Duration(seconds: 3),
        );

        // Connection successful
        socket.destroy();
        return true;
      } catch (e) {
        // Continue to next target if this one fails
        continue;
      }
    }

    // If all targets fail, try DNS lookup as fallback
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 2));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    stopMonitoring();
    _connectivityController.close();
  }

  @override
  void onClose() {
    dispose();
    super.onClose();
  }
}
