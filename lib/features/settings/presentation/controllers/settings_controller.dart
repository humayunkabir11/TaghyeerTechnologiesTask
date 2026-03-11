import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taghyeer_task/core/services/hive_service.dart';
import 'package:taghyeer_task/features/login/data/models/user_model.dart';
import 'package:taghyeer_task/core/network/api_client.dart';

class SettingsController extends GetxController {
  final HiveService hiveService;
  final ApiClient apiClient;

  final isDarkMode = false.obs;
  final user = Rxn<UserModel>();

  SettingsController(this.hiveService, this.apiClient);

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = hiveService.isDarkMode();
    user.value = hiveService.getUser();
  }

  void toggleTheme() {
    isDarkMode.toggle();
    hiveService.saveThemeMode(isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> logout() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              await hiveService.clearUser();
              Get.offAllNamed('/');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
