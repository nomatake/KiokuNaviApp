import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/parent_login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/views/root_screen_view.dart';
import '../modules/auth/views/student_login_view.dart';
import '../modules/home/bindings/child_home_binding.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/child_home_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/learning/bindings/learning_binding.dart';
import '../modules/learning/views/continuous_play_record_view.dart';
import '../modules/learning/views/learning_view.dart';
import '../modules/learning/views/question_view.dart';
import '../modules/learning/views/result_view.dart';
import '../modules/learning/views/session_change_view.dart';
import '../modules/tutorial/bindings/tutorial_binding.dart';
import '../modules/tutorial/views/tutorial_eight_view.dart';
import '../modules/tutorial/views/tutorial_five_view.dart';
import '../modules/tutorial/views/tutorial_four_view.dart';
import '../modules/tutorial/views/tutorial_nine_view.dart';
import '../modules/tutorial/views/tutorial_seven_view.dart';
import '../modules/tutorial/views/tutorial_six_view.dart';
import '../modules/tutorial/views/tutorial_three_view.dart';
import '../modules/tutorial/views/tutorial_two_view.dart';
import '../modules/tutorial/views/tutorial_view.dart';

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
      page: () => ChildHomeView(),
      binding: ChildHomeBinding(),
    ),
    GetPage(
      name: _Paths.TUTORIAL_THREE,
      page: () => const TutorialThreeView(),
      binding: TutorialBinding(),
    ),
    GetPage(
      name: _Paths.TUTORIAL_FOUR,
      page: () => const TutorialFourView(),
      binding: TutorialBinding(),
    ),
    GetPage(
      name: _Paths.TUTORIAL_FIVE,
      page: () => const TutorialFiveView(),
      binding: TutorialBinding(),
    ),
    GetPage(
      name: _Paths.TUTORIAL_SIX,
      page: () => const TutorialSixView(),
      binding: TutorialBinding(),
    ),
    GetPage(
      name: _Paths.TUTORIAL_SEVEN,
      page: () => const TutorialSevenView(),
      binding: TutorialBinding(),
    ),
    GetPage(
      name: _Paths.TUTORIAL_EIGHT,
      page: () => const TutorialEightView(),
      binding: TutorialBinding(),
    ),
    GetPage(
      name: _Paths.TUTORIAL_NINE,
      page: () => const TutorialNineView(),
      binding: TutorialBinding(),
    ),
    GetPage(
      name: _Paths.LEARNING,
      page: () => const LearningView(),
      binding: LearningBinding(),
    ),
    GetPage(
      name: _Paths.QUESTION,
      page: () => const QuestionView(),
      binding: LearningBinding(),
    ),
    GetPage(
      name: _Paths.RESULT,
      page: () => const ResultView(),
      binding: LearningBinding(),
    ),
    GetPage(
      name: _Paths.CONTINUOUS_PLAY_RECORD,
      page: () => const ContinuousPlayRecordView(),
      binding: LearningBinding(),
    ),
    GetPage(
      name: _Paths.SESSION_CHANGE,
      page: () => const SessionChangeView(),
      binding: LearningBinding(),
    ),
  ];
}
