import 'dart:io';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../models/auth_models.dart';

class DeviceUtils {
  static final GetStorage _storage = GetStorage();

  /// Generate unique device fingerprint
  static Future<String> generateDeviceFingerprint() async {
    // Check if fingerprint already exists
    String? existingFingerprint = _storage.read('device_fingerprint');
    if (existingFingerprint != null && existingFingerprint.isNotEmpty) {
      return existingFingerprint;
    }

    // Create a unique identifier based on available information
    final platform = Platform.operatingSystem;
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = (timestamp.hashCode % 100000).toString();

    // Create fingerprint from available data
    final fingerprintData = '$platform-$timestamp-$random';
    final bytes = utf8.encode(fingerprintData);
    final fingerprint = sha256.convert(bytes).toString().substring(0, 32);

    // Store fingerprint for future use
    await _storage.write('device_fingerprint', fingerprint);

    return fingerprint;
  }

  /// Get comprehensive device information
  static Future<DeviceInfo> getDeviceInfo() async {
    final fingerprint = await generateDeviceFingerprint();

    String platform = Platform.operatingSystem;
    String version = 'Unknown';
    String model = 'Unknown';

    // Set platform-specific defaults
    if (Platform.isAndroid) {
      platform = 'Android';
      version = 'Android';
      model = 'Android Device';
    } else if (Platform.isIOS) {
      platform = 'iOS';
      version = 'iOS';
      model = 'iOS Device';
    }

    return DeviceInfo(
      fingerprint: fingerprint,
      platform: platform,
      version: version,
      model: model,
    );
  }

  /// Clear stored device fingerprint (for testing purposes)
  static Future<void> clearDeviceFingerprint() async {
    await _storage.remove('device_fingerprint');
  }

  /// Get platform-specific device headers for API calls
  static Future<Map<String, String>> getDeviceHeaders() async {
    final deviceInfo = await getDeviceInfo();
    return deviceInfo.toHeaders();
  }
}
