import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/services/hive_service.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../data/models/user_model.dart';

class LoginController extends GetxController {
  final LoginUseCase loginUseCase;
  final HiveService hiveService;

  final usernameController = TextEditingController(text: "emilys");
  final passwordController = TextEditingController(text: "emilyspass");
  
  final isLoading = false.obs;
  final error = ''.obs;

  LoginController(this.loginUseCase, this.hiveService);

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
      final result = await loginUseCase.call(
        LoginParams(
          username: usernameController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );

      result.fold(
        (l) {
          if (l.isNoInternet) {
            // Already handled in ApiClient probably, but we can set loading false here
            isLoading.value = false;
          } else {
            error.value = l.message;
            Fluttertoast.showToast(msg: error.value);
          }
        },
        (r) async {
          if (r is UserModel) {
            await hiveService.saveUser(r);
          }
          Get.offAllNamed('/main');
        },
      );
    } catch (e) {
      error.value = 'Login failed. Please check your credentials.';
      Fluttertoast.showToast(msg: error.value);
    } finally {
      isLoading.value = false;
    }
  }
  RxBool isPasswordHidden = true.obs;

  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

