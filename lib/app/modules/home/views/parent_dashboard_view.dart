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
                          SizedBox(height: k3Double.hp),
                          // Family Info Card
                          if (family != null && user != null) ...[
                            _buildFamilyInfoCard(family, user),
                            SizedBox(height: k3Double.hp),
                          ],

                          // Children Section
                          _buildChildrenSection(),

                          SizedBox(height: k3Double.hp)
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
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE3F2FD),
            Color(0xFFBBDEFB),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(k5Double.wp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(k3Double.wp),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1976D2).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.family_restroom,
                    color: Colors.white,
                    size: k6Double.wp,
                  ),
                ),
                SizedBox(width: k3Double.wp),
                Expanded(
                  child: Text(
                    LocaleKeys.pages_dashboard_familyInfo_title.tr,
                    style: TextStyle(
                      fontSize: k14Double.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1976D2),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: k2Double.hp),
            _buildInfoRow(Icons.person,
                LocaleKeys.pages_dashboard_familyInfo_parent.tr, user.name),
            _buildInfoRow(
                Icons.qr_code,
                LocaleKeys.pages_dashboard_familyInfo_familyCode.tr,
                family.familyCode),
            _buildInfoRow(
                Icons.devices,
                LocaleKeys.pages_dashboard_familyInfo_deviceMode.tr,
                family.deviceMode.displayName),
            _buildInfoRow(
                Icons.child_care,
                LocaleKeys.pages_dashboard_familyInfo_children.tr,
                '${controller.children.length}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: k1Double.hp * 0.5),
      padding: EdgeInsets.all(k3Double.wp),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1976D2).withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(k2Double.wp),
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1976D2),
              size: k5Double.wp,
            ),
          ),
          SizedBox(width: k3Double.wp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: k9Double.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: k1Double.hp * 0.3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: k12Double.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1976D2),
                  ),
                ),
              ],
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
        Container(
          padding: EdgeInsets.all(k4Double.wp),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE8F5E8), Color(0xFFF0F8FF)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(k2Double.wp),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.child_care,
                  color: Colors.white,
                  size: k5Double.wp,
                ),
              ),
              SizedBox(width: k3Double.wp),
              Expanded(
                child: Text(
                  LocaleKeys.pages_dashboard_children_title.tr,
                  style: TextStyle(
                    fontSize: k14Double.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              ),
              GestureDetector(
                onTap: controller.showAddChildDialog,
                child: Container(
                  padding: EdgeInsets.all(k2Double.wp),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: k5Double.wp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: k3Double.hp),
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
    return Container(
      padding: EdgeInsets.all(k8Double.wp),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF8E1),
            Color(0xFFFFF3E0),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFB74D).withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9800).withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(k4Double.wp),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF9800).withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.child_friendly,
              size: k8Double.wp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: k3Double.hp),
          Text(
            LocaleKeys.pages_dashboard_children_noChildren.tr,
            style: TextStyle(
              fontSize: k14Double.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFE65100),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: k2Double.hp),
          Text(
            'Tap the + button to add your first child',
            style: TextStyle(
              fontSize: k12Double.sp,
              color: const Color(0xFFBF360C),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChildCard(ChildModel child) {
    return Obx(() {
      final joinCode = controller.getJoinCode(child.id);
      final hasActiveCode = controller.hasActiveJoinCode(child.id);

      return Container(
        margin: EdgeInsets.only(bottom: k3Double.hp),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: child.status.name == 'pending'
                ? [const Color(0xFFFFF3E0), const Color(0xFFFFE0B2)]
                : [const Color(0xFFE8F5E8), const Color(0xFFC8E6C9)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (child.status.name == 'pending'
                      ? const Color(0xFFFF9800)
                      : const Color(0xFF4CAF50))
                  .withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: (child.status.name == 'pending'
                    ? const Color(0xFFFFB74D)
                    : const Color(0xFF81C784))
                .withValues(alpha: 0.3),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(k5Double.wp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: child.status.name == 'pending'
                            ? [const Color(0xFFFF9800), const Color(0xFFFFB74D)]
                            : [
                                const Color(0xFF4CAF50),
                                const Color(0xFF66BB6A)
                              ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (child.status.name == 'pending'
                                  ? const Color(0xFFFF9800)
                                  : const Color(0xFF4CAF50))
                              .withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: k6Double.wp,
                      child: Text(
                        child.nickname[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: k16Double.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: k4Double.wp),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          child.nickname,
                          style: TextStyle(
                            fontSize: k14Double.sp,
                            fontWeight: FontWeight.w800,
                            color: child.status.name == 'pending'
                                ? const Color(0xFFE65100)
                                : const Color(0xFF2E7D32),
                          ),
                        ),
                        SizedBox(height: k1Double.hp * 0.5),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: k2Double.wp,
                            vertical: k1Double.wp,
                          ),
                          decoration: BoxDecoration(
                            color: (child.status.name == 'pending'
                                    ? const Color(0xFFFF9800)
                                    : const Color(0xFF4CAF50))
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Age: ${_calculateChildAge(child.birthDate)} • ${child.status.displayName}',
                            style: TextStyle(
                              fontSize: k10Double.sp,
                              color: child.status.name == 'pending'
                                  ? const Color(0xFFE65100)
                                  : const Color(0xFF2E7D32),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    child: Container(
                      padding: EdgeInsets.all(k2Double.wp),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF9800).withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: k5Double.wp,
                      ),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'remove',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red[600]),
                            SizedBox(width: k2Double.wp),
                            Text(
                              LocaleKeys.pages_dashboard_children_remove.tr,
                              style: TextStyle(
                                color: Colors.red[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
                  CustomButton.orange(
                    text:
                        LocaleKeys.pages_dashboard_children_generateJoinCode.tr,
                    onPressed: () => controller.generateJoinCode(child),
                  ),
                ],
              ] else ...[
                SizedBox(height: k3Double.hp),
                Container(
                  padding: EdgeInsets.all(k4Double.wp),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE8F5E8), Color(0xFFC8E6C9)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(k2Double.wp),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: k4Double.wp,
                        ),
                      ),
                      SizedBox(width: k3Double.wp),
                      Flexible(
                        child: Text(
                          LocaleKeys.pages_dashboard_children_childActive.tr,
                          style: TextStyle(
                            color: const Color(0xFF2E7D32),
                            fontSize: k10Double.sp,
                            fontWeight: FontWeight.w700,
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
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFF9800)),
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
                  color: const Color(0xFFE65100),
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
                    color: const Color(0xFFE65100),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _copyToClipboard(joinCode.code),
                icon: const Icon(Icons.copy),
                color: const Color(0xFFE65100),
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
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(k4Double.wp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                LocaleKeys.pages_dashboard_children_removeDialog_title.tr,
                style: TextStyle(
                  fontSize: k14Double.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: k2Double.hp),
              
              // Content
              Text(
                'Are you sure you want to remove ${child.nickname} from your family?',
                style: TextStyle(
                  fontSize: k12Double.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                ),
              ),
              
              SizedBox(height: k3Double.hp),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: EdgeInsets.symmetric(
                          vertical: k1Double.hp,
                          horizontal: k2Double.wp,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        LocaleKeys.pages_dashboard_children_removeDialog_cancel.tr,
                        style: TextStyle(
                          fontSize: k10Double.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: k4Double.wp),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.removeChild(child);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(
                          vertical: k1Double.hp,
                          horizontal: k2Double.wp,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        LocaleKeys.pages_dashboard_children_removeDialog_remove.tr,
                        style: TextStyle(
                          fontSize: k10Double.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
