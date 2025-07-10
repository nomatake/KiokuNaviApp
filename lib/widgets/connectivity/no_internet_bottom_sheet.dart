import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/custom_title_text.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class NoInternetBottomSheet {
  static void show() {
    final context = getx.Get.context;
    if (context == null || !context.mounted) return;

    WoltModalSheet.show(
      enableDrag: false,
      showDragHandle: false,
      barrierDismissible: false,
      context: context,
      pageListBuilder: (modalContext) => [
        SliverWoltModalSheetPage(
          hasTopBarLayer: false,
          forceMaxHeight: false,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          useSafeArea: true,
          mainContentSliversBuilder: (context) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(k6Double.wp),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: k25Double.sp,
                      backgroundColor: Colors.grey.shade100,
                      child: Icon(
                        Icons.wifi_off_rounded,
                        size: k25Double.sp,
                        color: Colors.red.shade600,
                      ),
                    ),
                    SizedBox(height: k2_5Double.hp),
                    const CustomTitleText(text: "No Network Available"),
                    SizedBox(height: k0_5Double.hp),
                    Text(
                      'Please check your data or WiFi network connection.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: k12Double.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: kNeg0_5Double,
                      ),
                    ),
                    SizedBox(height: k3Double.hp),
                    CustomButton.primary(
                      text: "OK",
                      onPressed: () {
                        // Simply close the bottom sheet
                        getx.Get.back(closeOverlays: true);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
      modalTypeBuilder: (context) => WoltModalType.bottomSheet(),
    );
  }
}
