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
        padding:
            EdgeInsets.only(left: 14, right: k6Double.wp, top: 8, bottom: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(
                showCloseIcon ? Icons.close_rounded : Icons.arrow_back_rounded,
                color: const Color(0xFFA6A6A6),
              ),
              iconSize: k20Double.sp,
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              splashRadius: 24,
            ),
            const SizedBox(width: 8),
            Expanded(child: RegisterProgressBar(progress: progress)),
          ],
        ),
      ),
    );
  }
}
