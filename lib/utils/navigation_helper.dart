import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'page_transitions.dart';

/// Navigation helper that provides Duolingo-style smart transitions
/// Note: Transitions are configured in the route definitions (app_pages.dart)
class NavigationHelper {
  /// Navigate to a route with the transitions defined in route configuration
  static Future<T?>? toNamed<T>(
    String routeName, {
    dynamic arguments,
    bool preventDuplicates = true,
  }) {
    return Get.toNamed<T>(
      routeName,
      arguments: arguments,
      preventDuplicates: preventDuplicates,
    );
  }

  /// Navigate and replace current route
  static Future<T?>? offNamed<T>(
    String routeName, {
    dynamic arguments,
  }) {
    return Get.offNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate and remove all previous routes
  static Future<T?>? offAllNamed<T>(
    String routeName, {
    dynamic arguments,
  }) {
    return Get.offAllNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Go back with appropriate transition
  static void back<T>({
    T? result,
    bool closeOverlays = false,
    bool canPop = true,
  }) {
    if (closeOverlays) {
      Get.back<T>(
        result: result,
        closeOverlays: closeOverlays,
        canPop: canPop,
      );
    } else {
      Get.back<T>(
        result: result,
        canPop: canPop,
      );
    }
  }

  /// Navigate to tutorial flow (uses tutorial transitions from route config)
  static Future<T?>? toTutorial<T>(String tutorialRoute, {dynamic arguments}) {
    return toNamed<T>(tutorialRoute, arguments: arguments);
  }

  /// Navigate to learning flow (uses learning transitions from route config)
  static Future<T?>? toLearning<T>(String learningRoute, {dynamic arguments}) {
    return toNamed<T>(learningRoute, arguments: arguments);
  }

  /// Navigate to result (uses result transitions from route config)
  static Future<T?>? toResult<T>(String resultRoute, {dynamic arguments}) {
    return toNamed<T>(resultRoute, arguments: arguments);
  }

  /// Navigate to home (uses home transitions from route config)
  static Future<T?>? toHome<T>(String homeRoute, {dynamic arguments}) {
    return toNamed<T>(homeRoute, arguments: arguments);
  }
}

/// Extension on GetX controller for easier navigation
extension ControllerNavigation on GetxController {
  /// Navigate with the transitions defined in route configuration
  Future<T?>? navigateTo<T>(
    String routeName, {
    dynamic arguments,
  }) {
    return NavigationHelper.toNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate and replace with transitions from route configuration
  Future<T?>? navigateOff<T>(
    String routeName, {
    dynamic arguments,
  }) {
    return NavigationHelper.offNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate to tutorial with tutorial transitions
  Future<T?>? navigateToTutorial<T>(String tutorialRoute, {dynamic arguments}) {
    return NavigationHelper.toTutorial<T>(tutorialRoute, arguments: arguments);
  }

  /// Navigate to learning with learning transitions
  Future<T?>? navigateToLearning<T>(String learningRoute, {dynamic arguments}) {
    return NavigationHelper.toLearning<T>(learningRoute, arguments: arguments);
  }

  /// Navigate to result with celebration transition
  Future<T?>? navigateToResult<T>(String resultRoute, {dynamic arguments}) {
    return NavigationHelper.toResult<T>(resultRoute, arguments: arguments);
  }

  /// Navigate to home with zoom transition
  Future<T?>? navigateToHome<T>(String homeRoute, {dynamic arguments}) {
    return NavigationHelper.toHome<T>(homeRoute, arguments: arguments);
  }

  /// Go back with appropriate transition
  void navigateBack<T>({T? result}) {
    NavigationHelper.back<T>(result: result);
  }
}

/// Route transition configurations for specific flows
class RouteTransitions {
  /// Tutorial progression map for determining next/previous transitions
  static const Map<String, String> tutorialFlow = {
    '/tutorial': '/tutorial/two',
    '/tutorial/two': '/tutorial/three',
    '/tutorial/three': '/tutorial/four',
    '/tutorial/four': '/tutorial/five',
    '/tutorial/five': '/tutorial/six',
    '/tutorial/six': '/tutorial/seven',
    '/tutorial/seven': '/tutorial/eight',
    '/tutorial/eight': '/tutorial/nine',
  };

  /// Learning flow map
  static const Map<String, String> learningFlow = {
    '/learning': '/learning/question',
    '/learning/question': '/learning/result',
    '/learning/result': '/learning/continuous-play-record',
  };

  /// Check if route is a forward progression in tutorial
  static bool isTutorialProgression(String fromRoute, String toRoute) {
    return tutorialFlow[fromRoute] == toRoute;
  }

  /// Check if route is a forward progression in learning
  static bool isLearningProgression(String fromRoute, String toRoute) {
    return learningFlow[fromRoute] == toRoute;
  }

  /// Get appropriate transition context for route progression
  static TransitionContext getProgressionContext(
      String fromRoute, String toRoute) {
    if (isTutorialProgression(fromRoute, toRoute)) {
      return TransitionContext.tutorial;
    } else if (isLearningProgression(fromRoute, toRoute)) {
      return TransitionContext.learning;
    } else if (toRoute.contains('/result')) {
      return TransitionContext.result;
    } else if (toRoute.contains('/home')) {
      return TransitionContext.home;
    } else {
      return TransitionHelper.getContextFromRoute(toRoute);
    }
  }
}
