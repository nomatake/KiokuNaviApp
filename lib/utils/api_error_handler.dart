import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/services/api/base_api_client.dart';
import 'package:kioku_navi/widgets/custom_snackbar.dart';

/// Utility class for handling API errors and displaying appropriate messages
class ApiErrorHandler {
  /// Check if error is a technical/network error that should be handled globally
  static bool isTechnicalError(dynamic error) {
    return error is NetworkException ||
        error is TimeoutException ||
        error is NoInternetException ||
        error is UnauthorizedException;
  }

  /// Show appropriate snackbar for technical errors
  static void showTechnicalErrorSnackbar(dynamic error) {
    final errorInfo = _getErrorInfo(error);

    CustomSnackbar.showError(
      title: errorInfo.title,
      message: errorInfo.message,
    );
  }

  /// Get error information (title and message) for any error type
  static ErrorInfo _getErrorInfo(dynamic error) {
    String title = LocaleKeys.common_errors_connectionError.tr;
    String message = LocaleKeys.common_errors_checkInternetConnection.tr;

    if (error is ApiException && error.originalException != null) {
      final dioError = error.originalException!;

      if (error is NetworkException) {
        return _getNetworkErrorInfo(dioError);
      } else if (error is TimeoutException) {
        return ErrorInfo(
          title: LocaleKeys.common_errors_requestTimeout.tr,
          message: LocaleKeys.common_errors_serverTakingTooLong.tr,
        );
      } else if (error is UnauthorizedException) {
        return ErrorInfo(
          title: LocaleKeys.common_errors_sessionExpired.tr,
          message: LocaleKeys.common_errors_sessionExpiredMessage.tr,
        );
      } else if (error is ServerException) {
        return _getServerErrorInfo(error);
      }
    } else {
      // Fallback for errors without DioException
      if (error is NetworkException) {
        return ErrorInfo(
          title: LocaleKeys.common_errors_networkError.tr,
          message: LocaleKeys.common_errors_unableToConnectToServer.tr,
        );
      } else if (error is TimeoutException) {
        return ErrorInfo(
          title: LocaleKeys.common_errors_timeoutError.tr,
          message: LocaleKeys.common_errors_requestTimedOut.tr,
        );
      } else if (error is UnauthorizedException) {
        return ErrorInfo(
          title: LocaleKeys.common_errors_sessionExpired.tr,
          message: LocaleKeys.common_errors_pleaseLoginAgain.tr,
        );
      }
    }

    return ErrorInfo(title: title, message: message);
  }

  /// Get specific error info for network errors based on DioException details
  static ErrorInfo _getNetworkErrorInfo(DioException dioError) {
    final title = LocaleKeys.common_errors_networkError.tr;

    if (dioError.message?.contains('Connection refused') == true) {
      return ErrorInfo(
        title: title,
        message: LocaleKeys.common_errors_serverTemporarilyUnavailable.tr,
      );
    } else if (dioError.message?.contains('Failed host lookup') == true) {
      return ErrorInfo(
        title: title,
        message: LocaleKeys.common_errors_cannotReachServer.tr,
      );
    } else {
      return ErrorInfo(
        title: title,
        message: LocaleKeys.common_errors_networkConnectionFailed.tr,
      );
    }
  }

  /// Get specific error info for server errors
  static ErrorInfo _getServerErrorInfo(ServerException error) {
    String title = LocaleKeys.common_errors_networkError.tr;
    String message = error.message.isNotEmpty
        ? error.message
        : LocaleKeys.common_errors_unableToConnectToServer.tr;

    // Add status code context if available
    if (error.statusCode != null) {
      switch (error.statusCode) {
        case 500:
          title = LocaleKeys.common_errors_networkError.tr;
          message = LocaleKeys.common_errors_unableToConnectToServer.tr;
          break;
        case 503:
          title = LocaleKeys.common_errors_networkError.tr;
          message = LocaleKeys.common_errors_serverTemporarilyUnavailable.tr;
          break;
        default:
          if (error.statusCode! >= 400 && error.statusCode! < 500) {
            title = LocaleKeys.common_errors_networkError.tr;
          }
      }
    }

    return ErrorInfo(title: title, message: message);
  }

  /// Get the original DioException from an ApiException for custom handling
  static DioException? getDioException(dynamic error) {
    if (error is ApiException) {
      return error.originalException;
    }
    return null;
  }

  /// Check if error has a specific status code
  static bool hasStatusCode(dynamic error, int statusCode) {
    if (error is ApiException) {
      return error.statusCode == statusCode;
    }
    return false;
  }

  /// Get response data from the error for custom handling
  static dynamic getErrorResponseData(dynamic error) {
    final dioError = getDioException(error);
    return dioError?.response?.data;
  }

  /// Get error message from server response
  static String? getServerErrorMessage(dynamic error) {
    final responseData = getErrorResponseData(error);
    if (responseData is Map<String, dynamic>) {
      return responseData['message'] ??
          responseData['error'] ??
          responseData['errors']?.toString();
    }
    return null;
  }
}

/// Data class for error information
class ErrorInfo {
  final String title;
  final String message;

  ErrorInfo({required this.title, required this.message});
}
