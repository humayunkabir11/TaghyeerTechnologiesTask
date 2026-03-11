import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/hive_service.dart';
import 'package:taghyeer_task/features/login/domain/repositories/auth_repository.dart';
import 'package:taghyeer_task/features/login/data/models/user_model.dart';

class LoginController extends GetxController {
  final AuthRepository authRepository;
  final HiveService hiveService;

  final usernameController = TextEditingController(text: "emilys");
  final passwordController = TextEditingController(text: "emilyspass");
  
  final isLoading = false.obs;
  final error = ''.obs;

  LoginController(this.authRepository, this.hiveService);

  @override
  void onInit() {
    super.onInit();
    _checkAutoLogin();
  }

  void _checkAutoLogin() {
    final user = hiveService.getUser();
    if (user != null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Get.offAllNamed('/main');
      });
    }
  }

  Future<void> login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      error.value = 'Username and password are required';
      return;
    }

    isLoading.value = true;
    error.value = '';

    try {
      final user = await authRepository.login(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );
      await hiveService.saveUser(user);
      Get.offAllNamed('/main');
    } catch (e) {
      error.value = 'Login failed. Please check your credentials.';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
