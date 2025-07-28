/// PIN validation utilities for child authentication
class PinValidator {
  /// Validate PIN length (4-6 digits)
  static bool isValidLength(String pin) {
    return pin.length >= 4 && pin.length <= 6;
  }

  /// Check if PIN contains only numeric characters
  static bool isNumeric(String pin) {
    return RegExp(r'^\d+$').hasMatch(pin);
  }

  /// Check for consecutive numbers (e.g., 1234, 4321)
  static bool hasNoConsecutiveNumbers(String pin) {
    if (pin.length < 2) return true;

    for (int i = 0; i < pin.length - 1; i++) {
      final current = int.tryParse(pin[i]);
      final next = int.tryParse(pin[i + 1]);

      if (current == null || next == null) continue;

      // Check for ascending consecutive (1234)
      if (next == current + 1) {
        // Check if it's part of a longer sequence
        if (i == 0 || (i > 0 && int.tryParse(pin[i - 1]) != current - 1)) {
          // This is the start of a sequence, check if it continues
          int sequenceLength = 2;
          for (int j = i + 2; j < pin.length; j++) {
            final nextNext = int.tryParse(pin[j]);
            if (nextNext == current + sequenceLength) {
              sequenceLength++;
            } else {
              break;
            }
          }
          if (sequenceLength >= 3) return false;
        }
      }

      // Check for descending consecutive (4321)
      if (next == current - 1) {
        // Check if it's part of a longer sequence
        if (i == 0 || (i > 0 && int.tryParse(pin[i - 1]) != current + 1)) {
          // This is the start of a sequence, check if it continues
          int sequenceLength = 2;
          for (int j = i + 2; j < pin.length; j++) {
            final nextNext = int.tryParse(pin[j]);
            if (nextNext == current - sequenceLength) {
              sequenceLength++;
            } else {
              break;
            }
          }
          if (sequenceLength >= 3) return false;
        }
      }
    }

    return true;
  }

  /// Check for maximum 3 repeated digits (e.g., 1112 ❌, 1123 ✅)
  static bool hasAcceptableRepetition(String pin) {
    Map<String, int> digitCounts = {};

    for (String digit in pin.split('')) {
      digitCounts[digit] = (digitCounts[digit] ?? 0) + 1;
      if (digitCounts[digit]! > 3) {
        return false;
      }
    }

    return true;
  }

  /// Comprehensive PIN validation
  static PinValidationResult validate(String pin) {
    List<String> errors = [];

    if (!isValidLength(pin)) {
      errors.add('PIN must be 4-6 digits long');
    }

    if (!isNumeric(pin)) {
      errors.add('PIN must contain only numbers');
    }

    if (!hasNoConsecutiveNumbers(pin)) {
      errors.add('PIN cannot contain consecutive numbers (e.g., 1234, 4321)');
    }

    if (!hasAcceptableRepetition(pin)) {
      errors.add('PIN cannot have more than 3 repeated digits');
    }

    return PinValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Quick validation check (returns true if valid)
  static bool isValid(String pin) {
    return validate(pin).isValid;
  }

  /// Get PIN security requirements as user-friendly text
  static List<String> getSecurityRequirements() {
    return [
      '4-6 digits only',
      'No consecutive numbers (1234, 4321)',
      'No more than 3 repeated digits',
      'Numbers only',
    ];
  }

  /// Check if PIN meets minimum security standards
  static bool meetsMinimumSecurity(String pin) {
    final result = validate(pin);
    return result.isValid && pin.length >= 4;
  }

  /// Generate suggestions for PIN improvement
  static List<String> getSuggestions(String pin) {
    List<String> suggestions = [];

    if (pin.length < 4) {
      suggestions.add('Add more digits (minimum 4)');
    }

    if (!isNumeric(pin)) {
      suggestions.add('Use only numbers');
    }

    if (!hasNoConsecutiveNumbers(pin)) {
      suggestions.add('Avoid sequences like 1234 or 4321');
    }

    if (!hasAcceptableRepetition(pin)) {
      suggestions.add('Use no more than 3 of the same digit');
    }

    if (suggestions.isEmpty) {
      suggestions.add('PIN looks good!');
    }

    return suggestions;
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
