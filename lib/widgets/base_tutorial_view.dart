/// Base tutorial view widget for consolidating common tutorial patterns
library;

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/utils/app_constants.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/widgets/custom_appbar.dart';
import 'package:kioku_navi/widgets/custom_chiclet_button.dart';
import 'package:kioku_navi/widgets/custom_tooltip.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/widgets/register_app_bar.dart';

/// Defines the type of tutorial view to render
enum TutorialViewType {
  /// Simple view with logo and tooltip message
  simple,

  /// Interactive view with speech bubble and option buttons
  interactive,

  /// Custom view for specialized content
  custom,
}

/// Option button configuration for interactive tutorial views
class TutorialOption {
  /// Text to display on the button
  final String text;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Creates a tutorial option configuration
  const TutorialOption({
    required this.text,
    this.onPressed,
  });
}

/// Base tutorial view widget that consolidates common patterns
class BaseTutorialView extends StatelessWidget {
  /// Type of tutorial view to render
  final TutorialViewType viewType;

  /// Progress value for RegisterAppBar (0.0 - 1.0)
  final double? progress;

  /// Message to display in bubble or tooltip
  final String message;

  /// Route to navigate to when 'Next' button is pressed
  final String nextRoute;

  /// List of option buttons for interactive views
  final List<TutorialOption> options;

  /// Custom content widget for custom view type
  final Widget? customContent;

  /// Whether to show back button in app bar
  final bool showBackButton;

  /// Custom callback for back button
  final VoidCallback? onBack;

  /// Text for the primary button
  final String? primaryButtonText;

  /// Whether to show the primary button
  final bool showPrimaryButton;

  /// Whether to show the app bar
  final bool showAppBar;

  /// Creates a base tutorial view with the specified configuration
  const BaseTutorialView({
    super.key,
    required this.viewType,
    required this.message,
    required this.nextRoute,
    this.progress,
    this.options = const [],
    this.customContent,
    this.showBackButton = true,
    this.onBack,
    this.primaryButtonText,
    this.showPrimaryButton = true,
    this.showAppBar = true,
  });

  /// Factory constructor for simple tutorial views
  factory BaseTutorialView.simple({
    Key? key,
    required String message,
    required String nextRoute,
    bool showBackButton = true,
    VoidCallback? onBack,
    String? primaryButtonText,
    bool showAppBar = true,
  }) {
    return BaseTutorialView(
      key: key,
      viewType: TutorialViewType.simple,
      message: message,
      nextRoute: nextRoute,
      showBackButton: showBackButton,
      onBack: onBack,
      primaryButtonText: primaryButtonText,
      showAppBar: showAppBar,
    );
  }

  /// Factory constructor for interactive tutorial views
  factory BaseTutorialView.interactive({
    Key? key,
    required String message,
    required String nextRoute,
    required double progress,
    required List<TutorialOption> options,
    bool showBackButton = true,
    VoidCallback? onBack,
    String? primaryButtonText,
    bool showAppBar = true,
  }) {
    return BaseTutorialView(
      key: key,
      viewType: TutorialViewType.interactive,
      message: message,
      nextRoute: nextRoute,
      progress: progress,
      options: options,
      showBackButton: showBackButton,
      onBack: onBack,
      primaryButtonText: primaryButtonText,
      showAppBar: showAppBar,
    );
  }

  /// Factory constructor for custom tutorial views
  factory BaseTutorialView.custom({
    Key? key,
    required Widget customContent,
    required String nextRoute,
    double? progress,
    bool showBackButton = true,
    VoidCallback? onBack,
    String? primaryButtonText,
    bool showPrimaryButton = true,
    bool showAppBar = true,
  }) {
    return BaseTutorialView(
      key: key,
      viewType: TutorialViewType.custom,
      message: '',
      nextRoute: nextRoute,
      progress: progress,
      customContent: customContent,
      showBackButton: showBackButton,
      onBack: onBack,
      primaryButtonText: primaryButtonText,
      showPrimaryButton: showPrimaryButton,
      showAppBar: showAppBar,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? _buildAppBar() : null,
      body: SafeArea(
        child: PaddedWrapper(
          bottom: true,
          child: _buildBody(),
        ),
      ),
    );
  }

  /// Builds the appropriate app bar based on configuration
  PreferredSizeWidget _buildAppBar() {
    if (progress != null) {
      return RegisterAppBar(
        progress: progress!,
        onBack: showBackButton ? (onBack ?? () => Get.back()) : null,
      );
    } else {
      return CustomAppbar(
        onBackPressed: showBackButton ? (onBack ?? () => Get.back()) : null,
      );
    }
  }

  /// Builds the body content based on view type
  Widget _buildBody() {
    switch (viewType) {
      case TutorialViewType.simple:
        return _buildSimpleView();
      case TutorialViewType.interactive:
        return _buildInteractiveView();
      case TutorialViewType.custom:
        return _buildCustomView();
    }
  }

  /// Builds simple tutorial view with tooltip
  Widget _buildSimpleView() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTooltip(
                  message: message,
                  child: Assets.images.logo.image(
                    height: AppContainerSize.mediumCard.sp,
                    width: AppContainerSize.mediumCard.sp,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showPrimaryButton)
          CustomChicletButton.primary(
            text: primaryButtonText ?? LocaleKeys.common_buttons_next.tr,
            onPressed: () => Get.toNamed(nextRoute),
          ),
      ],
    );
  }

  /// Builds interactive tutorial view with speech bubble and options
  Widget _buildInteractiveView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: AppSpacing.xs.hp),
        _buildSpeechBubbleSection(),
        SizedBox(height: AppSpacing.xs.hp),
        ...options.map((option) => Column(
              children: [
                CustomChicletButton.secondary(
                  text: option.text,
                  onPressed: option.onPressed,
                ),
                SizedBox(height: AppSpacing.xxs.hp),
              ],
            )),
        const Spacer(),
        if (showPrimaryButton)
          CustomChicletButton.primary(
            text: primaryButtonText ?? LocaleKeys.common_buttons_next.tr,
            onPressed: () => Get.toNamed(nextRoute),
          ),
      ],
    );
  }

  /// Builds custom tutorial view
  Widget _buildCustomView() {
    return Column(
      children: [
        Expanded(
          child: customContent ?? const SizedBox.shrink(),
        ),
        if (showPrimaryButton)
          CustomChicletButton.primary(
            text: primaryButtonText ?? LocaleKeys.common_buttons_next.tr,
            onPressed: () => Get.toNamed(nextRoute),
          ),
      ],
    );
  }

  /// Builds the speech bubble section with logo and message
  Widget _buildSpeechBubbleSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Assets.images.logo.image(
          height: AppContainerSize.smallCard.sp,
          width: AppContainerSize.smallCard.sp,
          fit: BoxFit.contain,
        ),
        Expanded(
          child: Bubble(
            style: BubbleStyle(
              margin: BubbleEdges.only(top: AppSpacing.buttonSpacing),
              elevation: AppSpacing.buttonSpacing,
              color: const Color(0xFFF7F7F7),
              borderColor: const Color(0xFFD8D8D8),
              borderWidth: AppFraction.quarter * AppSpacing.buttonSpacing,
              padding: BubbleEdges.all(AppSpacing.buttonSpacing.sp),
              alignment: Alignment.topLeft,
              nip: BubbleNip.leftBottom,
              nipWidth: AppSpacing.buttonSpacing.sp,
              nipHeight: AppSpacing.buttonSpacing.sp,
              nipOffset: AppSpacing.buttonSpacing.sp,
              radius: Radius.circular(AppFontSize.body),
            ),
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'Hiragino Sans',
                fontWeight: FontWeight.w400,
                fontSize: AppFontSize.body.sp,
                color: const Color(0xFF212121),
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }
}
