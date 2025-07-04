import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ErrorType {
  network,
  validation,
  authentication,
  authorization,
  server,
  unknown
}

class AppError {
  final ErrorType type;
  final String message;
  final String? details;
  final int? statusCode;
  final DateTime timestamp;

  AppError({
    required this.type,
    required this.message,
    this.details,
    this.statusCode,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'AppError(type: $type, message: $message, code: $statusCode)';
  }
}

class ErrorManager extends GetxService {
  static ErrorManager get instance => Get.find<ErrorManager>();

  final RxList<AppError> _errors = <AppError>[].obs;
  final RxBool _hasActiveError = false.obs;

  List<AppError> get errors => _errors;
  bool get hasActiveError => _hasActiveError.value;

  void handleError(dynamic error, {ErrorType? type, String? customMessage}) {
    final errorType = type ?? _determineErrorType(error);
    final message = customMessage ?? _getErrorMessage(error);
    
    final appError = AppError(
      type: errorType,
      message: message,
      details: error.toString(),
      statusCode: _getStatusCode(error),
    );

    _errors.add(appError);
    _hasActiveError.value = true;

    debugPrint('Error logged: $appError');
    
    // Show user-friendly error message
    _showErrorToUser(appError);
  }

  void clearError() {
    _hasActiveError.value = false;
  }

  void clearAllErrors() {
    _errors.clear();
    _hasActiveError.value = false;
  }

  ErrorType _determineErrorType(dynamic error) {
    if (error is String) {
      if (error.toLowerCase().contains('network') || 
          error.toLowerCase().contains('connection')) {
        return ErrorType.network;
      }
      if (error.toLowerCase().contains('validation')) {
        return ErrorType.validation;
      }
      if (error.toLowerCase().contains('unauthorized')) {
        return ErrorType.authentication;
      }
      if (error.toLowerCase().contains('forbidden')) {
        return ErrorType.authorization;
      }
    }
    return ErrorType.unknown;
  }

  String _getErrorMessage(dynamic error) {
    if (error is String) return error;
    if (error is Exception) return error.toString();
    return 'An unexpected error occurred';
  }

  int? _getStatusCode(dynamic error) {
    // This would be implemented based on your HTTP client
    // For now, return null as we're not using HTTP yet
    return null;
  }

  void _showErrorToUser(AppError error) {
    final userMessage = _getUserFriendlyMessage(error);
    
    // Show snackbar with user-friendly message
    Get.snackbar(
      _getErrorTitle(error.type),
      userMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: _getErrorColor(error.type),
      colorText: Get.theme.colorScheme.onError,
      duration: const Duration(seconds: 3),
    );
  }

  String _getUserFriendlyMessage(AppError error) {
    switch (error.type) {
      case ErrorType.network:
        return 'ネットワークエラーが発生しました。接続を確認してください。';
      case ErrorType.validation:
        return '入力内容に誤りがあります。確認してください。';
      case ErrorType.authentication:
        return 'ログイン情報が正しくありません。';
      case ErrorType.authorization:
        return 'この操作を行う権限がありません。';
      case ErrorType.server:
        return 'サーバーエラーが発生しました。しばらく待ってから再試行してください。';
      case ErrorType.unknown:
        return 'エラーが発生しました。しばらく待ってから再試行してください。';
    }
  }

  String _getErrorTitle(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return 'ネットワークエラー';
      case ErrorType.validation:
        return '入力エラー';
      case ErrorType.authentication:
        return 'ログインエラー';
      case ErrorType.authorization:
        return 'アクセスエラー';
      case ErrorType.server:
        return 'サーバーエラー';
      case ErrorType.unknown:
        return 'エラー';
    }
  }

  Color _getErrorColor(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Get.theme.colorScheme.error;
      case ErrorType.validation:
        return Get.theme.colorScheme.error;
      case ErrorType.authentication:
        return Get.theme.colorScheme.error;
      case ErrorType.authorization:
        return Get.theme.colorScheme.error;
      case ErrorType.server:
        return Get.theme.colorScheme.error;
      case ErrorType.unknown:
        return Get.theme.colorScheme.error;
    }
  }
}