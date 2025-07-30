import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/app/modules/learning/models/question.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_text_form_field.dart';

class QuestionAnswerTemplate extends StatefulWidget {
  final Question question;
  
  const QuestionAnswerTemplate({
    super.key,
    required this.question,
  });

  @override
  State<QuestionAnswerTemplate> createState() => _QuestionAnswerTemplateState();
}

class _QuestionAnswerTemplateState extends State<QuestionAnswerTemplate> {
  late TextEditingController textController;
  late LearningController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<LearningController>();
    textController = TextEditingController();
  }

  @override
  void didUpdateWidget(QuestionAnswerTemplate oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Clear the text controller when question changes
    if (oldWidget.question.id != widget.question.id) {
      textController.clear();
      controller.setTextAnswer(''); // Also clear the controller's text answer
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Obx(() {
      final isSubmitted = controller.hasSubmitted.value;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            // Show image if available in metadata
            _buildQuestionImage(),

            SizedBox(height: k2Double.hp),
            
            // Input field
            CustomTextFormField(
              textController: textController,
              labelText: LocaleKeys.pages_learning_pleaseEnterYourAnswer.tr,
              hintText: LocaleKeys.pages_learning_pleaseEnterYourAnswer.tr,
              readOnly: isSubmitted,
              customValidators: isSubmitted ? [] : [
                FormBuilderValidators.required(
                  errorText: LocaleKeys.validation_required.tr,
                ),
              ],
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              maxLines: 1,
              checkFormValidity: () {
                if (!isSubmitted) {
                  // Update the text answer in controller when user types
                  controller.setTextAnswer(textController.text);
                  // Enable submit button if text is not empty
                  if (textController.text.trim().isNotEmpty) {
                    controller.selectedOptionIndex.value = 0;
                  } else {
                    controller.selectedOptionIndex.value = -1;
                  }
                }
              },
            ),
          ],
      );
    });
  }
  
  Widget _buildQuestionImage() {
    // Check if metadata exists and has image
    final metadata = widget.question.data.metadata;
    String? imageUrl;
    
    if (metadata != null && metadata is Map<String, dynamic>) {
      imageUrl = metadata['image'] as String?;
    }
    
    // Validate URL
    bool isValidUrl = imageUrl != null && GetUtils.isURL(imageUrl);
    
    return Container(
      margin: EdgeInsets.only(bottom: k3Double.hp),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(k10Double),
        child: isValidUrl
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: k20Double.hp,
                cacheWidth: (Get.width * Get.pixelRatio).toInt(),
                cacheHeight: (k20Double.hp * Get.pixelRatio).toInt(),
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildImageLoadingIndicator();
                },
              )
            : _buildPlaceholderImage(),
      ),
    );
  }
  
  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: k20Double.hp,
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(26),
        borderRadius: BorderRadius.circular(k10Double),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(k10Double),
        child: Assets.images.questionAnswerPlaceholder.image(
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
  
  Widget _buildImageLoadingIndicator() {
    return Container(
      width: double.infinity,
      height: k20Double.hp,
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(26),
        borderRadius: BorderRadius.circular(k10Double),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      ),
    );
  }
}