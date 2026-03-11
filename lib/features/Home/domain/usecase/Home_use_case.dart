import 'dart:io';
import '../repositories/Home_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/employee_model.dart';

class HomeUseCase {
  final HomeRepository homeRepository;
  HomeUseCase({required this.homeRepository});

  /// Get employee profile
  Future<Either<Failure, EmployeeModel>> getEmployeeProfile(
      GetEmployeeParams params) async {
    return await homeRepository.getEmployeeProfile(params.userId);
  }

  /// Update employee profile
  Future<Either<Failure, EmployeeModel>> updateEmployeeProfile(
      UpdateEmployeeParams params) async {
    return await homeRepository.updateEmployeeProfile(params.userId, params.body);
  }

  /// Upload image
  Future<Either<Failure, ImageUploadData>> uploadImage(File file) {
    return homeRepository!.uploadImage(file);
  }
}

class GetEmployeeParams {
  final String userId;

  GetEmployeeParams({required this.userId});
}

class UpdateEmployeeParams {
  final String userId;
  final Map<String, dynamic> body;

  UpdateEmployeeParams({required this.userId, required this.body});
}