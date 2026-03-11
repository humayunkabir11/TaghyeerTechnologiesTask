import 'package:get/get.dart';

import '../../../../core/di/init_dependencies.dart';
import '../../../../core/network/api_client.dart';
import 'package:taghyeer_task/features/posts/domain/repositories/posts_repository.dart';
import 'package:taghyeer_task/features/posts/presentation/controllers/posts_controller.dart';
import 'package:taghyeer_task/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:taghyeer_task/features/products/data/repositories/products_repository_impl.dart';
import 'package:taghyeer_task/features/products/domain/repositories/products_repository.dart';
import 'package:taghyeer_task/features/products/presentation/controllers/products_controller.dart';
import 'package:taghyeer_task/features/settings/presentation/controllers/settings_controller.dart';
import 'package:taghyeer_task/features/main/presentation/controllers/navigation_controller.dart';


class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationController());
    Get.lazyPut<ProductsRepository>(() => ProductsRepositoryImpl(sl<ApiClient>()));
    Get.lazyPut(() => ProductsController(Get.find()));
    Get.lazyPut<PostsRepository>(() => PostsRepositoryImpl(sl<ApiClient>()));
    Get.lazyPut(() => PostsController(Get.find()));
    Get.lazyPut(() => SettingsController(Get.find(), sl<ApiClient>()));
  }
}
