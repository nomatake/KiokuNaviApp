import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Custom page transitions inspired by Duolingo's smooth and engaging animations
class DuolingoTransitions {
  /// Smooth slide transition from right to left (forward navigation)
  static Transition get slideRight => Transition.rightToLeft;

  /// Smooth slide transition from left to right (back navigation)
  static Transition get slideLeft => Transition.leftToRight;

  /// Smooth fade with subtle scale effect for overlays and modals
  static Transition get fadeScale => Transition.fade;

  /// Celebratory bounce scale for positive interactions (results, achievements)
  static Transition get bounceScale => Transition.zoom;

  /// Upward slide for bottom sheet style transitions
  static Transition get slideUp => Transition.downToUp;

  /// Custom transition for tutorial flows with slight bounce
  static Transition get tutorialFlow => Transition.rightToLeftWithFade;

  /// Learning question transition with smooth ease
  static Transition get learningFlow => Transition.rightToLeftWithFade;

  /// Smooth zoom transition for home navigation
  static Transition get zoomFade => Transition.fadeIn;
}

/// Custom transition builder functions for more advanced animations
class CustomTransitionBuilders {
  /// Slide right with fade and curve
  static Widget slideRightWithFade(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  /// Slide left with fade and curve
  static Widget slideLeftWithFade(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  /// Scale with bounce for celebrations
  static Widget bounceScale(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 0.7,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.elasticOut,
        )),
        child: child,
      ),
    );
  }

  /// Tutorial flow with slight bounce
  static Widget tutorialFlow(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  /// Learning flow with delayed fade
  static Widget learningFlow(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubic,
      )),
      child: FadeTransition(
        opacity: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.3, 1.0),
        )),
        child: child,
      ),
    );
  }
}

/// Enum for different transition contexts
enum TransitionContext {
  tutorial,
  learning,
  auth,
  home,
  result,
  modal,
  back,
}

/// Helper class to determine appropriate transitions based on context
class TransitionHelper {
  /// Get appropriate transition for route context
  static Transition getTransitionForContext(TransitionContext context) {
    switch (context) {
      case TransitionContext.tutorial:
        return DuolingoTransitions.tutorialFlow;
      case TransitionContext.learning:
        return DuolingoTransitions.learningFlow;
      case TransitionContext.auth:
        return DuolingoTransitions.fadeScale;
      case TransitionContext.home:
        return DuolingoTransitions.zoomFade;
      case TransitionContext.result:
        return DuolingoTransitions.bounceScale;
      case TransitionContext.modal:
        return DuolingoTransitions.slideUp;
      case TransitionContext.back:
        return DuolingoTransitions.slideLeft;
    }
  }

  /// Get custom transition builder for route context
  static Widget Function(
          BuildContext, Animation<double>, Animation<double>, Widget)?
      getCustomTransitionBuilder(TransitionContext context) {
    switch (context) {
      case TransitionContext.tutorial:
        return CustomTransitionBuilders.tutorialFlow;
      case TransitionContext.learning:
        return CustomTransitionBuilders.learningFlow;
      case TransitionContext.result:
        return CustomTransitionBuilders.bounceScale;
      case TransitionContext.back:
        return CustomTransitionBuilders.slideLeftWithFade;
      default:
        return null;
    }
  }

  /// Determine transition context from route name
  static TransitionContext getContextFromRoute(String routeName) {
    if (routeName.contains('/tutorial')) {
      return TransitionContext.tutorial;
    } else if (routeName.contains('/learning') ||
        routeName.contains('/question')) {
      return TransitionContext.learning;
    } else if (routeName.contains('/result')) {
      return TransitionContext.result;
    } else if (routeName.contains('/auth') ||
        routeName.contains('login') ||
        routeName.contains('register')) {
      return TransitionContext.auth;
    } else if (routeName.contains('/home')) {
      return TransitionContext.home;
    } else {
      return TransitionContext.auth; // Default fallback
    }
  }

  /// Get transition duration based on context
  static Duration getTransitionDuration(TransitionContext context) {
    switch (context) {
      case TransitionContext.tutorial:
        return const Duration(milliseconds: 400);
      case TransitionContext.learning:
        return const Duration(milliseconds: 350);
      case TransitionContext.result:
        return const Duration(milliseconds: 500);
      case TransitionContext.modal:
        return const Duration(milliseconds: 300);
      default:
        return const Duration(milliseconds: 350);
    }
  }
}

/// Extension to add transition configuration to GetPage
extension GetPageTransition on GetPage {
  /// Create a GetPage with automatic transition selection
  static GetPage withAutoTransition({
    required String name,
    required Widget Function() page,
    Bindings? binding,
    TransitionContext? forceContext,
  }) {
    final context = forceContext ?? TransitionHelper.getContextFromRoute(name);
    final transition = TransitionHelper.getTransitionForContext(context);
    final duration = TransitionHelper.getTransitionDuration(context);

    return GetPage(
      name: name,
      page: page,
      binding: binding,
      transition: transition,
      transitionDuration: duration,
    );
  }
}
