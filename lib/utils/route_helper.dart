import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kioku_navi/app/modules/auth/views/root_screen_view.dart';
import 'package:kioku_navi/app/modules/home/views/child_home_view.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';
import 'package:kioku_navi/services/auth/token_manager_impl.dart';
import 'package:kioku_navi/utils/constants.dart';

class RouteHelper {
  RouteHelper._();

  /// Determine the initial screen based on authentication status and user type
  /// Note: Connectivity checking is now handled globally by ConnectivityManager
  static Widget getInitialScreen() {
    try {
      // Check authentication status
      final tokenManager = Get.find<TokenManager>();
      final isAuthenticated =
          (tokenManager as TokenManagerImpl).isAuthenticatedSync();

      if (!isAuthenticated) {
        return const RootScreenView();
      }

      // Get user type from storage
      final storage = Get.find<GetStorage>();
      final isStudent = storage.read(kIsStudent) ?? false;

      return ChildHomeView();

      // Route based on user type
      // return isStudent ? ChildHomeView() : const HomeView();
    } catch (e) {
      // If any error occurs, fallback to root screen
      return const RootScreenView();
    }
  }
}
