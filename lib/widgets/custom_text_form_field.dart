import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:form_builder_validators/form_builder_validators.dart";
import "package:get/get.dart";
import "package:kioku_navi/utils/extensions.dart";
import "package:kioku_navi/utils/app_constants.dart";

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    required this.textController,
    this.labelText,
    this.hintText,
    this.borderRadius = AppBorderRadius.md,
    this.maxLines = 1,
    this.isPassword = false,
    this.isLabelLight = false,
    this.isValid,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.customValidators = const [],
    this.checkFormValidity,
    this.inputFormatters = const [],
    this.textInputAction = TextInputAction.next,
    this.suffixText,
    this.readOnly = false,
    super.key,
  });

  final String? labelText;
  final String? hintText;
  final double borderRadius;
  final int maxLines;
  final bool isPassword;
  final bool isLabelLight;
  final RxBool? isValid;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final List<String? Function(String?)> customValidators;
  final VoidCallback? checkFormValidity;
  final List<TextInputFormatter> inputFormatters;
  final TextInputAction textInputAction;
  final String? suffixText;
  final bool readOnly;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier(false);

  @override
  void dispose() {
    _isPasswordVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate responsive vertical padding based on screen size
    final width = Get.width;
    final verticalPadding =
        width <= 428 ? AppSpacing.md : (width <= 768 ? AppSpacing.lg : AppSpacing.xl);

    return ValueListenableBuilder<bool>(
      valueListenable: _isPasswordVisible,
      builder: (context, isVisible, _) {
        return TextFormField(
          style: TextStyle(fontSize: AppFontSize.caption.sp),
          textInputAction: widget.textInputAction,
          maxLines: widget.maxLines,
          obscureText: widget.isPassword && !isVisible,
          controller: widget.textController,
          inputFormatters: widget.inputFormatters,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          enableInteractiveSelection: !widget.readOnly,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText: widget.labelText,
            labelStyle: TextStyle(
              color: widget.isLabelLight ? Colors.white : Colors.grey.shade500,
              fontSize: AppFontSize.caption.sp,
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg.sp, vertical: verticalPadding),
            focusedBorder: _borderStyle(Colors.grey.shade500),
            border: _borderStyle(Colors.grey.shade400),
            enabledBorder: _borderStyle(Colors.grey.shade300),
            filled: true,
            fillColor: Colors.grey.shade50,
            hintText: null,
            errorStyle: TextStyle(
              fontSize: AppFontSize.caption.sp,
              height: 1.2,
            ),
            errorMaxLines: null, // Allow unlimited error lines
            suffixText: widget.suffixText,
            suffixIcon: widget.isPassword
                ? ValueListenableBuilder<bool>(
                    valueListenable: _isPasswordVisible,
                    builder: (context, isVisible, _) {
                      return IconButton(
                        icon: Icon(
                          isVisible
                              ? Icons.remove_red_eye_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.black,
                          size: AppIconSize.sm.sp,
                        ),
                        onPressed: () => _isPasswordVisible.value = !isVisible,
                      );
                    },
                  )
                : null,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: FormBuilderValidators.compose(widget.customValidators),
          onChanged: (value) {
            widget.isValid?.value = widget.customValidators
                .every((validator) => validator(value) == null);
            widget.checkFormValidity?.call();
          },
        );
      },
    );
  }

  OutlineInputBorder _borderStyle(Color color) => OutlineInputBorder(
        borderSide: BorderSide(color: color, width: AppSpacing.xxxs),
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
      );
}
