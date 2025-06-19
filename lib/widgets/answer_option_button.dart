import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

enum AnswerState { none, selected, correct, incorrect }

class AnswerOptionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AnswerState state;

  const AnswerOptionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.state = AnswerState.none,
  });

  Color get _backgroundColor {
    switch (state) {
      case AnswerState.none:
        return Colors.white;
      case AnswerState.selected:
        return const Color(0xFFE3F2FD);
      case AnswerState.correct:
        return const Color(0xFFD3F5DD);
      case AnswerState.incorrect:
        return const Color(0xFFFEE5E5);
    }
  }

  Color get _borderColor {
    switch (state) {
      case AnswerState.none:
        return const Color(0xFFB0BEC5);
      case AnswerState.selected:
        return const Color(0xFF1976D2);
      case AnswerState.correct:
        return const Color(0xFF15B440);
      case AnswerState.incorrect:
        return const Color(0xFFE53935);
    }
  }

  Color get _textColor {
    switch (state) {
      case AnswerState.none:
      case AnswerState.selected:
        return const Color(0xFF424242);
      case AnswerState.correct:
        return const Color(0xFF019B2B);
      case AnswerState.incorrect:
        return const Color(0xFFB71C1C);
    }
  }

  Color get _shadowColor {
    switch (state) {
      case AnswerState.none:
        return const Color(0xFFB0BEC5);
      case AnswerState.selected:
        return const Color(0xFF1976D2);
      case AnswerState.correct:
        return const Color(0xFF15B440);
      case AnswerState.incorrect:
        return const Color(0xFFE53935);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: k50Double,
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(k12Double),
          border: Border.all(
            color: _borderColor,
            width: k2Double,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
            BoxShadow(
              color: _shadowColor,
              offset: const Offset(0, 3),
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Hiragino Sans',
              fontWeight: FontWeight.w700,
              fontSize: k12Double.sp,
              color: _textColor,
            ),
          ),
        ),
      ),
    );
  }
}
