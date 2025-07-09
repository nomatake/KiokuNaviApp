import 'package:get/get.dart';
import 'package:kioku_navi/services/api/base_api_client.dart';
import 'package:kioku_navi/services/api/auth_api.dart';
import 'package:kioku_navi/services/api/auth_api_impl.dart';
import 'package:kioku_navi/services/api/quiz_api.dart';
import 'package:kioku_navi/services/api/quiz_api_impl.dart';
import 'package:kioku_navi/services/api/auth_interceptor.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';
import 'package:kioku_navi/services/auth/token_manager_impl.dart';
import 'package:kioku_navi/services/auth/login_service.dart';
import 'package:kioku_navi/services/quiz/question_service.dart';
import 'package:kioku_navi/services/quiz/answer_validator_impl.dart';
import 'package:kioku_navi/repositories/user_repository.dart';
import 'package:kioku_navi/repositories/quiz_repository.dart';
import 'package:kioku_navi/controllers/auth_controller.dart';
import 'package:kioku_navi/controllers/quiz_controller.dart';

class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    // API Clients
    Get.lazyPut<BaseApiClient>(() => BaseApiClient());
    
    // Repositories
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.lazyPut<QuizRepository>(() => QuizRepository());
    
    // API Services
    Get.lazyPut<AuthApi>(() => AuthApiImpl(apiClient: Get.find()));
    Get.lazyPut<QuizApi>(() => QuizApiImpl(apiClient: Get.find()));
    
    // Auth Services
    Get.lazyPut<TokenManager>(() => TokenManagerImpl(authApi: Get.find()));
    Get.lazyPut<LoginService>(() => LoginService(
      authApi: Get.find(),
      tokenManager: Get.find(),
    ));
    
    // Quiz Services
    Get.lazyPut<AnswerValidatorImpl>(() => AnswerValidatorImpl());
    Get.lazyPut<QuestionService>(() => QuestionService(
      quizApi: Get.find(),
    ));
    
    // Controllers
    Get.lazyPut<AuthController>(() => AuthController(
      loginService: Get.find(),
      userRepository: Get.find(),
    ));
    
    Get.lazyPut<QuizController>(() => QuizController(
      questionService: Get.find(),
      quizRepository: Get.find(),
      answerValidator: Get.find(),
    ));
    
    // Add auth interceptor to API client after dependencies are ready
    final authInterceptor = AuthInterceptor(tokenManager: Get.find());
    Get.find<BaseApiClient>().dio.interceptors.add(authInterceptor);
  }
}