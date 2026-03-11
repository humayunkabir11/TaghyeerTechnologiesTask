import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../login/domain/entities/user_entity.dart';
import '../../domain/usecase/logout_usecase.dart';
import '../../domain/usecase/toggle_theme_usecase.dart';
import '../../domain/repositories/settings_repository.dart';


class SettingsController extends GetxController {
  final LogoutUseCase logoutUseCase;
  final ToggleThemeUseCase toggleThemeUseCase;
  final SettingsRepository settingsRepository;

  final isDarkMode = false.obs;
  final user = Rxn<UserEntity>();

  SettingsController(
    this.logoutUseCase,
    this.toggleThemeUseCase,
    this.settingsRepository,
  );



  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = settingsRepository.isDarkMode();
    user.value = settingsRepository.getUser();
  }

  Future<void> toggleTheme() async {
    isDarkMode.toggle();
    await toggleThemeUseCase.call(isDarkMode.value);
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
              await logoutUseCase.call(const NoParams());
              Get.offAllNamed('/');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
