/// Exception for client-side validation errors (not API errors)
///
/// This exception is used to distinguish between form validation errors
/// and actual API response errors in the error handling flow.
class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);

  @override
  String toString() => message;
}
