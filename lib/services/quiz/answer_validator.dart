import 'package:kioku_navi/models/question.dart';

abstract class AnswerValidator {
  bool validate({
    required Question question,
    required dynamic userAnswer,
  });
}