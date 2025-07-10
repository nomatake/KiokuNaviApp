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

    // Add error handling interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        final exception = _handleDioError(error);
        handler.reject(DioException(
          requestOptions: error.requestOptions,
          error: exception,
        ));
      },
    ));
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

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(kMessageTimeout, originalException: error);

      case DioExceptionType.connectionError:
        return NetworkException(kMessageNetworkError, originalException: error);

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 401:
            return UnauthorizedException(originalException: error);
          case 403:
            return ApiException(kMessageForbidden,
                statusCode: statusCode, originalException: error);
          case 404:
            return ApiException(kMessageNotFound,
                statusCode: statusCode, originalException: error);
          case 422:
            return ApiException(kMessageValidationError,
                statusCode: statusCode, originalException: error);
          case 500:
            return ServerException(kMessageServerError,
                statusCode: statusCode, originalException: error);
          case 503:
            return ServerException(kMessageServerError,
                statusCode: statusCode, originalException: error);
          default:
            // Try to get error message from response data
            String errorMessage = kMessageServerError;
            if (error.response?.data != null) {
              final responseData = error.response!.data;
              if (responseData is Map<String, dynamic>) {
                errorMessage = responseData['message'] ??
                    responseData['error'] ??
                    responseData['errors']?.toString() ??
                    kMessageServerError;
              }
            }
            return ServerException(errorMessage,
                statusCode: statusCode, originalException: error);
        }

      case DioExceptionType.cancel:
        return ApiException(kMessageCancel, originalException: error);

      case DioExceptionType.unknown:
      default:
        return NetworkException(kMessageNetworkError, originalException: error);
    }
  }

  // Get the underlying Dio instance (for advanced usage)
  Dio get dio => _dio;
}
