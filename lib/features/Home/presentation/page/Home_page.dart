import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hrx/core/common/widgets/appbar/custom_appbar.dart';
import 'package:hrx/core/common/widgets/button/ai_agent_button.dart';
import 'package:hrx/core/config/color/custom_color.dart';
import 'package:hrx/core/config/util/style.dart';
import 'package:hrx/core/custom_assets/assets.gen.dart';
import 'package:hrx/core/routes/route_path.dart';
import 'package:hrx/features/Attandencee/presentation/controller/Attandencee_controller.dart';
import 'package:hrx/features/Home/presentation/controller/Home_controller.dart';
import 'package:hrx/features/Home/presentation/widget/action_tile.dart';
import 'package:hrx/features/Home/presentation/widget/attendance_button.dart';
import 'package:hrx/features/Home/presentation/widget/attendance_summary.dart';
import 'package:hrx/features/Home/presentation/widget/carousel_slider.dart';
import 'package:hrx/features/Main/presentation/controller/shift_controller.dart';
import 'package:hrx/features/Home/presentation/widget/leave_approval_section.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/widgets/button/notification_button.dart';
import '../../../../core/common/widgets/image/cache_image.dart';
import '../../../Login/presentation/controller/Login_controller.dart';
import '../widget/custom_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeController controller;
  late ShiftController shiftController;
  late AttandenceeController attendanceController;

  final GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.find<HomeController>();
    shiftController = Get.find<ShiftController>();
    attendanceController = Get.find<AttandenceeController>();
    attendanceController = Get.find<AttandenceeController>();
    // loginController.emailController.text="";
    // loginController.emailController.clear();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.pendingLeaveApplications.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: CustomDrawer(),
      appBar: CustomAppBar(
        height: 80,
        automaticallyImplyLeading: false,
        // Remove back button
        leadingWidth: 16,
        // Remove left spacing
        leading: SizedBox(),
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: InkWell(
            onTap: () {
              key.currentState!.openDrawer();
            },
            child: Obx(() {
              return Container(
                height: 50.h,
                width: 50.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.circular(100),
                  border: Border.all(color: Color(0xff17598B), width: 2.33),
                ),
                child: CacheImage(
                  imageUrl: controller.employee.value?.photo,
                  height: 50.h,
                  width: 50.w,
                  borderRadius: 100,
                  errorWidget: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        (controller.employee.value?.name ?? "-")
                            .toString()[0]
                            .toString()
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 32.h,
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          title: Obx(() {
            return Text(
              controller.employee.value?.name ?? "N/A",
              style: latoRegular.copyWith(
                fontSize: 20,
                color: AppColors.primaryTextColor,
                letterSpacing: 0,
              ),
            );
          }),
          subtitle: Text(
            "Today’s Work Overview -${DateFormat('dd MMM, yyyy').format(
                DateTime.now())}",
            style: latoRegular.copyWith(
              fontSize: 12,
              color: AppColors.blurryWhite,
              letterSpacing: 0,
            ),
          ),
          trailing: NotificationButton(onTap: () {}),
        ),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 0.5),
          child: Divider(
            color: AppColors.blurryWhite,
            thickness: 0.5,
            height: 8,
          ),
        ),
      ),
      // floatingActionButton: AiAgentButton(onTap: () {}),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.refreshFunc();
        },
        color: AppColors.primaryColor,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ///--------------------check-in section
              Obx(() {
                if (attendanceController.attendanceLoading.value ||
                    shiftController.shiftLoading.value) {
                  return const SizedBox();
                }

                return AttendanceButton(
                  homeController: controller,
                  controller: shiftController,
                  todayAttendance: attendanceController.getAttendance.value,
                  employee: controller.employee.value,
                );
              }),

              ///--------------------attendance summary
              const Gap(12),
              Obx(() {
                if (shiftController.shiftLoading.value ||
                    attendanceController.attendanceLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }

                return AttendanceSummary(
                  assignment: shiftController.shift.value,
                  todayAttendance: attendanceController.getAttendance.value,
                );
              }),

              ///--------------------task & payroll
              const Gap(16),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: ActionTile(
                      bgCardPath: Assets.images.cardTask.path,
                      icon: Assets.icons.icTask.svg(),
                      title: "Task Report",
                      subtitle: "Check your task report for this week.", onTap: () {  },
                    ),
                  ),
                  Expanded(
                    child: ActionTile(
                        onTap: () {
                          context.goNamed(Routes.payrollPage);
                        },
                      bgCardPath: Assets.images.cardPayroll.path,
                      icon: Assets.icons.icPayroll.svg(),
                      title: "Payrolls",
                      subtitle: "View your salary breakdown !",
                    ),
                  ),
                ],
              ),

              ///--------------------announcement slider
              const Gap(12),
              const CarouselSlider(),

              ///--------------------leave approvals
              const Gap(16),

              Obx(() {
                if (controller.isLoadingLeaveApplications.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                      strokeCap: StrokeCap.round,
                    ),
                  );
                }
                return Center(child: LeaveApprovalSection());
              }),

              const Gap(100),
            ],
          ),
        ),
      ),
    );
  }
}
