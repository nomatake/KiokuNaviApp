import 'package:flutter/material.dart';
import 'package:kioku_navi/widgets/register_progress_bar.dart';
import 'package:kioku_navi/utils/constants.dart';

class RegisterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double progress;
  final VoidCallback? onBack;
  final Color backgroundColor;

  const RegisterAppBar({
    Key? key,
    required this.progress,
    this.onBack,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.only(left: 14, right: 16, top: 8, bottom: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              splashRadius: 24,
            ),
            const SizedBox(width: 8),
            RegisterProgressBar(progress: progress),
          ],
        ),
      ),
    );
  }
} 