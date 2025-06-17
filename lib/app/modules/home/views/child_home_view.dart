import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/child_home_controller.dart';

class ChildHomeView extends GetView<ChildHomeController> {
  const ChildHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Top Section: Profile, Progress, Dolphin Logo
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile/Progress Card (left)
                        Expanded(
                          child: Container(
                            height: 76,
                            decoration: BoxDecoration(
                              color: const Color(0xFF57CC02),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                ),
                                const BoxShadow(
                                  color: Color(0xFF47A302),
                                  offset: Offset(0, -4),
                                  blurRadius: 0,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    '5年下・第18回',
                                    style: TextStyle(
                                      color: Color(0xBFFFFFFF),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '日本のおもな都市・地形図の読み方',
                                    style: TextStyle(
                                      color: Color(0xFF2196F3),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Progress/Score Card (right)
                        Container(
                          height: 76,
                          width: 68,
                          decoration: BoxDecoration(
                            color: const Color(0xFF57CC02).withOpacity(0.2),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                              const BoxShadow(
                                color: Color(0xFF47A302),
                                offset: Offset(0, -4),
                                blurRadius: 0,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                '1180',
                                style: TextStyle(
                                  color: Color(0xFF1CB0F6),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '2',
                                style: TextStyle(
                                  color: Color(0xFFFF9600),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Dolphin Logo (centered)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      height: 130,
                      width: 130,
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                  // Start Button
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4BA0EA),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'スタート',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          // Bottom Navigation Bar (custom)
          SafeArea(
            top: false,
            child: Container(
              height: 80,
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
          ),
        ],
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
        Icon(icon, color: selected ? Color(0xFF1976D2) : Color(0xFF7F7F7F)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: selected ? Color(0xFF1976D2) : Color(0xFF7F7F7F),
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
