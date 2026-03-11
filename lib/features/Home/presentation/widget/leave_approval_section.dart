import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hrx/core/config/color/custom_color.dart';
import 'package:hrx/core/config/util/style.dart';
import 'package:hrx/core/local_db_helper/local_bd_isar.dart';
import 'package:hrx/core/routes/routes.dart';
import 'package:hrx/features/Home/presentation/controller/Home_controller.dart';
import 'package:hrx/features/Leave/data/models/leave_data.dart';
import 'package:hrx/features/Leave/presentation/widget/rejection_note_tile.dart';
import 'package:hrx/features/Leave/presentation/widget/rejection_reason_sheet.dart';
import 'package:intl/intl.dart';

import '../../../../core/custom_assets/assets.gen.dart';
import '../../../../core/routes/route_path.dart';

class LeaveApprovalSection extends GetView<HomeController> {
  final bool isFromLeave;
  const LeaveApprovalSection({super.key, this.isFromLeave = false});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.pendingLeaveApplications.isEmpty) {
        return SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Leave Request",
            style: latoBold.copyWith(
              fontSize: 18,
              color: AppColors.primaryTextColor,
              letterSpacing: 0,
            ),
          ),
          const Gap(16),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.pendingLeaveApplications.length,
            separatorBuilder: (context, index) => const Gap(16),
            itemBuilder: (context, index) {
              final leaveData = controller.pendingLeaveApplications[index];
              return LeaveApprovalCard(leaveData: leaveData, isFromLeave: isFromLeave,);
            },
          ),
        ],
      );
    });
  }
}

class LeaveApprovalCard extends GetView<HomeController> {
  final LeaveData leaveData;
  final bool isFromLeave;

  const LeaveApprovalCard({super.key, required this.leaveData, required this.isFromLeave});

  String _formatAppliedDate() {
    if (leaveData.appliedAt == null) return 'N/A';
    return DateFormat('MMM dd, yyyy').format(leaveData.appliedAt!);
  }

  Color _getStatusColor() {
    switch (leaveData.status?.toUpperCase()) {
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'PENDING':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    return leaveData.status?.toUpperCase() ?? 'PENDING';
  }

  bool _canTakeAction() {
    return leaveData.status?.toUpperCase() == 'PENDING';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showActionBottomSheet(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 10),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            // side: BorderSide(
            //   width: 0.50,
            //   color: const Color(0xFF979797),
            // ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Header Row: Employee Info + Date
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Employee Info
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar
                        Container(
                          width: 31,
                          height: 30,
                          decoration: ShapeDecoration(
                            color: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.93),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              leaveData.employee?.name
                                      ?.substring(0, 1)
                                      .toUpperCase() ??
                                  'U',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Gap(6),
                        // Employee Details
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                leaveData.employee?.name ?? 'Unknown',
                                style: TextStyle(
                                  color: const Color(0xFF444444),
                                  fontSize: 14,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Gap(4),
                              Text(
                                'Leave Request - ${leaveData.numDays ?? 0} day${(leaveData.numDays ?? 0) > 1 ? 's' : ''}',
                                style: TextStyle(
                                  color: const Color(0xFF444444),
                                  fontSize: 12,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(8),
                  // Date and Status
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: const Color(0xFF979797),
                          ),
                          const Gap(3),
                          Text(
                            _formatAppliedDate(),
                            style: TextStyle(
                              color: const Color(0xFF444444),
                              fontSize: 11,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const Gap(4),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _getStatusColor(),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _getStatusText(),
                          style: TextStyle(
                            color: _getStatusColor(),
                            fontSize: 10,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isFromLeave && _canTakeAction()) ...[
              const Gap(8),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Reject Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final user = await IsarDBHelper().getUser();
                        final employeeData = await IsarDBHelper().getEmployeeData(
                          user!.userId!,
                        );

                        showLeaveRejectBottomSheet(
                          context: context,
                          isLoading:
                          controller.rejectingLeaveId.value ==
                              leaveData.id,
                          onReject: (reason) {
                            controller
                                .rejectLeaveApplication(
                              leaveData.id!,
                              employeeData!.userId!,
                              reason ?? "",
                              context,
                            )
                                .then((_) {
                              AppRouter.router
                                  .pop(); // close after success
                            });
                          },
                        );
                      },
                      child: Obx(() {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: const Color(0xFF17598B),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: controller.rejectingLeaveId.value == leaveData.id
                              ? Center(
                                  child: SizedBox.square(
                                    dimension: 24,
                                    child: CircularProgressIndicator(
                                      strokeCap: StrokeCap.round,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Reject',
                                  style: TextStyle(
                                    color: const Color(0xFF17598B),
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        );
                      }),
                    ),
                  ),
                  const Gap(10),
                  // Approve Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final user = await IsarDBHelper().getUser();
                        final employeeData = await IsarDBHelper().getEmployeeData(
                          user!.userId!,
                        );

                        controller
                            .approveLeaveApplication(
                              leaveData.id!,
                              employeeData?.userId ?? "",
                              "",
                              context,
                            )
                            .then((_) {
                              controller.loadPendingLeaveApplications();
                            });
                      },
                      child: Obx(() {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF17598B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: controller.approvingLeaveId.value == leaveData.id
                              ? Center(
                                  child: SizedBox.square(
                                    dimension: 24,
                                    child: CircularProgressIndicator(
                                      strokeCap: StrokeCap.round,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Approve',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showActionBottomSheet(BuildContext context) async {
    // Get approver ID
    final user = await IsarDBHelper().getUser();
    final employeeData = await IsarDBHelper().getEmployeeData(user!.userId!);

    if (employeeData == null || employeeData.userId == null) {
      Get.snackbar(
        'Error',
        'Failed to get user information',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final approverId = employeeData.userId!;

    String formatDateRange() {
      if (leaveData.startDate == null || leaveData.endDate == null) {
        return 'Date not available';
      }
      final startDay = DateFormat('MMM dd').format(leaveData.startDate!);
      final endDay = DateFormat('dd, yyyy').format(leaveData.endDate!);
      return '$startDay - $endDay';
    }

    String formatAppliedDate() {
      if (leaveData.createdAt == null) return 'N/A';
      return DateFormat('dd-MM-yyyy').format(leaveData.createdAt!);
    }

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Date Header with handle bar
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    // Handle bar
                    Container(
                      width: 40,
                      height: 5,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFD9D9D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const Gap(16),
                    // Date Range Title
                    Text(
                      formatDateRange(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF444444),
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Employee Info Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: const Color(0xFF979797),
                          ),
                          top: BorderSide(
                            width: 1,
                            color: const Color(0xFF979797),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Profile Image
                          Container(
                            width: 67,
                            height: 67,
                            decoration: ShapeDecoration(
                              color: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: const Color(0xFF2CA2C1),
                                ),
                                borderRadius: BorderRadius.circular(65),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                leaveData.employee?.name
                                        ?.substring(0, 1)
                                        .toUpperCase() ??
                                    'U',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const Gap(26),
                          // Employee Details
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  leaveData.employee?.name ?? 'Unknown',
                                  style: TextStyle(
                                    color: const Color(0xFF444444),
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  'ID: ${leaveData.employee?.employeeId ?? 'N/A'}',
                                  style: TextStyle(
                                    color: const Color(0xFF444444),
                                    fontSize: 14,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Gap(30),

                    // Leave Details Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Labels Column
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Leave Type',
                              style: TextStyle(
                                color: const Color(0xFF979797),
                                fontSize: 14,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Gap(20),
                            Text(
                              'Applied On',
                              style: TextStyle(
                                color: const Color(0xFF979797),
                                fontSize: 14,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Gap(20),
                            Text(
                              'Documents',
                              style: TextStyle(
                                color: const Color(0xFF979797),
                                fontSize: 14,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Gap(20),
                            Text(
                              'Leave Remaining',
                              style: TextStyle(
                                color: const Color(0xFF979797),
                                fontSize: 14,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        // Values Column
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              leaveData.leaveType ?? 'N/A',
                              style: TextStyle(
                                color: const Color(0xFF444444),
                                fontSize: 14,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Gap(20),
                            Text(
                              formatAppliedDate(),
                              style: TextStyle(
                                color: const Color(0xFF444444),
                                fontSize: 14,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Gap(20),
                            GestureDetector(
                              onTap: () {
                                context.pushNamed(
                                  Routes.documentViewPage,
                                  extra: leaveData.attachmentUrls ?? [],
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Color(0xFFDBDBDB),
                                  borderRadius: BorderRadiusGeometry.circular(
                                    4,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 4,
                                  children: [
                                    Assets.icons.icAttachment.svg(),
                                    Text(
                                      leaveData.attachmentUrls?.isNotEmpty ==
                                              true
                                          ? '${(leaveData.attachmentUrls ?? []).length} file(s)'
                                          : 'N/A',
                                      style: latoMedium.copyWith(
                                        fontSize: 13,
                                        color: AppColors.primaryColor,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Gap(20),
                            Text(
                              leaveData.numDays?.toString().padLeft(2, '0') ??
                                  'N/A',
                              style: TextStyle(
                                color: const Color(0xFF444444),
                                fontSize: 14,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    if (leaveData.comments != null)
                      RejectionNoteTile(note: leaveData.comments),

                    const Gap(30),

                    // Action Buttons
                    if (leaveData.status?.toUpperCase() == "PENDING")
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 56,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: const Color(0xFF17598B),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Obx(
                                () => TextButton(
                                  onPressed: () {
                                    showLeaveRejectBottomSheet(
                                      context: context,
                                      isLoading:
                                          controller.rejectingLeaveId.value ==
                                          leaveData.id,
                                      onReject: (reason) {
                                        controller
                                            .rejectLeaveApplication(
                                              leaveData.id!,
                                              approverId,
                                              reason ?? "",
                                              context,
                                            )
                                            .then((_) {
                                              AppRouter.router
                                                  .pop(); // close after success
                                            });
                                      },
                                    );
                                  },
                                  child:
                                      controller.rejectingLeaveId.value ==
                                          leaveData.id
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Reject',
                                          style: TextStyle(
                                            color: Color(0xFF17598B),
                                            fontSize: 16,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: Container(
                              height: 56,
                              decoration: ShapeDecoration(
                                color: const Color(0xFF17598B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Obx(
                                () => TextButton(
                                  onPressed:
                                      controller.approvingLeaveId.value ==
                                          leaveData.id
                                      ? null
                                      : () {
                                          controller.approveLeaveApplication(
                                            leaveData.id!,
                                            approverId,
                                            "",
                                            context,
                                          );
                                        },
                                  child:
                                      controller.approvingLeaveId.value ==
                                          leaveData.id
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : Text(
                                          'Approve',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    const Gap(24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
