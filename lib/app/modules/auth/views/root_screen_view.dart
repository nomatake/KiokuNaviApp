import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/auth/controllers/auth_controller.dart';
import 'package:kioku_navi/app/modules/auth/controllers/family_auth_controller.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';

class RootScreenView extends GetView<AuthController> {
  const RootScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    // Check authentication status on app startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthenticationStatus();
    });

    return _buildWelcomeScreen(context);
  }

  void _checkAuthenticationStatus() {
    final tokenManager = Get.find<TokenManager>();

    if (tokenManager.isAuthenticatedSync()) {
      Get.offNamed(Routes.PARENT_DASHBOARD);
    }
  }

  Widget _buildWelcomeScreen(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PaddedWrapper(
          bottom: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Logo
              Center(
                child: Assets.images.logo.image(
                  fit: BoxFit.contain,
                  height: k100Double.sp,
                  width: k100Double.sp,
                ),
              ),
              SizedBox(height: k2Double.hp),

              // Title
              Text(
                LocaleKeys.app_title.tr,
                style: TextStyle(
                  fontFamily: 'Hiragino Sans',
                  fontWeight: FontWeight.w800,
                  fontSize: k20Double.sp,
                  color: Color(0xFF1976D2),
                ),
              ),
              SizedBox(height: k1Double.hp),

              // Subtitle
              Text(
                LocaleKeys.app_subtitle.tr,
                style: TextStyle(
                  fontFamily: 'Hiragino Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: k12Double.sp,
                  color: Color(0xFFB1B1B1),
                ),
              ),
              const Spacer(),

              // Sign Up Button
              CustomButton.primary(
                text: LocaleKeys.common_buttons_signup.tr,
                onPressed: () => Get.toNamed(Routes.PARENT_PRE_REGISTRATION),
              ),
              SizedBox(height: k2Double.hp),

              // Join Family Button (for children)
              CustomButton.secondary(
                text: LocaleKeys.pages_root_joinFamily.tr,
                onPressed: () => Get.toNamed(Routes.CHILD_JOIN),
              ),
              SizedBox(height: k2Double.hp),

              // Child Login Button (for existing children)
              CustomButton.secondary(
                text: LocaleKeys.pages_root_childLogin.tr,
                onPressed: () {
                  // Use the FamilyAuthController for smart login routing
                  final familyController = Get.put(FamilyAuthController());
                  familyController.handleChildLogin();
                },
              ),
              SizedBox(height: k2Double.hp),

              // Login as Guardian
              CustomButton.outline(
                text: LocaleKeys.pages_root_parentLogin.tr,
                onPressed: () => Get.toNamed(Routes.PARENT_LOGIN),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
