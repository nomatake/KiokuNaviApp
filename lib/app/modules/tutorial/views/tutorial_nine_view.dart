import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/utils/app_constants.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/widgets/base_tutorial_view.dart';

class TutorialNineView extends StatelessWidget {
  const TutorialNineView({super.key});

  // Colors
  static const textColor = Color(0xFF212121);
  static const containerBorderColor = Color(0xFFE5E5E5);

  @override
  Widget build(BuildContext context) {
    return BaseTutorialView.custom(
      customContent: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: AppSpacing.xs.hp),

          // Chat bubble section
          _buildSpeechBubbleSection(),

          SizedBox(height: AppSpacing.xs.hp),

          // Notification permission dialog
          Expanded(
            child: Center(
              child: _buildNotificationDialog(),
            ),
          ),

          SizedBox(height: AppSpacing.lg.hp),
        ],
      ),
      nextRoute: Routes.CHILD_HOME,
      progress: 1.0,
      primaryButtonText: LocaleKeys.pages_tutorial_nine_reminderText.tr,
    );
  }

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
              LocaleKeys.pages_tutorial_nine_notification.tr,
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

  Widget _buildNotificationDialog() {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: AppContainerSize.hero.sp,
        ),
        padding: EdgeInsets.all(AppSpacing.buttonSpacing.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          border: Border.all(
            color: containerBorderColor,
            width: AppFraction.quarter * AppSpacing.buttonSpacing,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Notification icon
            Icon(
              Icons.notifications_active,
              size: AppIconSize.xl.sp,
              color: const Color(0xFFAFAFAF),
            ),

            SizedBox(height: AppSpacing.xxs.hp),

            // Permission text
            Text(
              LocaleKeys.pages_tutorial_nine_permission.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Hiragino Sans',
                fontSize: AppFontSize.body.sp,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            ),

            SizedBox(height: AppSpacing.xs.hp),

            // Allow button
            SizedBox(
              width: double.infinity,
              height: AppIconSize.xl.sp,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Handle allow permission
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF0F0F0),
                  foregroundColor: const Color(0xFF1976D2),
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  ),
                ),
                child: Text(
                  LocaleKeys.pages_tutorial_nine_allow.tr,
                  style: TextStyle(
                    fontFamily: 'Hiragino Sans',
                    fontSize: AppFontSize.small.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            SizedBox(height: AppSpacing.xxxs.hp),

            // Don't allow button
            SizedBox(
              width: double.infinity,
              height: AppIconSize.xl.sp,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Handle deny permission
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF0F0F0),
                  foregroundColor: const Color(0xFFAEAEAE),
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  ),
                ),
                child: Text(
                  LocaleKeys.pages_tutorial_nine_dontAllow.tr,
                  style: TextStyle(
                    fontFamily: 'Hiragino Sans',
                    fontSize: AppFontSize.small.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
