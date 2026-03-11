import 'package:get/get.dart';

import '../../../../core/di/init_dependencies.dart';
import '../../../../core/network/api_client.dart';
import 'package:taghyeer_task/features/posts/domain/repositories/posts_repository.dart';
import 'package:taghyeer_task/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:taghyeer_task/features/posts/domain/usecase/get_posts_usecase.dart';
import 'package:taghyeer_task/features/posts/presentation/controllers/posts_controller.dart';
import 'package:taghyeer_task/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:taghyeer_task/features/products/data/datasources/products_remote_data_source.dart';
import 'package:taghyeer_task/features/products/domain/usecase/get_products_usecase.dart';
import 'package:taghyeer_task/features/products/domain/repositories/products_repository.dart';
import 'package:taghyeer_task/features/products/presentation/controllers/products_controller.dart';
import 'package:taghyeer_task/features/products/data/repositories/products_repository_impl.dart';
import 'package:taghyeer_task/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:taghyeer_task/features/settings/domain/repositories/settings_repository.dart';
import 'package:taghyeer_task/features/settings/domain/usecase/logout_usecase.dart';
import 'package:taghyeer_task/features/settings/domain/usecase/toggle_theme_usecase.dart';
import 'package:taghyeer_task/features/settings/presentation/controllers/settings_controller.dart';
import 'package:taghyeer_task/features/main/presentation/controllers/navigation_controller.dart';


class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationController());
    Get.lazyPut<ProductsRemoteDataSource>(() => ProductsRemoteDataSourceImpl(apiClient: sl<ApiClient>()));
    Get.lazyPut<ProductsRepository>(() => ProductsRepositoryImpl(Get.find()));
    Get.lazyPut(() => GetProductsUseCase(Get.find()));
    Get.lazyPut(() => ProductsController(Get.find()));
    Get.lazyPut<PostsRemoteDataSource>(() => PostsRemoteDataSourceImpl(apiClient: sl<ApiClient>()));
    Get.lazyPut<PostsRepository>(() => PostsRepositoryImpl(Get.find()));
    Get.lazyPut(() => GetPostsUseCase(Get.find()));
    Get.lazyPut(() => PostsController(Get.find()));
    
    Get.lazyPut<SettingsRepository>(() => SettingsRepositoryImpl(Get.find()));
    Get.lazyPut(() => LogoutUseCase(Get.find()));
    Get.lazyPut(() => ToggleThemeUseCase(Get.find()));
    Get.lazyPut(() => SettingsController(Get.find(), Get.find(), Get.find()));
  }
}
