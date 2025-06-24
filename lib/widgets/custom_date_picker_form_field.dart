import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

class CustomDatePickerFormField extends StatefulWidget {
  const CustomDatePickerFormField({
    required this.textController,
    required this.selectedDates,
    required this.onDateSelected,
    this.labelText,
    this.hintText,
    this.borderRadius = k12Double,
    this.isLabelLight = false,
    this.isValid,
    this.customValidators = const [],
    this.checkFormValidity,
    this.textInputAction = TextInputAction.next,
    super.key,
  });

  final String? labelText;
  final String? hintText;
  final double borderRadius;
  final bool isLabelLight;
  final RxBool? isValid;
  final TextEditingController textController;
  final RxList<DateTime?> selectedDates;
  final Function(List<DateTime?>) onDateSelected;
  final List<String? Function(String?)> customValidators;
  final VoidCallback? checkFormValidity;
  final TextInputAction textInputAction;

  @override
  State<CustomDatePickerFormField> createState() =>
      _CustomDatePickerFormFieldState();
}

class _CustomDatePickerFormFieldState extends State<CustomDatePickerFormField> {
  // Constants
  static const Color _primaryColor = Color(0xFF1976D2);
  static const Color _dialogBackgroundColor = Color(0xFFF7F9FC);
  static const List<String> _japaneseWeekdayLabels = [
    '日',
    '月',
    '火',
    '水',
    '木',
    '金',
    '土'
  ];

  // Text styles
  static const TextStyle _primaryBoldTextStyle = TextStyle(
    color: _primaryColor,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle _selectedDayTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle _dayTextStyle = TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle _disabledDayTextStyle = TextStyle(
    color: Colors.grey,
  );

  /// Create calendar configuration
  CalendarDatePicker2WithActionButtonsConfig _createCalendarConfig() {
    return CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.single,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      firstDayOfWeek: 1, // Monday
      controlsHeight: 50,
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),

      // Colors
      selectedDayHighlightColor: _primaryColor,
      daySplashColor: _primaryColor.withValues(alpha: 0.3),
      selectedRangeHighlightColor: _primaryColor.withValues(alpha: 0.2),

      // Weekday configuration
      weekdayLabels: _japaneseWeekdayLabels,
      weekdayLabelTextStyle: _primaryBoldTextStyle,

      // Text styles
      controlsTextStyle: _primaryBoldTextStyle,
      todayTextStyle: _primaryBoldTextStyle,
      selectedDayTextStyle: _selectedDayTextStyle,
      dayTextStyle: _dayTextStyle,
      disabledDayTextStyle: _disabledDayTextStyle,

      // Custom OK button
      okButton: const Text('確認', style: _primaryBoldTextStyle),

      // Date validation
      selectableDayPredicate: (day) => !day.isAfter(DateTime.now()),
    );
  }

  /// Show Japanese calendar date picker dialog
  Future<void> _showDatePicker(BuildContext context) async {
    final results = await showCalendarDatePicker2Dialog(
      context: context,
      config: _createCalendarConfig(),
      dialogSize: Size(k90Double.wp, k50Double.wp),
      borderRadius: BorderRadius.circular(k12Double),
      dialogBackgroundColor: _dialogBackgroundColor,
      value: widget.selectedDates.toList(),
    );

    if (results != null) {
      widget.onDateSelected(results);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final verticalPadding =
        width <= 428 ? k12Double : (width <= 768 ? k14Double : k16Double);

    return TextFormField(
      controller: widget.textController,
      readOnly: true,
      style:  TextStyle(fontSize: k10Double.sp),
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: widget.isLabelLight ? Colors.white : Colors.black,
          fontSize: k10Double.sp,
        ),
        contentPadding: EdgeInsets.symmetric(
                horizontal: k16Double.sp, vertical: verticalPadding),
        focusedBorder: _borderStyle(Colors.grey.shade500),
        border: _borderStyle(Colors.grey.shade400),
        enabledBorder: _borderStyle(Colors.grey.shade300),
        filled: true,
        fillColor: Colors.grey.shade50,
        hintText: widget.hintText,
        errorStyle: TextStyle(fontSize: k9Double.sp),
        suffixIcon: Icon(
          Icons.calendar_today,
          color: Colors.grey.shade600,
          size: k14Double.sp,
        ),
      ),
      onTap: () => _showDatePicker(context),
      validator: FormBuilderValidators.compose(widget.customValidators),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        widget.isValid?.value = widget.customValidators
            .every((validator) => validator(value) == null);
        widget.checkFormValidity?.call();
      },
    );
  }

  OutlineInputBorder _borderStyle(Color color) => OutlineInputBorder(
        borderSide: BorderSide(color: color, width: k1_5Double),
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
      );
}
