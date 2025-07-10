import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';
import 'package:kioku_navi/services/auth/token_manager_impl.dart';
import 'package:kioku_navi/utils/constants.dart';

class RouteHelper {
  RouteHelper._();

  /// Determine the initial route based on authentication status and user type
  static String getInitialRoute() {
    try {
      final tokenManager = Get.find<TokenManager>();
      final isAuthenticated = (tokenManager as TokenManagerImpl).isAuthenticatedSync();
      
      if (!isAuthenticated) {
        return Routes.ROOT_SCREEN;
      }

      // Get user type from storage
      final storage = Get.find<GetStorage>();
      final isStudent = storage.read(kIsStudent) ?? false;

      // Route based on user type
      return isStudent ? Routes.CHILD_HOME : Routes.HOME;
    } catch (e) {
      return Routes.ROOT_SCREEN;
    }
  }
}