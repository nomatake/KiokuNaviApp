import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/utils/app_constants.dart';
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
    this.primaryColor = const Color(0xFF1976D2),
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
  final Color primaryColor;

  @override
  State<CustomDatePickerFormField> createState() =>
      _CustomDatePickerFormFieldState();
}

class _CustomDatePickerFormFieldState extends State<CustomDatePickerFormField> {
  // Constants
  static const Color _dialogBackgroundColor = Color(0xFFF7F9FC);
  static const List<String> _japaneseWeekdayLabels = [
    LocaleKeys.common_weekdays_sun,
    LocaleKeys.common_weekdays_mon,
    LocaleKeys.common_weekdays_tue,
    LocaleKeys.common_weekdays_wed,
    LocaleKeys.common_weekdays_thu,
    LocaleKeys.common_weekdays_fri,
    LocaleKeys.common_weekdays_sat,
  ];

  static double getResponsiveDialogWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width <= 428) {
      // iPhone and small devices
      return 350;
    } else if (width <= 768) {
      // Small tablets - increase width for better spacing
      return 580;
    } else {
      // iPads and larger tablets - increase width for better spacing
      return 680;
    }
  }

  static double getResponsiveDialogHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width <= 428) {
      // iPhone and small devices
      return 400;
    } else if (width <= 768) {
      // Small tablets - increase height for better row spacing
      return 540;
    } else {
      // iPads and larger tablets - increase height for better row spacing
      return 640;
    }
  }

  // Responsive text styles
  TextStyle _getPrimaryBoldTextStyle(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fontSize = width <= 428
        ? 16.0
        : width <= 768
            ? 19.0
            : 20.0;

    return TextStyle(
      color: widget.primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    );
  }

  static TextStyle _getSelectedDayTextStyle(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fontSize = width <= 428
        ? 16.0
        : width <= 768
            ? 19.0
            : 20.0;

    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
    );
  }

  static TextStyle _getDayTextStyle(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fontSize = width <= 428
        ? 16.0
        : width <= 768
            ? 19.0
            : 20.0;

    return TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
    );
  }

  static TextStyle _getDisabledDayTextStyle(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fontSize = width <= 428
        ? 16.0
        : width <= 768
            ? 19.0
            : 20.0;

    return TextStyle(
      color: Colors.grey,
      fontSize: fontSize,
    );
  }

  TextStyle _getWeekdayTextStyle(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fontSize = width <= 428
        ? 14.0
        : width <= 768
            ? 17.0
            : 18.0;

    return TextStyle(
      color: widget.primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    );
  }

  /// Create calendar configuration
  CalendarDatePicker2WithActionButtonsConfig _createCalendarConfig(
      BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final controlsHeight = width <= 428
        ? 50.0
        : width <= 768
            ? 80.0
            : 90.0;

    // Responsive day max width for better row spacing on iPad
    final dayMaxWidth = width <= 428
        ? null // Use default for phones
        : width <= 768
            ? 44.0 // Larger spacing for small tablets
            : 50.0; // Even larger spacing for iPads

    // Responsive gap between calendar and buttons
    final gapBetweenCalendarAndButtons = width <= 428
        ? 16.0
        : width <= 768
            ? 20.0
            : 24.0;

    // Responsive button padding for proper horizontal alignment
    final buttonPadding = width <= 428
        ? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)
        : width <= 768
            ? const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0)
            : const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0);

    // Responsive arrow padding for better touch targets
    final arrowPadding = width <= 428
        ? const EdgeInsets.all(4.0)
        : width <= 768
            ? const EdgeInsets.all(16.0)
            : const EdgeInsets.all(20.0);

    // Responsive arrow icon size
    final arrowIconSize = width <= 428
        ? 24.0
        : width <= 768
            ? 30.0
            : 32.0;

    return CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.single,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      firstDayOfWeek: 1, // Monday
      controlsHeight: controlsHeight,
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),

      // Day spacing configuration for better row spacing
      dayMaxWidth: dayMaxWidth,

      // Custom navigation arrows with padding
      lastMonthIcon: Padding(
        padding: arrowPadding,
        child: Icon(
          Icons.chevron_left,
          color: widget.primaryColor,
          size: arrowIconSize,
        ),
      ),
      nextMonthIcon: Padding(
        padding: arrowPadding,
        child: Icon(
          Icons.chevron_right,
          color: widget.primaryColor,
          size: arrowIconSize,
        ),
      ),

      // Colors
      selectedDayHighlightColor: widget.primaryColor,
      daySplashColor: widget.primaryColor.withValues(alpha: 0.3),
      selectedRangeHighlightColor: widget.primaryColor.withValues(alpha: 0.2),

      // Weekday configuration
      weekdayLabels: _japaneseWeekdayLabels.map((key) => key.tr).toList(),
      weekdayLabelTextStyle: _getWeekdayTextStyle(context),

      // Text styles
      controlsTextStyle: _getPrimaryBoldTextStyle(context),
      todayTextStyle: _getPrimaryBoldTextStyle(context),
      selectedDayTextStyle: _getSelectedDayTextStyle(context),
      dayTextStyle: _getDayTextStyle(context),
      disabledDayTextStyle: _getDisabledDayTextStyle(context),

      // Button configuration for proper horizontal padding
      gapBetweenCalendarAndButtons: gapBetweenCalendarAndButtons,
      buttonPadding: buttonPadding,

      // Custom OK button
      okButton: Text(LocaleKeys.common_buttons_confirm.tr,
          style: _getPrimaryBoldTextStyle(context)),

      // Custom cancel button
      cancelButton: Text(LocaleKeys.common_buttons_cancel.tr,
          style: _getPrimaryBoldTextStyle(context)),

      // Date validation
      selectableDayPredicate: (day) => !day.isAfter(DateTime.now()),
    );
  }

  /// Show Japanese calendar date picker dialog
  Future<void> _showDatePicker(BuildContext context) async {
    final results = await showCalendarDatePicker2Dialog(
      context: context,
      config: _createCalendarConfig(context),
      dialogSize: Size(
        getResponsiveDialogWidth(context),
        getResponsiveDialogHeight(context),
      ),
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
      style: TextStyle(fontSize: AppFontSize.caption.sp),
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: widget.isLabelLight ? Colors.white : Colors.grey.shade500,
          fontSize: AppFontSize.caption.sp,
        ),
        contentPadding: EdgeInsets.symmetric(
            horizontal: k16Double.sp, vertical: verticalPadding),
        focusedBorder: _borderStyle(Colors.grey.shade500),
        border: _borderStyle(Colors.grey.shade400),
        enabledBorder: _borderStyle(Colors.grey.shade300),
        filled: true,
        fillColor: Colors.grey.shade50,
        hintText: null,
        errorStyle: TextStyle(fontSize: AppFontSize.caption.sp),
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
