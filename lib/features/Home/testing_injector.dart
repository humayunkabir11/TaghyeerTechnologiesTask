
import 'package:get/get.dart';
import 'package:taghyeer_task/features/Home/presentation/controller/Home_controller.dart';

import '../../core/di/init_dependencies.dart';
import '../../core/network/connection_checker.dart';
import 'data/datasource/Home_remote_source.dart';
import 'data/repositories/Home_repository_impl.dart';
import 'domain/repositories/Home_repository.dart';
import 'domain/usecase/Home_use_case.dart';


class HomeInjector {
  /// Initialize Home feature dependencies
  static Future<void> init() async {

    // Remote Data Source
    sl.registerLazySingleton<HomeRemoteSource>(
      () => HomeRemoteSourceImpl(
        apiMethod: sl(), // Make sure ApiClient is already registered
      ),
    );

    // Repository
    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(
        remoteSource: sl<HomeRemoteSource>(),
        connectionChecker: sl<ConnectionChecker>(),
      ),
    );

    // UseCase
    sl.registerLazySingleton(
      () => HomeUseCase(
        homeRepository: sl<HomeRepository>(),
      ),
    );

    

    
    // GetX-controller
    Get.lazyPut<HomeController>(
      () => HomeController(homeUseCase: sl<HomeUseCase>()),
    );
    
  }
}
