import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taghyeer_task/core/error/failures.dart';
import '../../../../core/services/hive_service.dart';
import 'package:taghyeer_task/features/login/domain/repositories/auth_repository.dart';

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
    } on DioException catch (e) {
      if (e.error is Failure) {
        final failure = e.error as Failure;
        error.value = failure.isNoInternet ? 'No Internet Connection' : failure.message;
      } else {
         error.value = 'Login failed: ${e.message}';
      }
      Fluttertoast.showToast(msg: error.value);
    } catch (e) {
      error.value = 'Login failed. Please check your credentials.';
      Fluttertoast.showToast(msg: error.value);
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

