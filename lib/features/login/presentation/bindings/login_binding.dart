import 'package:get/get.dart';
import '../../../../core/di/init_dependencies.dart';
import '../../../../core/network/api_client.dart';
import 'package:taghyeer_task/features/login/data/repositories/auth_repository_impl.dart';
import 'package:taghyeer_task/features/login/domain/repositories/auth_repository.dart';
import 'package:taghyeer_task/features/login/presentation/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(sl<ApiClient>()));
    Get.lazyPut(() => LoginController(Get.find(), Get.find()));
  }
}
