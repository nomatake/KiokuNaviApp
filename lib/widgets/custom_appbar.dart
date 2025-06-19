import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
import "package:kioku_navi/utils/extensions.dart";
import "package:kioku_navi/utils/sizes.dart";

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    this.centerTitle = false,
    this.isHasLeading = true,
    this.titleWidget,
    this.color,
    this.padding,
    this.iconColor,
    this.onBackPressed,
    this.isHasMoreHorizontal = false,
    this.actionPadding,
    this.onTap,
    this.backgroundColor,
    this.actions,
    this.isHasBorder = false,
    this.showCloseIcon = false,
  });
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final Widget? titleWidget;
  final bool centerTitle;
  final bool isHasLeading;
  final bool isHasMoreHorizontal;
  final Color? color;
  final Color? iconColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? actionPadding;
  final Function? onTap;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool? isHasBorder;
  final bool showCloseIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        border: (isHasBorder ?? true)
            ? Border(
                bottom: BorderSide(
                  color: Colors.grey.shade400,
                ),
              )
            : null,
      ),
      child: AppBar(
        backgroundColor: backgroundColor ?? Colors.transparent,
        elevation: k0Double,
        centerTitle: centerTitle,
        titleSpacing: k0Double,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: titleWidget,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: k16Double.sp,
          color: Color(0xFF616161).withValues(alpha: 0.2),
        ),
        leading: isHasLeading
            ? IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                iconSize: k20Double.sp,
                icon: Icon(
                  showCloseIcon
                      ? Icons.close_rounded
                      : Icons.arrow_back_rounded,
                  color: iconColor ?? const Color(0xFFA6A6A6),
                ),
                onPressed: onBackPressed ?? Get.back,
              )
            : null,
        automaticallyImplyLeading: false,
        actions: actions,
      ),
    );
  }
}
