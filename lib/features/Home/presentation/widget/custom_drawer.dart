import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hrx/core/common/widgets/button/elevated_custome_button.dart';
import 'package:hrx/core/common/widgets/image/cache_image.dart';
import 'package:hrx/core/config/util/style.dart';
import 'package:hrx/core/local_db_helper/local_bd_isar.dart';
import 'package:hrx/core/routes/route_path.dart';
import 'package:hrx/core/routes/routes.dart';
import 'package:hrx/dependenci__injection/init_dependencies.dart';
import 'package:hrx/features/Home/data/models/employee_model.dart';
import 'package:hrx/features/Home/presentation/controller/Home_controller.dart';
import 'package:hrx/features/Main/presentation/controller/shift_controller.dart';

import '../../../../core/config/color/custom_color.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    
    return Container(
      width: 376 - 123,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 46),
      child: Obx(() {
        final employee = controller.employee.value;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 76.h,
              width: 76.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusGeometry.circular(100),
                border: Border.all(color: Color(0xff17598B), width: 2.33),
              ),
              child: CacheImage(
                imageUrl: employee?.photo,
                height: 76.h,
                width: 76.w,
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
                      (employee?.name ?? "-")
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
            ),
            Gap(12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    employee?.name ?? "N/A",
                    overflow: TextOverflow.ellipsis,
                    style: latoBold.copyWith(
                      color: Color(0xff444444),
                      fontSize: 24,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.pushNamed(Routes.editBasicInfoPage, extra: employee);
                  },
                  icon: SvgPicture.asset("assets/icons/pencil-edit-02.svg"),
                ),
              ],
            ),
            Gap(12),
            Text(
              employee?.designation?.name ?? 'N/A',
              style: TextStyle(
                color: const Color(0xFF444444),
                fontSize: 14,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
              ),
            ),
            Gap(12),
            SizedBox(
              width: 216,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Office : ',
                      style: TextStyle(
                        color: const Color(0xFF444444),
                        fontSize: 12,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: employee?.office?.name ?? 'N/A',
                      style: TextStyle(
                        color: const Color(0xFF444444),
                        fontSize: 14,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap(12),
            SizedBox(
              width: 216,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Department : ',
                      style: TextStyle(
                        color: const Color(0xFF444444),
                        fontSize: 12,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: employee?.department?.name ?? 'N/A',
                      style: TextStyle(
                        color: const Color(0xFF444444),
                        fontSize: 14,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap(12),
            FittedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset("assets/icons/mail.svg"),
                  Gap(2),
                  Text(
                    employee?.email ?? 'N/A',
                    style: TextStyle(
                      color: const Color(0xFF444444),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Gap(12),
            Row(
              children: [
                SvgPicture.asset("assets/icons/telephone.svg"),
                Gap(2),
                Text(
                  employee?.phone ?? 'N/A',
                  style: TextStyle(
                    color: const Color(0xFF444444),
                    fontSize: 14,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Gap(30),
            Divider(color: Color(0xff444444)),
            Spacer(),
            CustomElevatedButton(
              onPressed: () {
                serviceLocator<IsarDBHelper>().clearUserData().then((s) {
                  AppRouter.router.goNamed(Routes.loginPage);
                  Get.find<HomeController>().employee.value = null;
                  Get.find<ShiftController>().shift.value = null;
                });
              },
              titleText: "Log out",
              titleColor: Colors.white,
              iconLeft: SvgPicture.asset("assets/icons/logout.svg"),
            ),
          ],
        );
      }),
    );
  }
}
