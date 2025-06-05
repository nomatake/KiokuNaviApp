import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:form_builder_validators/form_builder_validators.dart";
import "package:get/get.dart";
import "package:kioku_navi/utils/extensions.dart";
import "package:kioku_navi/utils/sizes.dart";

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    required this.textController,
    this.labelText,
    this.hintText,
    this.borderRadius = k30Double,
    this.maxLines = k1,
    this.isPassword = false,
    this.isLabelLight = false,
    this.isValid,
    this.keyboardType = TextInputType.number,
    this.validator,
    this.customValidators = const [],
    this.checkFormValidity,
    this.inputFormatters = const [],
    this.textInputAction = TextInputAction.next,
    this.suffixText,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Padding(
            padding: EdgeInsets.only(left: k2Double.wp),
            child: Text(
              widget.labelText!,
              style: TextStyle(
                fontSize: k10Double.sp,
                color: widget.isLabelLight ? Colors.white : Colors.black,
              ),
            ),
          ),
          SizedBox(height: k0_2Double.hp),
        ],
        ValueListenableBuilder<bool>(
          valueListenable: _isPasswordVisible,
          builder: (context, isVisible, _) {
            return TextFormField(
              style: TextStyle(fontSize: k11Double.sp),
              textInputAction: widget.textInputAction,
              maxLines: widget.maxLines,
              obscureText: widget.isPassword && !isVisible,
              controller: widget.textController,
              inputFormatters: widget.inputFormatters,
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: k4Double.wp, vertical: k0Double.hp),
                  focusedBorder: _borderStyle(Colors.grey.shade500),
                  border: _borderStyle(Colors.grey.shade400),
                  enabledBorder: _borderStyle(Colors.grey.shade300),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  hintText: widget.hintText,
                  hintStyle:
                      TextStyle(color: Colors.grey, fontSize: k11Double.sp),
                  errorStyle: TextStyle(fontSize: k9Double.sp),
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
                                size: k16Double.sp,
                              ),
                              onPressed: () =>
                                  _isPasswordVisible.value = !isVisible,
                            );
                          },
                        )
                      : null),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose(widget.customValidators),
              onChanged: (value) {
                widget.isValid?.value = widget.customValidators
                    .every((validator) => validator(value) == null);

                widget.checkFormValidity?.call();
              },
            );
          },
        ),
      ],
    );
  }

  OutlineInputBorder _borderStyle(Color color) => OutlineInputBorder(
        borderSide: BorderSide(color: color),
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
      );
}
