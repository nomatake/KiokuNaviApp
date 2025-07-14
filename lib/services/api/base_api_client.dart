import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kioku_navi/utils/constants.dart';

// Custom exceptions for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? details;
  final DioException? originalException;

  ApiException(this.message,
      {this.statusCode, this.details, this.originalException});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class NetworkException extends ApiException {
  NetworkException(super.message, {super.originalException});
}

class NoInternetException extends ApiException {
  NoInternetException() : super('No internet connection available');
}

class TimeoutException extends ApiException {
  TimeoutException(super.message, {super.originalException});
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({super.originalException})
      : super('Unauthorized access', statusCode: 401);
}

class ServerException extends ApiException {
  ServerException(super.message, {super.statusCode, super.originalException});
}

class BaseApiClient {
  late final Dio _dio;

  // Singleton pattern
  static BaseApiClient? _instance;

  BaseApiClient._internal() {
    _initializeDio();
  }

  factory BaseApiClient() {
    _instance ??= BaseApiClient._internal();
    return _instance!;
  }

  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: kBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }

    // Note: Error handling is done in the individual method catch blocks
    // to avoid double processing
  }

  // Add interceptor (used for AuthInterceptor)
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  // GET request
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // POST request
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // PUT request
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // DELETE request
  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Handle successful responses
  T _handleResponse<T>(Response<T> response) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response.data as T;
    } else {
      throw ServerException(
        'Server returned ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }

  // Handle Dio errors and convert to custom exceptions
  Exception _handleDioError(DioException error) {
    // Check if error is due to no internet connection
    if (error.error is NoInternetException) {
      return error.error as NoInternetException;
    }

    if (kDebugMode) {
      print(
          'DioError - Type: ${error.type}, Status: ${error.response?.statusCode}');
      print('Response: ${error.response?.data}');
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(kMessageTimeout, originalException: error);

      case DioExceptionType.connectionError:
        return NetworkException(kMessageNetworkError, originalException: error);

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.cancel:
        return ApiException(kMessageCancel, originalException: error);

      case DioExceptionType.unknown:
      default:
        return NetworkException(kMessageNetworkError, originalException: error);
    }
  }

  // Handle bad response errors (4xx, 5xx status codes)
  Exception _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    // Extract server message
    String? serverMessage;
    if (responseData is Map<String, dynamic>) {
      serverMessage = responseData['message'] ?? responseData['error'];
    }

    switch (statusCode) {
      case 401:
        final message = serverMessage ?? 'Invalid credentials';
        return ApiException(message,
            statusCode: statusCode, originalException: error);
      case 403:
        final message = serverMessage ?? kMessageForbidden;
        return ApiException(message,
            statusCode: statusCode, originalException: error);
      case 404:
        final message = serverMessage ?? kMessageNotFound;
        return ApiException(message,
            statusCode: statusCode, originalException: error);
      case 422:
        final message = serverMessage ?? kMessageValidationError;
        return ApiException(message,
            statusCode: statusCode, originalException: error);
      case 500:
        final message = serverMessage ?? kMessageServerError;
        return ServerException(message,
            statusCode: statusCode, originalException: error);
      case 503:
        final message = serverMessage ?? 'Service temporarily unavailable';
        return ServerException(message,
            statusCode: statusCode, originalException: error);
      default:
        // For other HTTP error codes
        final message = serverMessage ?? 'Server error occurred';
        if (statusCode != null && statusCode >= 500) {
          return ServerException(message,
              statusCode: statusCode, originalException: error);
        } else {
          return ApiException(message,
              statusCode: statusCode, originalException: error);
        }
    }
  }

  // Get the underlying Dio instance (for advanced usage)
  Dio get dio => _dio;
}
