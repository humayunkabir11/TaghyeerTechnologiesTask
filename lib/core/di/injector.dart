part of 'init_dependencies.dart';

Future<void> _initCoreDependencies() async {
  /// Internet connection check service
  sl.registerLazySingleton(() => InternetConnection());

  /// Connectivity checking abstraction
  sl.registerLazySingleton<ConnectionChecker>(
    () => ConnectionCheckerImpl(sl()),
  );

  /// Centralized API Client with auth handling and logout callback
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      baseUrl: ApiEndpoint.baseUrl,
      onLogout: () async {
        final hiveService = Get.find<HiveService>();
        await hiveService.clearUser();
        Get.offAllNamed('/');
      },
      getToken: () async {
        final hiveService = Get.find<HiveService>();
        return hiveService.getUser()?.accessToken;
      },
    ),
  );
}
