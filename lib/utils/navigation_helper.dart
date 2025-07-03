import 'package:get/get.dart';

/// Navigation helper mixin that provides a clean way to handle navigation
/// from controllers without violating GetX architecture principles.
/// 
/// Controllers should use the callback pattern instead of direct navigation,
/// and views should set up the navigation callback to handle the actual routing.
mixin NavigationHelper {
  /// Navigation callback function that should be set by the view
  /// to handle navigation requests from the controller.
  Function(String route)? onNavigationRequested;

  /// Request navigation to a specific route.
  /// This method should be called from controllers instead of Get.toNamed().
  /// 
  /// Usage in controller:
  /// ```dart
  /// requestNavigation(Routes.HOME);
  /// ```
  void requestNavigation(String route) {
    onNavigationRequested?.call(route);
  }

  /// Request navigation with arguments.
  /// 
  /// Usage in controller:
  /// ```dart
  /// requestNavigationWithArguments(Routes.PROFILE, arguments: {'userId': 123});
  /// ```
  void requestNavigationWithArguments(String route, {dynamic arguments}) {
    onNavigationRequested?.call(route);
    // Note: Arguments handling would need to be extended based on requirements
  }

  /// Setup navigation callback in the view's build method.
  /// This should be called by views to handle navigation requests.
  /// 
  /// Usage in view:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   setupNavigation();
  ///   return Scaffold(...);
  /// }
  /// ```
  void setupNavigation() {
    onNavigationRequested = (route) {
      Get.toNamed(route);
    };
  }

  /// Setup navigation callback with custom navigation logic.
  /// Useful when you need special navigation handling.
  /// 
  /// Usage in view:
  /// ```dart
  /// setupCustomNavigation((route) {
  ///   // Custom navigation logic here
  ///   if (route == Routes.LOGIN) {
  ///     Get.offAllNamed(route);
  ///   } else {
  ///     Get.toNamed(route);
  ///   }
  /// });
  /// ```
  void setupCustomNavigation(Function(String route) customNavigationHandler) {
    onNavigationRequested = customNavigationHandler;
  }

  /// Clear the navigation callback.
  /// Useful in onClose() to prevent memory leaks.
  void clearNavigation() {
    onNavigationRequested = null;
  }
}

/// Base controller that includes navigation helper functionality.
/// Controllers can extend this instead of GetxController for automatic navigation support.
/// 
/// Usage:
/// ```dart
/// class MyController extends BaseController {
///   void someMethod() {
///     // Use navigation helper methods
///     requestNavigation(Routes.HOME);
///   }
/// }
/// ```
abstract class BaseController extends GetxController with NavigationHelper {
  @override
  void onClose() {
    clearNavigation();
    super.onClose();
  }
}