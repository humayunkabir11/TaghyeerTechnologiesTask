import '../../../../core/network/models/api_response.dart';
import 'employee_model.dart';

class EmployeeResponseData {
  final String? message;
  final EmployeeModel? data;

  EmployeeResponseData({
    this.message,
    this.data,
  });

  factory EmployeeResponseData.fromJson(Map<String, dynamic> json) {
    return EmployeeResponseData(
      message: json['message'] as String?,
      data: json['data'] != null
          ? EmployeeModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.toJson(),
    };
  }
}

typedef EmployeeResponse = ApiResponse<EmployeeResponseData>;
