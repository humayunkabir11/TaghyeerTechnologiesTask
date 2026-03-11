class SuccessResponse {
  final bool? success;
  final String? message;
  final dynamic data;

  SuccessResponse({
    this.success,
    this.message,
    this.data,
  });

  SuccessResponse copyWith({
    bool? success,
    String? message,
    dynamic data,
  }) =>
      SuccessResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory SuccessResponse.fromJson(Map<String, dynamic> json) => SuccessResponse(
    success: json['success'] as bool?,
    message: json['message'] as String?,
    data: json['data'],
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data,
  };
}