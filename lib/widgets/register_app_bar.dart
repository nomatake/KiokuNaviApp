import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/register_progress_bar.dart';

class RegisterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double progress;
  final VoidCallback? onBack;
  final Color backgroundColor;
  final bool showCloseIcon;

  const RegisterAppBar({
    super.key,
    required this.progress,
    this.onBack,
    this.backgroundColor = Colors.transparent,
    this.showCloseIcon = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: backgroundColor,
        height: kToolbarHeight,
        padding: EdgeInsets.only(right: k6Double.wp),
        child: Stack(
          children: [
            // Center the entire row content vertically
            Center(
              child: Row(
                children: [
                  // Icon button with consistent sizing
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(
                      showCloseIcon
                          ? Icons.close_rounded
                          : Icons.arrow_back_rounded,
                      color: const Color(0xFFA6A6A6),
                    ),
                    iconSize: k20Double.sp,
                    onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                    padding: EdgeInsets.zero,
                  ),
                  // Progress bar with proper alignment
                  Expanded(
                    child: RegisterProgressBar(progress: progress),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
