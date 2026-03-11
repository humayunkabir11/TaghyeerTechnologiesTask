import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hrx/core/utils/dev_log.dart';
import 'package:hrx/core/utils/show_toast.dart';
import 'package:hrx/features/Attandencee/data/models/today_attendance_response_model.dart';
import 'package:hrx/features/Home/data/models/employee_model.dart';
import 'package:hrx/features/Home/presentation/controller/Home_controller.dart';
import 'package:hrx/features/Main/presentation/controller/shift_controller.dart';

import '../../../../core/common/widgets/button/elevated_custome_button.dart';
import '../../../../core/config/color/custom_color.dart';
import '../../../../core/config/util/style.dart';
import '../../../../core/custom_assets/assets.gen.dart';
import '../../../../core/extentions/custom_extentions.dart';
import '../../../../core/routes/route_path.dart';
import '../../../Attandencee/presentation/widget/check_out_summery_bottom_sheet.dart';
import 'geo_fency_bottom.dart';
import 'show_geo_fence_warning.dart';

class AttendanceButton extends StatelessWidget {
  final TodayAttendanceResponseModelData? todayAttendance;
  final ShiftController controller;
  final EmployeeModel? employee;
  final HomeController homeController;

  const AttendanceButton({
    super.key,
    required this.todayAttendance,
    required this.controller,
    this.employee,
    required this.homeController,
  });

  @override
  Widget build(BuildContext context) {
    final siftStatus = todayAttendance?.shiftStatus?.toUpperCase();

    return Container(
      height: 51,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadows: [
          BoxShadow(
            color: Color(0x19D6D6D6),
            blurRadius: 10,
            offset: Offset(0, 0),
            spreadRadius: 9,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
          Assets.icons.icStreamline.svg(),
          Expanded(
            child: Text(
              siftStatus == "SHIFT_ENDED"
                  ? "Check out at ${todayAttendance?.data?.checkOutTime?.toAmPm ?? "-"} "
                  : siftStatus == "IN_SHIFT"
                  ? "Check in at ${todayAttendance?.data?.checkInTime?.toAmPm ?? "-"} "
                  : siftStatus == "NOT_STARTED"
                  ? "Please check in"
                  : "",
              style: latoBold.copyWith(
                fontSize: 14,
                color: AppColors.primaryColor,
                letterSpacing: 0,
              ),
            ),
          ),
          siftStatus == "SHIFT_ENDED"
              ? const SizedBox()
              : CustomElevatedButton(
                  onPressed: () {
                    /// --------------- not shift assigned---------------
                    if (controller.shift.value == null) {
                      showToast(
                        message: "You don’t have a shift assigned yet.",
                      );
                      return;
                    }

                    /// ------ Geo Fence Validation ------
                    if(homeController.isGeoAttendance.value){
                      final permission = employee?.fenceAttendancePermission;
                      final isCheckIn = siftStatus != "IN_SHIFT";
                      final isCheckOut = siftStatus == "IN_SHIFT";

                      // Validate for CHECK_IN
                      if(isCheckIn && ['CHECK_IN_ONLY', 'BOTH'].contains(permission)){
                        if(homeController.distanceRadius.value == null || employee?.radius == null){
                          showGeoFenceWarning(context);
                          return;
                        }
                        final distanceRadius = homeController.distanceRadius.value ?? 0;
                        final employeeRadius = employee?.radius?.toDouble() ?? 0;

                        devLog(tag: "DISTANCE", payload: {
                          "distance_radius": distanceRadius,
                          "employee_radius": employeeRadius,
                        });

                        if(employeeRadius < distanceRadius){
                          showGeoFenceWarning(context);
                          return;
                        }
                      }

                      // Validate for CHECK_OUT
                      if(isCheckOut && ['CHECK_OUT_ONLY', 'BOTH'].contains(permission)){
                        if(homeController.distanceRadius.value == null || employee?.radius == null){
                          showGeoFenceWarning(context);
                          return;
                        }
                        final distanceRadius = homeController.distanceRadius.value ?? 0;
                        final employeeRadius = employee?.radius?.toDouble() ?? 0;
                        if(employeeRadius > distanceRadius){
                          showGeoFenceWarning(context);
                          return;
                        }
                      }
                    }


                    /// --------------- in shift---------------
                    if (siftStatus == "IN_SHIFT") {
                      context.goNamed(Routes.attendancePage);
                    } else {
                      context.pushNamed(Routes.checkInPage);
                    }
                  },
                  titleText: siftStatus == "NOT_STARTED"
                      ? "Check in"
                      : siftStatus == "IN_SHIFT"
                      ? "Insight"
                      : '---',
                  buttonHeight: 30,
                  buttonWidth: 74,
                  buttonColor: AppColors.primaryColor,
                  borderRdius: 8,
                  titleStyle: latoMedium.copyWith(
                    fontSize: 14,
                    color: Colors.white,
                    letterSpacing: 0,
                  ),
                ),
        ],
      ),
    );
  }
}
