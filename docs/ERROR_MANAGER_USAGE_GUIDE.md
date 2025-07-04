# 🛡️ ErrorManager Usage Guide - KiokuNaviApp

**Version**: 1.0  
**Date**: 2025-07-04  
**Author**: Phase 3 Optimization Implementation  

---

## 📋 Overview

This guide provides comprehensive examples and best practices for using the ErrorManager system implemented in Phase 3 optimization. The ErrorManager provides centralized error handling with Japanese localization and automatic user notifications.

---

## 🚀 Quick Start

### **Basic Setup**

The ErrorManager is already initialized in `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ErrorManager is automatically available
  Get.put(ErrorManager());
  
  runApp(const MyApp());
}
```

### **Access ErrorManager**

```dart
// Access the ErrorManager instance anywhere in your app
ErrorManager.instance.handleError('エラーメッセージ');
```

---

## 🔧 Usage Examples

### **1. Basic Error Handling in Controllers**

```dart
// In any controller that extends BaseController
class AuthController extends BaseController {
  
  void onLogin() {
    safeCall(() async {
      // Simulate login validation
      if (email.text.isEmpty) {
        throw 'メールアドレスを入力してください';
      }
      
      if (password.text.length < 6) {
        throw 'パスワードは6文字以上で入力してください';
      }
      
      // Simulate API call (replace with actual implementation)
      await Future.delayed(Duration(seconds: 2));
      
      // If successful, navigate
      requestNavigation(Routes.HOME);
      
    }, errorMessage: 'ログインに失敗しました。もう一度お試しください。');
  }
  
  void onRegister() {
    safeCall(() async {
      if (!registerFormKey.currentState!.validate()) {
        throw 'すべての必須項目を正しく入力してください';
      }
      
      // Registration logic here
      await Future.delayed(Duration(seconds: 2));
      
      // Success - navigate to next screen
      requestNavigation(Routes.TUTORIAL);
      
    }, errorMessage: '登録に失敗しました。もう一度お試しください。');
  }
}
```

### **2. Using ErrorManager Directly**

```dart
// Direct usage of ErrorManager for specific error types
void validateForm() {
  try {
    if (!registerFormKey.currentState!.validate()) {
      // Validation error
      ErrorManager.instance.handleError(
        'フォームに入力エラーがあります',
        type: ErrorType.validation,
        customMessage: '入力内容を確認してください'
      );
      return;
    }
    
    // Continue with form processing...
    
  } catch (e) {
    // General error
    ErrorManager.instance.handleError(e);
  }
}
```

### **3. Network Error Simulation**

```dart
// Simulate network errors (ready for future API integration)
Future<void> fetchUserData() async {
  try {
    isLoading.value = true;
    
    // Simulate network call
    await Future.delayed(Duration(seconds: 2));
    
    // Simulate different network scenarios:
    
    // Connection timeout
    throw Exception('ネットワーク接続がタイムアウトしました');
    
    // Server error
    // throw Exception('サーバーエラーが発生しました');
    
    // No internet connection
    // throw Exception('インターネット接続を確認してください');
    
  } catch (e) {
    ErrorManager.instance.handleError(
      e,
      type: ErrorType.network,
      customMessage: 'ネットワークエラーが発生しました。接続を確認してください。'
    );
  } finally {
    isLoading.value = false;
  }
}
```

### **4. Form Validation with Custom Error Messages**

```dart
// In a form submission method
void onRegister() {
  safeCall(() async {
    // Check form validation
    if (!registerFormKey.currentState!.validate()) {
      throw 'すべての必須項目を正しく入力してください';
    }
    
    // Check email format
    if (!email.text.contains('@')) {
      ErrorManager.instance.handleError(
        'Invalid email format',
        type: ErrorType.validation,
        customMessage: 'メールアドレスの形式が正しくありません'
      );
      return;
    }
    
    // Check password strength
    if (password.text.length < 8) {
      ErrorManager.instance.handleError(
        'Password too short',
        type: ErrorType.validation,
        customMessage: 'パスワードは8文字以上で入力してください'
      );
      return;
    }
    
    // Check password confirmation
    if (password.text != confirmPassword.text) {
      ErrorManager.instance.handleError(
        'Password mismatch',
        type: ErrorType.validation,
        customMessage: 'パスワードが一致しません'
      );
      return;
    }
    
    // Proceed with registration
    await _processRegistration();
    
  }, errorMessage: '登録に失敗しました。もう一度お試しください。');
}

Future<void> _processRegistration() async {
  // Simulate registration process
  await Future.delayed(Duration(seconds: 2));
  print('Registration successful!');
}
```

### **5. Different Error Types Examples**

```dart
class ExampleController extends BaseController {
  
  // Network errors
  void simulateNetworkError() {
    ErrorManager.instance.handleError(
      'Connection failed',
      type: ErrorType.network
    );
  }
  
  // Validation errors
  void simulateValidationError() {
    ErrorManager.instance.handleError(
      'Invalid input',
      type: ErrorType.validation
    );
  }
  
  // Authentication errors
  void simulateAuthError() {
    ErrorManager.instance.handleError(
      'Invalid credentials',
      type: ErrorType.authentication
    );
  }
  
  // Authorization errors
  void simulateAuthorizationError() {
    ErrorManager.instance.handleError(
      'Access denied',
      type: ErrorType.authorization
    );
  }
  
  // Server errors
  void simulateServerError() {
    ErrorManager.instance.handleError(
      'Internal server error',
      type: ErrorType.server
    );
  }
  
  // Unknown errors
  void simulateUnknownError() {
    ErrorManager.instance.handleError(
      'Something went wrong',
      type: ErrorType.unknown
    );
  }
}
```

### **6. Testing Error Manager with UI**

Create a simple test method to see ErrorManager in action:

```dart
// Add this to any controller for testing
void testErrorManager() {
  // Test different error types with delays
  
  // 1. Network error
  ErrorManager.instance.handleError(
    'Connection timeout',
    type: ErrorType.network
  );
  
  // Wait 4 seconds, then show validation error
  Future.delayed(Duration(seconds: 4), () {
    ErrorManager.instance.handleError(
      'Invalid input detected',
      type: ErrorType.validation
    );
  });
  
  // Wait 8 seconds, then show authentication error
  Future.delayed(Duration(seconds: 8), () {
    ErrorManager.instance.handleError(
      'Unauthorized access',
      type: ErrorType.authentication
    );
  });
  
  // Wait 12 seconds, then show server error
  Future.delayed(Duration(seconds: 12), () {
    ErrorManager.instance.handleError(
      'Server maintenance',
      type: ErrorType.server
    );
  });
}

// Comprehensive error testing
void testAllErrorScenarios() {
  final errorTypes = [
    ErrorType.network,
    ErrorType.validation,
    ErrorType.authentication,
    ErrorType.authorization,
    ErrorType.server,
    ErrorType.unknown,
  ];
  
  for (int i = 0; i < errorTypes.length; i++) {
    Future.delayed(Duration(seconds: i * 3), () {
      ErrorManager.instance.handleError(
        'Test error ${i + 1}',
        type: errorTypes[i],
      );
    });
  }
}
```

### **7. Listening to Error States in UI**

```dart
// In your view widgets, you can listen to error states
class AuthView extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ログイン')),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // Email field
            CustomTextFormField(
              textController: controller.email,
              labelText: 'メールアドレス',
              keyboardType: TextInputType.emailAddress,
              customValidators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ],
            ),
            
            SizedBox(height: AppSpacing.md),
            
            // Password field
            CustomTextFormField(
              textController: controller.password,
              labelText: 'パスワード',
              isPassword: true,
              customValidators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(6),
              ],
            ),
            
            SizedBox(height: AppSpacing.lg),
            
            // Loading indicator
            Obx(() => controller.isLoading.value 
              ? Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: CircularProgressIndicator(),
                )
              : SizedBox.shrink()),
            
            // Error display (optional, since ErrorManager shows snackbars)
            Obx(() => controller.hasError.value
              ? Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSpacing.md),
                  margin: EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          controller.error.value,
                          style: TextStyle(
                            color: Colors.red.shade800,
                            fontSize: AppFontSize.caption,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: AppIconSize.sm),
                        onPressed: controller.clearError,
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink()),
            
            // Login button
            CustomButton.primary(
              text: 'ログイン',
              onPressed: controller.onLogin,
              semanticsLabel: 'ログインボタン',
              semanticsHint: 'タップしてログインします',
            ),
            
            SizedBox(height: AppSpacing.md),
            
            // Test error button (remove in production)
            CustomButton.secondary(
              text: 'エラーテスト',
              onPressed: controller.testErrorManager,
              semanticsLabel: 'エラーテストボタン',
              semanticsHint: '異なるエラータイプをテストします',
            ),
          ],
        ),
      ),
    );
  }
}
```

### **8. Clearing Errors**

```dart
// Clear errors when needed
void clearAllErrors() {
  // Clear controller-specific errors
  clearError();
  
  // Clear ErrorManager errors
  ErrorManager.instance.clearAllErrors();
}

// Clear errors when user starts typing (for better UX)
void onEmailChanged(String value) {
  if (hasError.value) {
    clearError();
  }
  email.text = value;
}

// Clear errors when navigating away
@override
void onClose() {
  clearAllErrors();
  super.onClose();
}
```

### **9. Course-Specific Error Handling**

```dart
// In ChildHomeController or LearningController
class ChildHomeController extends BaseController {
  
  void onSectionTapped(CourseSection section) {
    safeCall(() async {
      // Check if section is accessible
      if (section.nodes.every((node) => node.completionPercentage == 0)) {
        throw '前のセクションを完了してください';
      }
      
      // Check user progress
      if (!_hasRequiredProgress(section)) {
        ErrorManager.instance.handleError(
          'Insufficient progress',
          type: ErrorType.authorization,
          customMessage: 'このセクションにアクセスするには、前のレッスンを完了してください'
        );
        return;
      }
      
      // Navigate to section
      requestNavigation(Routes.QUESTION);
      
    }, errorMessage: 'セクションの読み込みに失敗しました');
  }
  
  bool _hasRequiredProgress(CourseSection section) {
    // Check if user has completed required prerequisites
    return true; // Implement your logic here
  }
  
  void updateNodeProgress(int sectionIndex, int nodeIndex, double progress) {
    safeCall(() async {
      if (sectionIndex < 0 || sectionIndex >= courseSections.length) {
        throw 'Invalid section index';
      }
      
      if (nodeIndex < 0 || nodeIndex >= courseSections[sectionIndex].nodes.length) {
        throw 'Invalid node index';
      }
      
      // Update progress logic here
      // ... existing update logic
      
    }, errorMessage: '進捗の更新に失敗しました');
  }
}
```

---

## 📊 Error Types and Messages

### **Error Type Mapping**

| Error Type | Japanese Title | Default Message |
|------------|----------------|-----------------|
| `ErrorType.network` | ネットワークエラー | ネットワークエラーが発生しました。接続を確認してください。 |
| `ErrorType.validation` | 入力エラー | 入力内容に誤りがあります。確認してください。 |
| `ErrorType.authentication` | ログインエラー | ログイン情報が正しくありません。 |
| `ErrorType.authorization` | アクセスエラー | この操作を行う権限がありません。 |
| `ErrorType.server` | サーバーエラー | サーバーエラーが発生しました。しばらく待ってから再試行してください。 |
| `ErrorType.unknown` | エラー | エラーが発生しました。しばらく待ってから再試行してください。 |

---

## 🧪 Testing Your Implementation

### **1. Add Test Button to Any View**

```dart
// Add this test button to see ErrorManager in action
CustomButton.secondary(
  text: 'エラーテスト',
  onPressed: () {
    // Test different error types
    controller.testErrorManager();
  },
)
```

### **2. Test Form Validation**

```dart
// Try submitting forms with empty fields
CustomButton.primary(
  text: 'ログイン',
  onPressed: () {
    // Try logging in with empty fields to see validation errors
    controller.onLogin();
  },
)
```

### **3. Test Network Simulation**

```dart
// Add network test method
void testNetworkScenarios() {
  // Simulate poor connection
  Future.delayed(Duration(seconds: 1), () {
    ErrorManager.instance.handleError(
      'Slow connection detected',
      type: ErrorType.network,
      customMessage: '接続が遅いです。しばらくお待ちください。'
    );
  });
  
  // Simulate timeout
  Future.delayed(Duration(seconds: 5), () {
    ErrorManager.instance.handleError(
      'Request timeout',
      type: ErrorType.network,
      customMessage: 'リクエストがタイムアウトしました。再試行してください。'
    );
  });
}
```

---

## 🎯 Best Practices

### **1. Use Appropriate Error Types**
- Use `ErrorType.validation` for form validation errors
- Use `ErrorType.network` for connection issues
- Use `ErrorType.authentication` for login failures
- Use `ErrorType.authorization` for permission issues

### **2. Provide User-Friendly Messages**
- Always provide custom Japanese messages for better UX
- Keep error messages concise and actionable
- Avoid technical jargon in user-facing messages

### **3. Clear Errors Appropriately**
- Clear errors when user starts correcting input
- Clear errors when navigating away from screens
- Use `clearError()` for controller-specific errors
- Use `ErrorManager.instance.clearAllErrors()` for global cleanup

### **4. Combine with Loading States**
- Use `isLoading.value` to show loading indicators
- Always set loading to false in finally blocks
- Provide feedback during long operations

---

## 🔧 Advanced Usage

### **Custom Error Handling for Specific Scenarios**

```dart
// Custom error handler for tutorial progression
void handleTutorialError(String step, dynamic error) {
  String customMessage;
  
  switch (step) {
    case 'notification_permission':
      customMessage = '通知の許可が必要です。設定から有効にしてください。';
      break;
    case 'progress_save':
      customMessage = '進捗の保存に失敗しました。もう一度お試しください。';
      break;
    case 'user_data_load':
      customMessage = 'ユーザーデータの読み込みに失敗しました。';
      break;
    default:
      customMessage = 'チュートリアルでエラーが発生しました。';
  }
  
  ErrorManager.instance.handleError(
    error,
    type: ErrorType.unknown,
    customMessage: customMessage,
  );
}
```

---

## 📞 Support

For questions about ErrorManager implementation:
1. Check this usage guide first
2. Review the ErrorManager source code in `lib/utils/error_manager.dart`
3. Test with the provided examples
4. Refer to Phase 3 Optimization Report for implementation details

---

**Remember**: The ErrorManager automatically shows Japanese error messages as snackbars at the bottom of the screen, categorized by error type with appropriate colors and styling. No additional UI setup is required for basic error display.