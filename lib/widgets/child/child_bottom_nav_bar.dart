import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/constants.dart';

class ChildBottomNavBar extends StatelessWidget {
  const ChildBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: kBottomNavBarHeight,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x08000000),
              offset: Offset(0, -4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _NavBarItem(label: 'ホーム', icon: Icons.home, selected: true),
            _NavBarItem(label: 'トレーニング', icon: Icons.fitness_center),
            _NavBarItem(label: 'ランキング', icon: Icons.emoji_events),
            _NavBarItem(label: 'コース', icon: Icons.school),
            _NavBarItem(label: 'その他', icon: Icons.settings),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  const _NavBarItem(
      {required this.label,
      required this.icon,
      this.selected = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon,
            color:
                selected ? const Color(0xFF1976D2) : const Color(0xFF7F7F7F)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFF1976D2) : const Color(0xFF7F7F7F),
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
