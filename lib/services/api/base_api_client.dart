import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kioku_navi/utils/constants.dart';

// Custom exceptions for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? details;

  ApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class NetworkException extends ApiException {
  NetworkException(super.message);
}

class TimeoutException extends ApiException {
  TimeoutException(super.message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException() : super('Unauthorized access');
}

class ServerException extends ApiException {
  ServerException(super.message, {super.statusCode});
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
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(kMessageTimeout);

      case DioExceptionType.connectionError:
        return NetworkException(kMessageNetworkError);

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 401:
            return UnauthorizedException();
          case 403:
            return ApiException(kMessageForbidden, statusCode: statusCode);
          case 404:
            return ApiException(kMessageNotFound, statusCode: statusCode);
          case 422:
            return ApiException(kMessageValidationError,
                statusCode: statusCode);
          case 500:
            return ServerException(kMessageServerError, statusCode: statusCode);
          case 503:
            return ServerException(kMessageServerError, statusCode: statusCode);
          default:
            return ServerException(
              error.response?.data?['message'] ?? kMessageServerError,
              statusCode: statusCode,
            );
        }

      case DioExceptionType.cancel:
        return ApiException(kMessageCancel);

      case DioExceptionType.unknown:
      default:
        return NetworkException(kMessageNetworkError);
    }
  }

  // Get the underlying Dio instance (for advanced usage)
  Dio get dio => _dio;
}
