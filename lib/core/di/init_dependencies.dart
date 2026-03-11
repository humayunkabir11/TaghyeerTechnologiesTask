import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../config/strings/api_endpoint.dart';
import '../network/api_client.dart';
import '../network/connection_checker.dart';
import '../services/hive_service.dart';

part 'injector.dart';

final sl = GetIt.instance;

// Dependency injection initialization
Future<void> initDependencies() async {
  // 1. Initialize Hive Service as a GetxService and ensure it's ready
  await Get.putAsync(() => HiveService().init());
  
  // 2. Initialize Core Dependencies (Dio, Connection Checker, etc.)
  await _initCoreDependencies();
}