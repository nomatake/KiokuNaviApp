import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/widgets/register_app_bar.dart';

class TutorialNineView extends StatelessWidget {
  const TutorialNineView({super.key});

  // Colors
  static const bubbleBackgroundColor = Color(0xFFF7F7F7);
  static const bubbleBorderColor = Color(0xFFD8D8D8);
  static const textColor = Color(0xFF212121);
  static const containerBorderColor = Color(0xFFE5E5E5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegisterAppBar(
        progress: 1,
        onBack: () => Get.back(),
      ),
      body: SafeArea(
        child: PaddedWrapper(
          bottom: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: k4Double.hp),

              // Chat bubble section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Assets.images.logo.image(
                    height: k25Double.wp,
                    width: k25Double.wp,
                    fit: BoxFit.contain,
                  ),
                  Expanded(
                    child: Bubble(
                      style: BubbleStyle(
                        margin: BubbleEdges.only(top: k10Double),
                        elevation: k10Double,
                        color: bubbleBackgroundColor,
                        borderColor: bubbleBorderColor,
                        borderWidth: k2_5Double,
                        padding: BubbleEdges.all(k10Double),
                        alignment: Alignment.topLeft,
                        nip: BubbleNip.leftBottom,
                        nipWidth: k4Double.wp,
                        nipHeight: k5Double.wp,
                        nipOffset: k25Double,
                        radius: Radius.circular(k14Double),
                      ),
                      child: Text(
                        'レッスンが習慣になるように通知を送るよ！',
                        style: TextStyle(
                          fontFamily: 'Hiragino Sans',
                          fontWeight: FontWeight.w400,
                          fontSize: k14Double.sp,
                          color: textColor,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: k10Double.hp),

              // Notification permission dialog
              _buildNotificationDialog(),

              const Spacer(),

              // Bottom button
              CustomButton.primary(
                text: 'レッスンリマインダーを受け取る',
                onPressed: () {
                  // TODO: Handle reminder setup
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationDialog() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(k5Double.wp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(k20Double),
          border: Border.all(
            color: containerBorderColor,
            width: k2_5Double,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Notification icon
            Icon(
              Icons.notifications_active,
              size: k9Double.wp,
              color: const Color(0xFFAFAFAF),
            ),

            SizedBox(height: k2Double.hp),

            // Permission text
            Text(
              'キオクナビ に通知の送信を\n許可して受信しますか？',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Hiragino Sans',
                fontSize: k14Double.sp,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            ),

            SizedBox(height: k3Double.hp),

            // Allow button
            SizedBox(
              width: double.infinity,
              height: k12Double.wp,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Handle allow permission
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF0F0F0),
                  foregroundColor: const Color(0xFF1976D2),
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(k15Double),
                  ),
                  elevation: k0Double,
                ),
                child: Text(
                  '許可する',
                  style: TextStyle(
                    fontFamily: 'Hiragino Sans',
                    fontSize: k12Double.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            SizedBox(height: k1_5Double.hp),

            // Don't allow button
            SizedBox(
              width: double.infinity,
              height: k12Double.wp,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Handle deny permission
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF0F0F0),
                  foregroundColor: const Color(0xFFAEAEAE),
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(k15Double),
                  ),
                  elevation: k0Double,
                ),
                child: Text(
                  '許可しない',
                  style: TextStyle(
                    fontFamily: 'Hiragino Sans',
                    fontSize: k12Double.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
