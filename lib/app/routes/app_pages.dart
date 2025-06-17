import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/parent_login_view.dart';
import '../modules/auth/views/student_login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/views/root_screen_view.dart';
import '../modules/tutorial/bindings/tutorial_binding.dart';
import '../modules/tutorial/views/tutorial_view.dart';
import '../modules/tutorial/views/tutorial_two_view.dart';
import '../modules/home/bindings/child_home_binding.dart';
import '../modules/home/views/child_home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ROOT_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ROOT_SCREEN,
      page: () => const RootScreenView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.PARENT_LOGIN,
      page: () => const ParentLoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.STUDENT_LOGIN,
      page: () => const StudentLoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.TUTORIAL,
      page: () => const TutorialView(),
      binding: TutorialBinding(),
    ),
    GetPage(
      name: _Paths.TUTORIAL_TWO,
      page: () => const TutorialTwoView(),
      binding: TutorialBinding(),
    ),
    GetPage(
      name: _Paths.CHILD_HOME,
      page: () => const ChildHomeView(),
      binding: ChildHomeBinding(),
    ),
  ];
}
