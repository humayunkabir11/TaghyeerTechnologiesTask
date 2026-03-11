import 'package:json_annotation/json_annotation.dart';
part 'testing_response.g.dart';


@JsonSerializable()
class TestingResponse {
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'status_code')
  final int? statusCode;
  @JsonKey(name: 'is_success')
  final bool? isSuccess;
  @JsonKey(name: 'data')
  final dynamic data;

  TestingResponse({
    this.message,
    this.statusCode,
    this.isSuccess,
    this.data,
  });

  factory TestingResponse.fromJson(Map<String, dynamic> json) =>
      _$TestingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TestingResponseToJson(this);
}
