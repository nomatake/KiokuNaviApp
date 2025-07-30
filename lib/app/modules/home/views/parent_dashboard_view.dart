import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/home/controllers/parent_dashboard_controller.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/models/child_model.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/custom_snackbar.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/widgets/parent_bottom_nav_bar.dart';

class ParentDashboardView extends GetView<ParentDashboardController> {
  const ParentDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(LocaleKeys.pages_dashboard_title.tr),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1976D2),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: controller.loadFamilyData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              bottom: false,
              child: PaddedWrapper(
                child: Obx(() {
                  final family = controller.familyInfo.value;
                  final user = controller.user.value;

                  return RefreshIndicator(
                    onRefresh: controller.loadFamilyData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Family Info Card
                          if (family != null && user != null) ...[
                            _buildFamilyInfoCard(family, user),
                            SizedBox(height: k3Double.hp),
                          ],

                          // Children Section
                          _buildChildrenSection(),

                          SizedBox(height: k10Double.hp), // Space for FAB
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          // Bottom Navigation Bar
          const ParentBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildFamilyInfoCard(family, user) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(k4Double.wp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.family_restroom,
                  color: const Color(0xFF1976D2),
                  size: k6Double.wp,
                ),
                SizedBox(width: k2Double.wp),
                Text(
                  LocaleKeys.pages_dashboard_familyInfo_title.tr,
                  style: TextStyle(
                    fontSize: k18Double.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1976D2),
                  ),
                ),
              ],
            ),
            SizedBox(height: k3Double.hp),
            _buildInfoRow(
                LocaleKeys.pages_dashboard_familyInfo_parent.tr, user.name),
            _buildInfoRow(LocaleKeys.pages_dashboard_familyInfo_familyCode.tr,
                family.familyCode),
            _buildInfoRow(LocaleKeys.pages_dashboard_familyInfo_deviceMode.tr,
                family.deviceMode.displayName),
            _buildInfoRow(LocaleKeys.pages_dashboard_familyInfo_children.tr,
                '${controller.children.length}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: k1Double.hp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: k14Double.sp,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: k14Double.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildrenSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.pages_dashboard_children_title.tr,
              style: TextStyle(
                fontSize: k20Double.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1976D2),
              ),
            ),
            IconButton(
              onPressed: controller.showAddChildDialog,
              icon: const Icon(Icons.add),
              color: const Color(0xFF1976D2),
              tooltip: LocaleKeys.pages_dashboard_children_addChild.tr,
            ),
          ],
        ),
        SizedBox(height: k2Double.hp),
        Obx(() {
          if (controller.children.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.children.length,
            itemBuilder: (context, index) {
              final child = controller.children[index];
              return _buildChildCard(child);
            },
          );
        }),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(k6Double.wp),
        child: Column(
          children: [
            Icon(
              Icons.child_friendly,
              size: k15Double.wp,
              color: Colors.grey[400],
            ),
            SizedBox(height: k2Double.hp),
            Text(
              LocaleKeys.pages_dashboard_children_noChildren.tr,
              style: TextStyle(
                fontSize: k16Double.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: k1Double.hp),
            Text(
              'Tap the + button to add your first child',
              style: TextStyle(
                fontSize: k14Double.sp,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildCard(ChildModel child) {
    return Obx(() {
      final joinCode = controller.getJoinCode(child.id);
      final hasActiveCode = controller.hasActiveJoinCode(child.id);

      return Card(
        margin: EdgeInsets.only(bottom: k2Double.hp),
        child: Padding(
          padding: EdgeInsets.all(k4Double.wp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF1976D2),
                    child: Text(
                      child.nickname[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: k3Double.wp),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          child.nickname,
                          style: TextStyle(
                            fontSize: k16Double.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Age: ${_calculateChildAge(child.birthDate)} • Status: ${child.status.displayName}',
                          style: TextStyle(
                            fontSize: k12Double.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'remove',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text(LocaleKeys.pages_dashboard_children_remove.tr),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'remove') {
                        _showRemoveChildDialog(child);
                      }
                    },
                  ),
                ],
              ),
              if (child.status.name == 'pending') ...[
                SizedBox(height: k3Double.hp),
                if (joinCode != null && hasActiveCode) ...[
                  _buildJoinCodeDisplay(joinCode),
                ] else ...[
                  CustomButton.primary(
                    text:
                        LocaleKeys.pages_dashboard_children_generateJoinCode.tr,
                    onPressed: () => controller.generateJoinCode(child),
                  ),
                ],
              ] else ...[
                SizedBox(height: k2Double.hp),
                Container(
                  padding: EdgeInsets.all(k2Double.wp),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.green[600], size: k4Double.wp),
                      SizedBox(width: k2Double.wp),
                      Flexible(
                        child: Text(
                          LocaleKeys.pages_dashboard_children_childActive.tr,
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: k12Double.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildJoinCodeDisplay(joinCode) {
    return Container(
      padding: EdgeInsets.all(k3Double.wp),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1976D2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.pages_dashboard_children_joinCodeTitle.tr,
                style: TextStyle(
                  fontSize: k14Double.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1976D2),
                ),
              ),
              Text(
                'Expires: ${_formatTimeRemaining(joinCode.expiresAt)}',
                style: TextStyle(
                  fontSize: k10Double.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: k1Double.hp),
          Row(
            children: [
              Expanded(
                child: Text(
                  joinCode.formattedCode,
                  style: TextStyle(
                    fontSize: k20Double.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: const Color(0xFF1976D2),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _copyToClipboard(joinCode.code),
                icon: const Icon(Icons.copy),
                color: const Color(0xFF1976D2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code));
    CustomSnackbar.showSuccess(
      title: 'Copied!',
      message: LocaleKeys.pages_dashboard_children_joinCodeCopied.tr,
    );
  }

  String _formatTimeRemaining(DateTime expiresAt) {
    final remaining = expiresAt.difference(DateTime.now());
    if (remaining.isNegative) {
      return LocaleKeys.pages_dashboard_children_expired.tr;
    }

    final minutes = remaining.inMinutes;
    if (minutes < 60) {
      return '${minutes}m';
    } else {
      final hours = remaining.inHours;
      return '${hours}h ${minutes % 60}m';
    }
  }

  void _showRemoveChildDialog(ChildModel child) {
    Get.dialog(
      AlertDialog(
        title: Text(LocaleKeys.pages_dashboard_children_removeDialog_title.tr),
        content: Text(
            'Are you sure you want to remove ${child.nickname} from your family?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
                LocaleKeys.pages_dashboard_children_removeDialog_cancel.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.removeChild(child);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
                LocaleKeys.pages_dashboard_children_removeDialog_remove.tr,
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  int _calculateChildAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
