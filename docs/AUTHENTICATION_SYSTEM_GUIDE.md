# 🔐 KiokuNaviApp Authentication System Guide

## 📋 Overview

This guide covers the complete authentication system implementation using **Dio HTTP client**, **FlutterSecureStorage**, and **GetX dependency injection**. The system follows professional enterprise-level architecture patterns with proper separation of concerns.

## 🏗️ Architecture Overview

```
📱 Application Layer
├── 🎯 Views (UI Components)
├── 🎮 Controllers (Business Logic)
└── 📊 Bindings (Dependency Injection)

🔧 Service Layer
├── 🌐 API Services (HTTP Communication)
├── 🔐 Auth Services (Token Management)
└── 📦 Repositories (Data Access)

⚡ Infrastructure Layer
├── 🔗 HTTP Client (Dio)
├── 🛡️ Interceptors (Auth, Error Handling)
└── 💾 Secure Storage (FlutterSecureStorage)
```

## 📁 Files Created/Modified

### ✅ **Created Files**

1. **`lib/services/api/base_api_client.dart`** - Core HTTP client with Dio
2. **`lib/services/api/auth_api.dart`** - Authentication API interface
3. **`lib/services/api/auth_api_impl.dart`** - Authentication API implementation
4. **`lib/services/api/auth_interceptor.dart`** - Token refresh interceptor
5. **`lib/services/auth/token_manager.dart`** - Token management interface
6. **`lib/services/auth/token_manager_impl.dart`** - Token management implementation

### 🔄 **Modified Files**

1. **`lib/app/bindings/service_binding.dart`** - Dependency injection setup
2. **`lib/app/modules/auth/controllers/auth_controller.dart`** - Authentication logic
3. **`lib/app/modules/auth/bindings/auth_binding.dart`** - Simplified binding
4. **`lib/widgets/base_login_view.dart`** - Reusable login UI
5. **`lib/app/modules/auth/views/student_login_view.dart`** - Student login
6. **`lib/app/modules/auth/views/parent_login_view.dart`** - Parent login
7. **`pubspec.yaml`** - Added required dependencies

## 🔧 Core Components

### 1. **BaseApiClient** 🌐

**Purpose**: Centralized HTTP client using Dio with singleton pattern

**Key Features**:

- ✅ Singleton pattern for consistent instance
- ✅ Custom exception handling
- ✅ Request/Response interceptors
- ✅ Timeout configuration
- ✅ Debug logging

**Usage**:

```dart
final apiClient = Get.find<BaseApiClient>();
final response = await apiClient.get<Map<String, dynamic>>('/api/user');
```

### 2. **AuthInterceptor** 🛡️

**Purpose**: Automatically handles authentication tokens and refresh

**Key Features**:

- ✅ Auto-adds Bearer tokens to requests
- ✅ Handles 401 errors with token refresh
- ✅ Skips auth for public endpoints
- ✅ Prevents infinite recursion

**Auto-handled Endpoints**:

- `/api/auth/student/login`
- `/api/auth/parent/login`
- `/api/auth/register`
- `/api/auth/forgot-password`
- `/api/auth/refresh`

### 3. **TokenManager** 🔐

**Purpose**: Secure token storage and management

**Key Features**:

- ✅ FlutterSecureStorage for encryption
- ✅ In-memory caching for performance
- ✅ Automatic token refresh
- ✅ Thread-safe operations

**Usage**:

```dart
final tokenManager = Get.find<TokenManager>();

// Save tokens
await tokenManager.saveTokens(accessToken, refreshToken);

// Check authentication
final isAuth = await tokenManager.isAuthenticated();

// Get current token
final token = await tokenManager.getAccessToken();
```

### 4. **AuthApi** 🔑

**Purpose**: Authentication API endpoints interface

**Available Methods**:

```dart
// Login methods
Future<Map<String, dynamic>> loginStudent(String email, String password);
Future<Map<String, dynamic>> loginParent(String email, String password);

// Token management
Future<Map<String, dynamic>> refreshToken(String refreshToken);

// User management
Future<Map<String, dynamic>> getCurrentUser();
Future<void> logout();
```

### 5. **AuthController** 🎮

**Purpose**: Authentication business logic and state management

**Key Methods**:

```dart
// Login methods (called directly from views)
Future<void> loginStudent();
Future<void> loginParent();

// Registration and utilities
Future<void> onRegister();
Future<void> onForgotPassword();
Future<void> logout();
Future<bool> checkAuthentication();
```

## 🚀 How to Use the Authentication System

### **1. Student Login**

```dart
// In your UI
StudentLoginView() // Automatically calls controller.loginStudent()

// Manual usage in controller
final authController = Get.find<AuthController>();
await authController.loginStudent();
```

### **2. Parent Login**

```dart
// In your UI
ParentLoginView() // Automatically calls controller.loginParent()

// Manual usage
await authController.loginParent();
```

### **3. Check Authentication Status**

```dart
final authController = Get.find<AuthController>();
final isAuthenticated = await authController.checkAuthentication();

if (isAuthenticated) {
  // User is logged in
  final userData = await authController.getCurrentUser();
} else {
  // Redirect to login
  Get.toNamed(Routes.ROOT_SCREEN);
}
```

### **4. Logout**

```dart
final authController = Get.find<AuthController>();
await authController.logout(); // Clears tokens and navigates to login
```

### **5. Making Authenticated API Calls**

```dart
class MyController extends BaseController {
  late final BaseApiClient _apiClient;

  @override
  void onInit() {
    super.onInit();
    _apiClient = Get.find<BaseApiClient>();
  }

  Future<void> fetchUserData() async {
    await safeApiCall(() async {
      // Token is automatically added by AuthInterceptor
      final response = await _apiClient.get<Map<String, dynamic>>('/api/user/profile');

      // Handle response
      print('User data: $response');
      return response;
    });
  }
}
```

## 🛠️ Creating New Services - Step by Step Guide

### **Step 1: Create Service Interface**

```dart
// lib/services/api/my_service_api.dart
abstract class MyServiceApi {
  Future<List<Map<String, dynamic>>> getItems();
  Future<Map<String, dynamic>> createItem(Map<String, dynamic> data);
  Future<Map<String, dynamic>> updateItem(String id, Map<String, dynamic> data);
  Future<void> deleteItem(String id);
}
```

### **Step 2: Implement Service**

```dart
// lib/services/api/my_service_api_impl.dart
import 'package:kioku_navi/services/api/my_service_api.dart';
import 'package:kioku_navi/services/api/base_api_client.dart';

class MyServiceApiImpl implements MyServiceApi {
  final BaseApiClient apiClient;

  MyServiceApiImpl({required this.apiClient});

  @override
  Future<List<Map<String, dynamic>>> getItems() async {
    final response = await apiClient.get<List<dynamic>>('/api/items');
    return response.cast<Map<String, dynamic>>();
  }

  @override
  Future<Map<String, dynamic>> createItem(Map<String, dynamic> data) async {
    return await apiClient.post<Map<String, dynamic>>('/api/items', data: data);
  }

  @override
  Future<Map<String, dynamic>> updateItem(String id, Map<String, dynamic> data) async {
    return await apiClient.put<Map<String, dynamic>>('/api/items/$id', data: data);
  }

  @override
  Future<void> deleteItem(String id) async {
    await apiClient.delete('/api/items/$id');
  }
}
```

### **Step 3: Add to ServiceBinding**

```dart
// lib/app/bindings/service_binding.dart
class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    // ... existing services ...

    // Add your new service
    Get.lazyPut<MyServiceApi>(
      () => MyServiceApiImpl(apiClient: Get.find<BaseApiClient>()),
      fenix: true,
    );
  }
}
```

### **Step 4: Create Controller**

```dart
// lib/app/modules/my_module/controllers/my_controller.dart
import 'package:get/get.dart';
import 'package:kioku_navi/controllers/base_controller.dart';
import 'package:kioku_navi/services/api/my_service_api.dart';

class MyController extends BaseController {
  late final MyServiceApi _myService;

  final RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _myService = Get.find<MyServiceApi>();
    loadItems();
  }

  Future<void> loadItems() async {
    await safeApiCall(() async {
      final response = await _myService.getItems();
      items.value = response;
      return response;
    });
  }

  Future<void> createItem(Map<String, dynamic> data) async {
    await safeApiCall(() async {
      final newItem = await _myService.createItem(data);
      items.add(newItem);
      return newItem;
    });
  }

  Future<void> deleteItem(String id) async {
    await safeApiCall(() async {
      await _myService.deleteItem(id);
      items.removeWhere((item) => item['id'] == id);
    });
  }
}
```

### **Step 5: Create Binding**

```dart
// lib/app/modules/my_module/bindings/my_binding.dart
import 'package:get/get.dart';
import '../controllers/my_controller.dart';

class MyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyController>(() => MyController());
  }
}
```

### **Step 6: Create View**

```dart
// lib/app/modules/my_module/views/my_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_controller.dart';

class MyView extends GetView<MyController> {
  const MyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Items')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${controller.error.value}'),
                ElevatedButton(
                  onPressed: () => controller.loadItems(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            final item = controller.items[index];
            return ListTile(
              title: Text(item['title'] ?? ''),
              subtitle: Text(item['description'] ?? ''),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => controller.deleteItem(item['id']),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    // Implementation for create dialog
  }
}
```

### **Step 7: Add Route**

```dart
// lib/app/routes/app_pages.dart
static final routes = [
  // ... existing routes ...

  GetPage(
    name: _Paths.MY_MODULE,
    page: () => const MyView(),
    binding: MyBinding(),
  ),
];
```

## 🐛 Potential Issues & Solutions

### **Issue 1: Token Refresh Loops**

**Problem**: Multiple simultaneous requests causing multiple refresh attempts

**Solution**: AuthInterceptor includes recursion prevention and proper error handling

### **Issue 2: Memory Leaks**

**Problem**: Controllers not properly disposing resources

**Solution**: Always override `onClose()` in controllers:

```dart
@override
void onClose() {
  // Dispose text controllers
  emailController.dispose();
  passwordController.dispose();
  super.onClose();
}
```

### **Issue 3: Network Errors**

**Problem**: Poor network error handling

**Solution**: Use `safeApiCall()` in BaseController:

```dart
await safeApiCall(() async {
  return await myApiCall();
});
```

### **Issue 4: Authentication State Sync**

**Problem**: UI not updating after login/logout

**Solution**: Use reactive programming:

```dart
// In view
Obx(() => controller.isAuthenticated.value
  ? AuthenticatedWidget()
  : LoginWidget()
)
```

## 🔒 Security Best Practices

### **1. Token Storage**

- ✅ Uses FlutterSecureStorage (AES encryption)
- ✅ Tokens stored in Android Keystore/iOS Keychain
- ✅ Automatic token clearing on logout

### **2. Network Security**

- ✅ HTTPS only (configured in BaseApiClient)
- ✅ Certificate pinning (can be added to Dio)
- ✅ Request/Response validation

### **3. Error Handling**

- ✅ No sensitive data in error messages
- ✅ Proper exception types
- ✅ Graceful degradation

## 📊 Error Handling

### **Custom Exception Types**

```dart
// Network errors
NetworkException - Connection issues
TimeoutException - Request timeouts

// API errors
ApiException - General API errors
UnauthorizedException - 401 errors
ServerException - 5xx errors
```

### **Error Handling in Controllers**

```dart
Future<void> myApiCall() async {
  await safeApiCall(() async {
    // Your API call here
    return await _api.getData();
  });

  // Error is automatically handled by BaseController
  // UI shows error state if hasError.value == true
  // Error message available in error.value
}
```

## 🧪 Testing Guide

### **Unit Testing Services**

```dart
// test/services/auth_api_test.dart
void main() {
  group('AuthApi', () {
    late AuthApiImpl authApi;
    late MockBaseApiClient mockApiClient;

    setUp(() {
      mockApiClient = MockBaseApiClient();
      authApi = AuthApiImpl(apiClient: mockApiClient);
    });

    test('loginStudent should return tokens', () async {
      // Arrange
      when(mockApiClient.post<Map<String, dynamic>>(any, data: anyNamed('data')))
          .thenAnswer((_) async => {
            'access_token': 'test_token',
            'refresh_token': 'refresh_token',
            'user': {'id': '1', 'name': 'Test User'}
          });

      // Act
      final result = await authApi.loginStudent('test@example.com', 'password');

      // Assert
      expect(result['access_token'], equals('test_token'));
      expect(result['user']['name'], equals('Test User'));
    });
  });
}
```

### **Widget Testing**

```dart
// test/widgets/login_view_test.dart
void main() {
  testWidgets('Login view should show email and password fields', (tester) async {
    // Arrange
    Get.put<AuthController>(MockAuthController());

    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: const StudentLoginView(),
      ),
    );

    // Assert
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('メールアドレス'), findsOneWidget);
    expect(find.text('パスワード'), findsOneWidget);
  });
}
```

## 🚀 Performance Optimizations

### **1. Token Caching**

- ✅ In-memory cache for frequently accessed tokens
- ✅ 5-minute cache validity to balance performance/security

### **2. Request Optimization**

- ✅ Connection reuse with Dio singleton
- ✅ Proper timeout configurations
- ✅ Request/Response compression

### **3. Memory Management**

- ✅ Lazy loading with GetX
- ✅ Proper disposal in controllers
- ✅ Efficient reactive programming

## 📝 Maintenance Checklist

### **Weekly**

- [ ] Check for new Dio versions
- [ ] Review error logs
- [ ] Monitor token refresh rates

### **Monthly**

- [ ] Update dependencies
- [ ] Review security configurations
- [ ] Test authentication flows

### **Quarterly**

- [ ] Security audit
- [ ] Performance profiling
- [ ] Documentation updates

## 🔗 Useful Resources

- [Dio Documentation](https://pub.dev/packages/dio)
- [FlutterSecureStorage](https://pub.dev/packages/flutter_secure_storage)
- [GetX Documentation](https://pub.dev/packages/get)
- [Flutter Security Best Practices](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple#security)

---

## 📞 Support

For questions about this authentication system, please:

1. Check this documentation first
2. Review the example implementations in `/lib/services/api/dio_usage_example.dart`
3. Check existing issues and solutions above
4. Create detailed issue reports with code examples

---

**Last Updated**: December 2024  
**Version**: 1.0.0  
**Maintainer**: KiokuNavi Development Team
