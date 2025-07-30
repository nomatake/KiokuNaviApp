import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/child_join_view.dart';
import '../modules/auth/views/child_pin_login_view.dart';
import '../modules/auth/views/child_pin_setup_view.dart';
import '../modules/auth/views/child_profile_selection_view.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/otp_verification_view.dart';
import '../modules/auth/views/parent_login_view.dart';
import '../modules/auth/views/parent_pre_registration_view.dart';
import '../modules/auth/views/parent_profile_completion_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/views/root_screen_view.dart';
import '../modules/auth/views/student_login_view.dart';
import '../modules/home/bindings/child_home_binding.dart';
import '../modules/home/bindings/parent_dashboard_binding.dart';
import '../modules/home/views/child_home_view.dart';
import '../modules/home/views/parent_dashboard_view.dart';
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
import '../../utils/page_transitions.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ROOT_SCREEN;

  static final routes = [
    // Parent dashboard with zoom fade transitions
    GetPageTransition.withAutoTransition(
      name: _Paths.PARENT_DASHBOARD,
      page: () => const ParentDashboardView(),
      binding: ParentDashboardBinding(),
      forceContext: TransitionContext.home,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.CHILD_HOME,
      page: () => ChildHomeView(),
      binding: ChildHomeBinding(),
      forceContext: TransitionContext.home,
    ),

    // Auth routes with fade scale transitions
    GetPageTransition.withAutoTransition(
      name: _Paths.ROOT_SCREEN,
      page: () => const RootScreenView(),
      binding: AuthBinding(),
      forceContext: TransitionContext.auth,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
      forceContext: TransitionContext.auth,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.PARENT_LOGIN,
      page: () => const ParentLoginView(),
      binding: AuthBinding(),
      forceContext: TransitionContext.auth,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.STUDENT_LOGIN,
      page: () => const StudentLoginView(),
      binding: AuthBinding(),
      forceContext: TransitionContext.auth,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
      forceContext: TransitionContext.auth,
    ),

    // Family Authentication Routes
    GetPageTransition.withAutoTransition(
      name: _Paths.PARENT_PRE_REGISTRATION,
      page: () => const ParentPreRegistrationView(),
      binding: AuthBinding(),
      forceContext: TransitionContext.auth,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.OTP_VERIFICATION,
      page: () => const OtpVerificationView(),
      binding: AuthBinding(),
      forceContext: TransitionContext.auth,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.PARENT_PROFILE_COMPLETION,
      page: () => const ParentProfileCompletionView(),
      binding: AuthBinding(),
      forceContext: TransitionContext.auth,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.CHILD_JOIN,
      page: () => const ChildJoinView(),
      binding: AuthBinding(),
      forceContext: TransitionContext.auth,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.CHILD_PIN_SETUP,
      page: () => const ChildPinSetupView(),
      binding: AuthBinding(),
      forceContext: TransitionContext.auth,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.CHILD_PROFILE_SELECTION,
      page: () => const ChildProfileSelectionView(),
      binding: AuthBinding(),
      forceContext: TransitionContext.auth,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.CHILD_PIN_LOGIN,
      page: () => const ChildPinLoginView(),
      binding: AuthBinding(),
      forceContext: TransitionContext.auth,
    ),

    // Tutorial routes with tutorial flow transitions (with bounce)
    GetPageTransition.withAutoTransition(
      name: _Paths.TUTORIAL,
      page: () => const TutorialView(),
      binding: TutorialBinding(),
      forceContext: TransitionContext.tutorial,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.TUTORIAL_TWO,
      page: () => const TutorialTwoView(),
      binding: TutorialBinding(),
      forceContext: TransitionContext.tutorial,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.TUTORIAL_THREE,
      page: () => const TutorialThreeView(),
      binding: TutorialBinding(),
      forceContext: TransitionContext.tutorial,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.TUTORIAL_FOUR,
      page: () => const TutorialFourView(),
      binding: TutorialBinding(),
      forceContext: TransitionContext.tutorial,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.TUTORIAL_FIVE,
      page: () => const TutorialFiveView(),
      binding: TutorialBinding(),
      forceContext: TransitionContext.tutorial,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.TUTORIAL_SIX,
      page: () => const TutorialSixView(),
      binding: TutorialBinding(),
      forceContext: TransitionContext.tutorial,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.TUTORIAL_SEVEN,
      page: () => const TutorialSevenView(),
      binding: TutorialBinding(),
      forceContext: TransitionContext.tutorial,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.TUTORIAL_EIGHT,
      page: () => const TutorialEightView(),
      binding: TutorialBinding(),
      forceContext: TransitionContext.tutorial,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.TUTORIAL_NINE,
      page: () => const TutorialNineView(),
      binding: TutorialBinding(),
      forceContext: TransitionContext.tutorial,
    ),

    // Learning routes with learning flow transitions
    GetPageTransition.withAutoTransition(
      name: _Paths.LEARNING,
      page: () => const LearningView(),
      binding: LearningBinding(),
      forceContext: TransitionContext.learning,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.QUESTION,
      page: () => const QuestionView(),
      binding: LearningBinding(),
      forceContext: TransitionContext.learning,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.SESSION_CHANGE,
      page: () => const SessionChangeView(),
      binding: LearningBinding(),
      forceContext: TransitionContext.learning,
    ),
    GetPageTransition.withAutoTransition(
      name: _Paths.CONTINUOUS_PLAY_RECORD,
      page: () => const ContinuousPlayRecordView(),
      binding: LearningBinding(),
      forceContext: TransitionContext.learning,
    ),

    // Result route with bounce scale for celebration
    GetPageTransition.withAutoTransition(
      name: _Paths.RESULT,
      page: () => const ResultView(),
      binding: LearningBinding(),
      forceContext: TransitionContext.result,
    ),
  ];
}
