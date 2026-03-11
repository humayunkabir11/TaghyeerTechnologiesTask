import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/config/routes/app_route.dart';
import 'core/config/strings/app_strings.dart';
import 'core/config/theme/app_theme.dart';
import 'core/di/init_dependencies.dart';
import 'core/services/hive_service.dart';
import 'core/utils/dev_logs.dart';

import 'core/network/global_connection_wrapper.dart';

void main() async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize all dependencies (including Hive) via one entry point
      await initDependencies();

      // Device Orientation
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // Status Bar Style
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ));

      runApp(const MyApp());
    },
    (error, stackTrace) {
      devLog(
        tag: "APPLICATION-ERROR",
        payload: {"error": "$error", "stackTrace": "$stackTrace"},
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final hiveService = Get.find<HiveService>();
    final bool isDarkMode = hiveService.isDarkMode();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: false,
      builder: (context, child) {
          return GlobalConnectionWrapper(
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: AppStrings.appName,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              initialRoute: '/',
              getPages: AppRoute.pages,
            ),
          );
      },
    );
  }
}
