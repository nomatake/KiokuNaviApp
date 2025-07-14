import 'package:get/get.dart';

/// A utility class to safely extract navigation arguments
class NavigationArgs {
  final Map<String, dynamic> _args;

  NavigationArgs([Map<String, dynamic>? args]) 
      : _args = args ?? Get.arguments as Map<String, dynamic>? ?? {};

  /// Factory constructor to create from current Get.arguments
  factory NavigationArgs.current() => NavigationArgs();

  /// Get a typed value with a default
  T get<T>(String key, {required T defaultValue}) {
    try {
      final value = _args[key];
      if (value == null) return defaultValue;
      if (value is T) return value;
      return defaultValue;
    } catch (_) {
      return defaultValue;
    }
  }

  /// Get a nullable typed value
  T? getOrNull<T>(String key) {
    try {
      final value = _args[key];
      if (value is T) return value;
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Get a String value
  String getString(String key, {String defaultValue = ''}) {
    return get<String>(key, defaultValue: defaultValue);
  }

  /// Get an int value
  int getInt(String key, {int defaultValue = 0}) {
    final value = _args[key];
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  /// Get a double value
  double getDouble(String key, {double defaultValue = 0.0}) {
    final value = _args[key];
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  /// Get a bool value
  bool getBool(String key, {bool defaultValue = false}) {
    final value = _args[key];
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is int) return value != 0;
    return defaultValue;
  }

  /// Get a Map value
  Map<String, dynamic> getMap(String key, {Map<String, dynamic>? defaultValue}) {
    final value = _args[key];
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      try {
        return Map<String, dynamic>.from(value);
      } catch (_) {
        return defaultValue ?? {};
      }
    }
    return defaultValue ?? {};
  }

  /// Get a List value
  List<T> getList<T>(String key, {List<T>? defaultValue}) {
    final value = _args[key];
    if (value is List<T>) return value;
    if (value is List) {
      try {
        return List<T>.from(value);
      } catch (_) {
        return defaultValue ?? [];
      }
    }
    return defaultValue ?? [];
  }

  /// Get a DateTime value
  DateTime? getDateTime(String key) {
    final value = _args[key];
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  /// Check if a key exists
  bool containsKey(String key) => _args.containsKey(key);

  /// Check if arguments are empty
  bool get isEmpty => _args.isEmpty;

  /// Check if arguments are not empty
  bool get isNotEmpty => _args.isNotEmpty;

  /// Get all arguments (read-only)
  Map<String, dynamic> get all => Map.unmodifiable(_args);

  /// Get the raw arguments map
  Map<String, dynamic> get raw => _args;
}

/// Extension method for easy access
extension NavigationArgsExtension on GetInterface {
  /// Get navigation arguments utility
  NavigationArgs get navArgs => NavigationArgs.current();
}