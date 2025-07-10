import 'dart:async';

import 'package:get/get.dart' as getx;
import 'package:kioku_navi/services/connectivity/connectivity_service.dart';
import 'package:kioku_navi/widgets/connectivity/no_internet_bottom_sheet.dart';

/// Global connectivity manager that handles app-wide connectivity changes
/// Shows a bottom sheet when internet is not available
class ConnectivityManager extends getx.GetxController {
  final ConnectivityService _connectivityService;

  StreamSubscription<bool>? _connectivitySubscription;
  bool _isMonitoring = false;
  DateTime? _lastBottomSheetShown;

  ConnectivityManager(this._connectivityService);

  /// Start monitoring - only call when actively needed
  void startMonitoring() {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _connectivitySubscription = _connectivityService.connectivityStream.listen(
      (isConnected) {
        _handleConnectivityChange(isConnected);
      },
    );
  }

  /// Stop monitoring to save battery
  void stopMonitoring() {
    _isMonitoring = false;
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  /// Check connectivity once without starting monitoring
  Future<bool> checkConnectivity() async {
    return await _connectivityService.hasInternetConnection();
  }

  /// Check and show bottom sheet if no internet, returns true if connected
  Future<bool> checkAndShowNoInternetIfNeeded() async {
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      _showNoInternetBottomSheet();
    }
    return isConnected;
  }

  void _handleConnectivityChange(bool isConnected) {
    if (!isConnected) {
      _showNoInternetBottomSheet();
    }
    // Note: We don't auto-hide bottom sheet when connection is restored
    // User can manually close it with OK button
  }

  void _showNoInternetBottomSheet() {
    final now = DateTime.now();

    // Prevent showing multiple bottom sheets within 2 seconds
    if (_lastBottomSheetShown != null &&
        now.difference(_lastBottomSheetShown!).inSeconds < 2) {
      return;
    }

    _lastBottomSheetShown = now;
    NoInternetBottomSheet.show();
  }

  @override
  void onClose() {
    stopMonitoring();
    super.onClose();
  }
}
