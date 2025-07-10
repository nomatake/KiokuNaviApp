import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kioku_navi/app/modules/auth/views/root_screen_view.dart';
import 'package:kioku_navi/app/modules/home/views/child_home_view.dart';
import 'package:kioku_navi/app/modules/home/views/home_view.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';
import 'package:kioku_navi/services/auth/token_manager_impl.dart';
import 'package:kioku_navi/utils/constants.dart';

class RouteHelper {
  RouteHelper._();

  /// Determine the initial screen based on authentication status and user type
  static Widget getInitialScreen() {
    try {
      final tokenManager = Get.find<TokenManager>();
      final isAuthenticated = (tokenManager as TokenManagerImpl).isAuthenticatedSync();
      
      if (!isAuthenticated) {
        return const RootScreenView();
      }

      // Get user type from storage
      final storage = Get.find<GetStorage>();
      final isStudent = storage.read(kIsStudent) ?? false;

      // Route based on user type
      return isStudent ?  ChildHomeView() : const HomeView();
    } catch (e) {
      return const RootScreenView();
    }
  }
  }