import 'package:dio/dio.dart';
import 'package:kioku_navi/utils/constants.dart';
import 'package:flutter/foundation.dart';

// Custom exceptions
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  
  ApiException(this.message, [this.statusCode]);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException() : super('Unauthorized', 401);
}

class NotFoundException extends ApiException {
  NotFoundException() : super('Not Found', 404);
}

class ValidationException extends ApiException {
  final Map<String, dynamic> errors;
  
  ValidationException(this.errors) : super('Validation failed', 422);
}

class ServerException extends ApiException {
  ServerException(String message) : super(message, 500);
}

class BaseApiClient {
  late final Dio dio;
  
  BaseApiClient({
    Dio? dio,
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) {
    this.dio = dio ?? Dio(BaseOptions(
      baseUrl: baseUrl ?? kBaseUrl,
      connectTimeout: connectTimeout ?? const Duration(seconds: 30),
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    if (kDebugMode) {
      this.dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }
  
  Future<T> get<T>(String endpoint, {
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    try {
      final response = await dio.get<T>(
        endpoint,
        queryParameters: queryParams,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<T> post<T>(String endpoint, {
    dynamic data,
    Options? options,
  }) async {
    try {
      final response = await dio.post<T>(
        endpoint,
        data: data,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<T> put<T>(String endpoint, {
    dynamic data,
    Options? options,
  }) async {
    try {
      final response = await dio.put<T>(
        endpoint,
        data: data,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<T> delete<T>(String endpoint, {
    Options? options,
  }) async {
    try {
      final response = await dio.delete<T>(
        endpoint,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Connection timeout');
      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);
      case DioExceptionType.cancel:
        return ApiException('Request cancelled');
      default:
        return ApiException('Network error: ${error.message}');
    }
  }
  
  Exception _handleResponseError(Response? response) {
    final statusCode = response?.statusCode;
    final message = response?.data?['message'] ?? 'Unknown error';
    
    switch (statusCode) {
      case 401:
        return UnauthorizedException();
      case 404:
        return NotFoundException();
      case 422:
        return ValidationException(response?.data?['errors'] ?? {});
      case 500:
        return ServerException(message);
      default:
        return ApiException(message, statusCode);
    }
  }
}