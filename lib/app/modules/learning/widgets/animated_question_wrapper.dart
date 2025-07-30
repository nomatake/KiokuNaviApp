import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/app/modules/learning/widgets/question_template.dart';

/// Simple animated wrapper with minimal transitions (fallback option)
class SimpleAnimatedQuestionWrapper extends GetView<LearningController> {
  const SimpleAnimatedQuestionWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final questionKey = ValueKey(controller.currentQuestionIndex.value);

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          // Simple fade transition only - most reliable
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: Container(
          key: questionKey,
          child: const QuestionTemplate(),
        ),
      );
    });
  }
}

/// Animated wrapper that provides slide-in transitions for questions
class AnimatedQuestionWrapper extends GetView<LearningController> {
  const AnimatedQuestionWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Use question index as key to trigger animation when question changes
      final questionKey = ValueKey(controller.currentQuestionIndex.value);

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (Widget child, Animation<double> animation) {
          // Slide in from right transition similar to Duolingo
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Start from right
              end: Offset.zero, // End at center
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: FadeTransition(
              opacity: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: const Interval(0.2, 1.0), // Delayed fade-in
              )),
              child: child,
            ),
          );
        },
        child: Container(
          key: questionKey,
          child: const QuestionTemplate(),
        ),
      );
    });
  }
}

/// Safe and smooth slide-in effect for questions (recommended)
class DuolingoStyleQuestionWrapper extends GetView<LearningController> {
  const DuolingoStyleQuestionWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final questionKey = ValueKey(controller.currentQuestionIndex.value);

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve:
            Curves.easeOutCubic, // Safe curve that stays within bounds
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (Widget child, Animation<double> animation) {
          // Simple and safe slide + fade transition
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Slide in from right
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: FadeTransition(
              opacity: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: const Interval(0.2, 1.0), // Delayed fade-in
              )),
              child: child,
            ),
          );
        },
        child: Container(
          key: questionKey,
          child: const QuestionTemplate(),
        ),
      );
    });
  }
}

/// Question wrapper that includes both bubble and template animations
class CompleteAnimatedQuestionWrapper extends GetView<LearningController> {
  const CompleteAnimatedQuestionWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final questionKey = ValueKey(controller.currentQuestionIndex.value);

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          // Custom layout to prevent overlap during transition
          return Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
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
        },
        child: Container(
          key: questionKey,
          width: double.infinity,
          child: const QuestionTemplate(),
        ),
      );
    });
  }
}
