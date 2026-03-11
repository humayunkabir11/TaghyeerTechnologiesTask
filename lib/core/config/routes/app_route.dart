import 'package:get/get.dart';

import 'package:taghyeer_task/features/login/presentation/bindings/login_binding.dart';
import 'package:taghyeer_task/features/main/presentation/pages/main_page.dart';
import 'package:taghyeer_task/features/login/presentation/pages/login_page.dart';
import 'package:taghyeer_task/features/main/presentation/bindings/main_binding.dart';



class AppRoute {
  static final pages = [
    GetPage(
      name: '/',
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/main',
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
  ];
}
