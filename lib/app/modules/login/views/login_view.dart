import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Title
              const Text(
                'キオクナビ',
                style: TextStyle(
                  fontFamily: 'Hiragino Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                  color: Color(0xFF1976D2),
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              const Text(
                '楽しく学ぼう',
                style: TextStyle(
                  fontFamily: 'Hiragino Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: Color(0xFFB1B1B1),
                ),
              ),
              const SizedBox(height: 32),
              // Dolphin Placeholder
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(70),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.image,
                    size: 80,
                    color: Color(0xFF2196F3),
                  ),
                ),
              ),
              const Spacer(),
              // Blue '次へ' button above the white buttons (strict Figma style)

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFF1E88E5), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x1A000000), // 0.08 opacity black
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                          BoxShadow(
                            color: Color(0xFF1E88E5).withOpacity(1),
                            offset: Offset(0, 4),
                            blurRadius: 0,
                            spreadRadius: 0,
                            // This is not a true inset shadow, but Flutter doesn't support inset natively
                          ),
                        ]),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1976D2).withOpacity(0.8),
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {},
                      child: const Text(
                        'hello',
                        style: TextStyle(
                          fontFamily: 'Hiragino Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Login as Student
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFF1E88E5), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x1A000000), // 0.08 opacity black
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                        BoxShadow(
                          color: Color(0xFF1E88E5).withOpacity(1),
                          offset: Offset(0, 4),
                          blurRadius: 0,
                          spreadRadius: 0,
                          // This is not a true inset shadow, but Flutter doesn't support inset natively
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: const Color(0xFF1976D2),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {},
                      child: const Text(
                        '生徒としてログイン',
                        style: TextStyle(
                          fontFamily: 'Hiragino Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Login as Guardian
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFF1E88E5), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x1A000000), // 0.08 opacity black
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                        BoxShadow(
                          color: Color(0xFF1E88E5).withOpacity(1),
                          offset: Offset(0, 4),
                          blurRadius: 0,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: const Color(0xFF1976D2),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {},
                      child: const Text(
                        '保護者としてログイン',
                        style: TextStyle(
                          fontFamily: 'Hiragino Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Next and Register buttons

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
