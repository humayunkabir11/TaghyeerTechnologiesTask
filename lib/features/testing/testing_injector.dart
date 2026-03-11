
import 'package:get/get.dart';

import '../../core/di/init_dependencies.dart';
import '../../core/network/connection_checker.dart';
import 'data/datasources/testing_remote_data_source.dart';
import 'data/repositories/testing_repository_impl.dart';
import 'domain/repositories/testing_repository.dart';
import 'domain/usecase/testing_usecase.dart';


import 'presentation/controllers/testing_controller.dart';


class TestingInjector {
  /// Initialize Testing feature dependencies
  static Future<void> init() async {

    // Remote Data Source
    sl.registerLazySingleton<TestingRemoteDataSource>(
      () => TestingRemoteSourceImpl(
        apiClient: sl(), // Make sure ApiClient is already registered
      ),
    );

    // Repository
    sl.registerLazySingleton<TestingRepository>(
      () => TestingRepositoryImpl(
        remoteSource: sl<TestingRemoteDataSource>(),
        connectionChecker: sl<ConnectionChecker>(),
      ),
    );

    // UseCase
    sl.registerLazySingleton(
      () => TestingUseCase(
        testingRepository: sl<TestingRepository>(),
      ),
    );

    

    
    // GetX-controller
    Get.lazyPut<TestingController>(
      () => TestingController(testingUseCase: sl<TestingUseCase>()),
    );
    
  }
}
