import 'dart:io';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../Leave/data/models/image_upload_model.dart';
import '../../data/models/employee_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, EmployeeModel>> getEmployeeProfile(String userId);
  Future<Either<Failure, EmployeeModel>> updateEmployeeProfile(String userId, Map<String, dynamic> body);
  Future<Either<Failure, ImageUploadData>> uploadImage(File file) ;
}
