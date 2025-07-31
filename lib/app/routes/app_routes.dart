part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();
  static const ROOT_SCREEN = _Paths.ROOT_SCREEN;
  static const PARENT_DASHBOARD = _Paths.PARENT_DASHBOARD;

  // Parent Authentication Routes
  static const PARENT_PRE_REGISTRATION = _Paths.PARENT_PRE_REGISTRATION;
  static const OTP_VERIFICATION = _Paths.OTP_VERIFICATION;
  static const PARENT_PROFILE_COMPLETION = _Paths.PARENT_PROFILE_COMPLETION;
  static const PARENT_LOGIN = _Paths.PARENT_LOGIN;

  // Child Authentication Routes
  static const CHILD_JOIN = _Paths.CHILD_JOIN;
  static const CHILD_PIN_SETUP = _Paths.CHILD_PIN_SETUP;
  static const CHILD_PROFILE_SELECTION = _Paths.CHILD_PROFILE_SELECTION;
  static const CHILD_PIN_LOGIN = _Paths.CHILD_PIN_LOGIN;
  static const CHILD_HOME = _Paths.CHILD_HOME;

  // Family Management Routes
  static const FAMILY_DASHBOARD = _Paths.FAMILY_DASHBOARD;
  static const CHILD_SETUP = _Paths.CHILD_SETUP;
  static const JOIN_CODE_DISPLAY = _Paths.JOIN_CODE_DISPLAY;

  // Legacy routes (for backward compatibility)
  static const REGISTER = _Paths.REGISTER;
  static const STUDENT_LOGIN = _Paths.STUDENT_LOGIN;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;

  // Tutorial and Learning Routes
  static const TUTORIAL = _Paths.TUTORIAL;
  static const TUTORIAL_TWO = _Paths.TUTORIAL_TWO;
  static const TUTORIAL_THREE = _Paths.TUTORIAL_THREE;
  static const TUTORIAL_FOUR = _Paths.TUTORIAL_FOUR;
  static const TUTORIAL_FIVE = _Paths.TUTORIAL_FIVE;
  static const TUTORIAL_SIX = _Paths.TUTORIAL_SIX;
  static const TUTORIAL_SEVEN = _Paths.TUTORIAL_SEVEN;
  static const TUTORIAL_EIGHT = _Paths.TUTORIAL_EIGHT;
  static const TUTORIAL_NINE = _Paths.TUTORIAL_NINE;
  static const LEARNING = _Paths.LEARNING;
  static const QUESTION = _Paths.QUESTION;
  static const RESULT = _Paths.RESULT;
  static const CONTINUOUS_PLAY_RECORD = _Paths.CONTINUOUS_PLAY_RECORD;
  static const SESSION_CHANGE = _Paths.SESSION_CHANGE;
}

abstract class _Paths {
  _Paths._();
  static const ROOT_SCREEN = '/auth/root-screen';
  static const PARENT_DASHBOARD = '/parent/dashboard';

  // Parent Authentication Paths
  static const PARENT_PRE_REGISTRATION = '/auth/parent/pre-register';
  static const OTP_VERIFICATION = '/auth/otp-verification';
  static const PARENT_PROFILE_COMPLETION = '/auth/parent/complete-profile';
  static const PARENT_LOGIN = '/auth/parent/login';

  // Child Authentication Paths
  static const CHILD_JOIN = '/auth/child/join';
  static const CHILD_PIN_SETUP = '/auth/child/pin-setup';
  static const CHILD_PROFILE_SELECTION = '/auth/child/profile-selection';
  static const CHILD_PIN_LOGIN = '/auth/child/pin-login';
  static const CHILD_HOME = '/child/home';

  // Family Management Paths
  static const FAMILY_DASHBOARD = '/family/dashboard';
  static const CHILD_SETUP = '/family/child-setup';
  static const JOIN_CODE_DISPLAY = '/family/join-code';

  // Legacy paths (for backward compatibility)
  static const REGISTER = '/auth/register';
  static const STUDENT_LOGIN = '/auth/student-login';
  static const FORGOT_PASSWORD = '/auth/forgot-password';

  // Tutorial and Learning Paths
  static const TUTORIAL = '/tutorial';
  static const TUTORIAL_TWO = '/tutorial/two';
  static const TUTORIAL_THREE = '/tutorial/three';
  static const TUTORIAL_FOUR = '/tutorial/four';
  static const TUTORIAL_FIVE = '/tutorial/five';
  static const TUTORIAL_SIX = '/tutorial/six';
  static const TUTORIAL_SEVEN = '/tutorial/seven';
  static const TUTORIAL_EIGHT = '/tutorial/eight';
  static const TUTORIAL_NINE = '/tutorial/nine';
  static const LEARNING = '/learning';
  static const QUESTION = '/learning/question';
  static const RESULT = '/learning/result';
  static const CONTINUOUS_PLAY_RECORD = '/learning/continuous-play-record';
  static const SESSION_CHANGE = '/learning/session-change';
}
