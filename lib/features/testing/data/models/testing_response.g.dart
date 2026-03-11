// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'testing_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestingResponse _$TestingResponseFromJson(
        Map<String, dynamic> json) =>
    TestingResponse(
      message: json['message'] as String?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      isSuccess: json['is_success'] as bool?,
      data: json['data']
    );

Map<String, dynamic> _$TestingResponseToJson(
        TestingResponse instance) =>
    <String, dynamic>{
      'issuccess': instance.isSuccess,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };
