import 'dart:io';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/local_db_helper/local_bd_isar.dart';
import '../../../../core/network/connection_checker.dart';
import '../../../Leave/data/models/image_upload_model.dart';
import '../datasource/Home_remote_source.dart';
import '../models/employee_model.dart';
import '../../domain/repositories/Home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteSource remoteSource;
  final ConnectionChecker connectionChecker;

  HomeRepositoryImpl({
    required this.remoteSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, EmployeeModel>> getEmployeeProfile(
      String userId) async {
    try {
      // Check if cached data exists in Isar DB
      final cachedEmployee = await IsarDBHelper().getEmployeeData(userId);

      if (cachedEmployee != null) {
        // Return cached data immediately
        // Fetch from API in background and update if changed
        _refreshEmployeeInBackground(userId);
        return right(cachedEmployee);
      }

      // No cached data - check internet connection
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }

      // Fetch from API
      final response = await remoteSource.getEmployeeProfile(userId);

      if (response.success && response.data != null) {
        final employeeData = response.data!.data;
        
        // Save to local database
        await IsarDBHelper().saveEmployeeData(employeeData!);
        
        return right(employeeData!);
      } else {
        return left(Failure(response.message ?? "Failed to get employee profile"));
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// Background refresh - updates cached data silently
  Future<void> _refreshEmployeeInBackground(String userId) async {
    try {
      if (!await connectionChecker.isConnected) return;

      final response = await remoteSource.getEmployeeProfile(userId);

      if (response.success && response.data != null) {
        final newEmployeeData = response.data!.data;
        
        // Update local database
        await IsarDBHelper().saveEmployeeData(newEmployeeData!);
      }
    } catch (e) {
      // Silent fail - don't affect user experience
      // Could log this for debugging
    }
  }

  @override
  Future<Either<Failure, EmployeeModel>> updateEmployeeProfile(
    String userId,
    Map<String, dynamic> body,
  ) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }

      final response = await remoteSource.updateEmployeeProfile(userId, body);

      if (response.success && response.data != null) {
        final employeeData = response.data!.data;
        
        // Save to local database
        await IsarDBHelper().saveEmployeeData(employeeData!);
        
        return right(employeeData!);
      } else {
        return left(Failure(response.message ?? "Failed to update employee profile"));
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ImageUploadData>> uploadImage(File file) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure("no internet connection!!"));
      } else {
        final data = await remoteSource.uploadImage(file);
        if (data.status != "success") {
          return left(Failure("Something went wrong"));
        } else {
          return right(data);
        }
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}