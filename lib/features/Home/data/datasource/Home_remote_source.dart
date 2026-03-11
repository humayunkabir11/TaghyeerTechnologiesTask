import 'dart:io';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoint.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/models/api_response.dart';
import '../../../Leave/data/models/image_upload_model.dart';
import '../models/employee_response.dart';

abstract class HomeRemoteSource {
  Future<ApiResponse<EmployeeResponseData>> getEmployeeProfile(String userId);
  Future<ApiResponse<EmployeeResponseData>> updateEmployeeProfile(String userId, Map<String, dynamic> body);
}

class HomeRemoteSourceImpl implements HomeRemoteSource {
  final ApiClient apiMethod;
  HomeRemoteSourceImpl({required this.apiMethod});

  @override
  Future<ApiResponse<EmployeeResponseData>> getEmployeeProfile(
    String userId,
  ) async {
    try {
      final response = await apiMethod.get(
        api: ApiEndpoint.getEmployeeProfile(userId),
      );

      return ApiResponse<EmployeeResponseData>.fromJson(
        response.data,
        (data) => EmployeeResponseData.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      print(e.toString());
      return ApiResponse<EmployeeResponseData>(
        success: false,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<EmployeeResponseData>> updateEmployeeProfile(
    String userId,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await apiMethod.patch(
        api: ApiEndpoint.updateEmployeeProfile(userId),
        data: body,
      );

      return ApiResponse<EmployeeResponseData>.fromJson(
        response.data,
        (data) => EmployeeResponseData.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      print(e.toString());
      return ApiResponse<EmployeeResponseData>(
        success: false,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ImageUploadData> uploadImage(File file) async {
    try {
      final response = await apiMethod.uploadFile(
        api: ApiEndpoint.imageUpload,
        file: file,
        field: "photo",
      );

      if (response.data == null) {
        throw ServerException('No response from server');
      }

      return ImageUploadData.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
