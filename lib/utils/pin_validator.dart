/// PIN validation utilities for child authentication
class PinValidator {
  /// Validates a PIN according to security rules
  static String? validatePin(String? pin) {
    if (pin == null || pin.isEmpty) {
      return 'Please enter a PIN';
    }

    if (pin.length < 4) {
      return 'PIN must be at least 4 digits';
    }

    if (pin.length > 6) {
      return 'PIN must be at most 6 digits';
    }

    // Check if PIN contains only numbers
    if (!RegExp(r'^\d+$').hasMatch(pin)) {
      return 'PIN must contain only numbers';
    }

    // Check for consecutive numbers (ascending)
    if (_hasConsecutiveNumbers(pin, ascending: true)) {
      return 'PIN cannot contain consecutive numbers (e.g., 1234)';
    }

    // Check for consecutive numbers (descending)
    if (_hasConsecutiveNumbers(pin, ascending: false)) {
      return 'PIN cannot contain consecutive numbers (e.g., 4321)';
    }

    // Check for repeated digits (like 1111, 2222)
    if (_hasRepeatedDigits(pin)) {
      return 'PIN cannot be all the same digit (e.g., 1111)';
    }

    // Check for common weak patterns
    if (_isWeakPattern(pin)) {
      return 'Please choose a stronger PIN pattern';
    }

    return null; // PIN is valid
  }

  /// Checks for consecutive numbers in ascending or descending order
  static bool _hasConsecutiveNumbers(String pin, {required bool ascending}) {
    if (pin.length < 3) return false;

    for (int i = 0; i < pin.length - 2; i++) {
      final first = int.parse(pin[i]);
      final second = int.parse(pin[i + 1]);
      final third = int.parse(pin[i + 2]);

      if (ascending) {
        // Check for ascending consecutive (e.g., 123, 234, 345)
        if (second == first + 1 && third == second + 1) {
          return true;
        }
      } else {
        // Check for descending consecutive (e.g., 321, 432, 543)
        if (second == first - 1 && third == second - 1) {
          return true;
        }
      }
    }

    return false;
  }

  /// Checks if PIN has all repeated digits
  static bool _hasRepeatedDigits(String pin) {
    if (pin.length < 4) return false;

    final firstDigit = pin[0];
    return pin.split('').every((digit) => digit == firstDigit);
  }

  /// Checks for other weak patterns
  static bool _isWeakPattern(String pin) {
    // Common weak patterns
    final weakPatterns = [
      '0000',
      '1111',
      '2222',
      '3333',
      '4444',
      '5555',
      '6666',
      '7777',
      '8888',
      '9999',
      '1234',
      '2345',
      '3456',
      '4567',
      '5678',
      '6789',
      '7890',
      '4321',
      '5432',
      '6543',
      '7654',
      '8765',
      '9876',
      '0987',
      '1122',
      '2233',
      '3344',
      '4455',
      '5566',
      '6677',
      '7788',
      '8899',
      '9900',
      '1212',
      '2323',
      '3434',
      '4545',
      '5656',
      '6767',
      '7878',
      '8989',
      '9090',
      '1010',
      '2020',
      '3030',
      '4040',
      '5050',
      '6060',
      '7070',
      '8080',
      '9090',
    ];

    return weakPatterns.any((pattern) => pin.contains(pattern));
  }

  /// Gets a user-friendly validation message with examples
  static String getValidationHint() {
    return 'Choose a secure PIN:\n'
        '• 4-6 digits only\n'
        '• No consecutive numbers (1234, 4321)\n'
        '• No repeated digits (1111, 2222)\n'
        '• Avoid common patterns\n'
        '• Make it memorable but unique to you';
  }

  /// Checks if two PINs match (for confirmation)
  static String? validatePinConfirmation(String? pin, String? confirmation) {
    if (confirmation == null || confirmation.isEmpty) {
      return 'Please confirm your PIN';
    }

    if (pin != confirmation) {
      return 'PINs do not match';
    }

    return null;
  }
}

/// Result of PIN validation
class PinValidationResult {
  final bool isValid;
  final List<String> errors;

  PinValidationResult({
    required this.isValid,
    required this.errors,
  });

  String get firstError => errors.isNotEmpty ? errors.first : '';
  String get allErrors => errors.join(', ');
  bool get hasErrors => errors.isNotEmpty;
}
