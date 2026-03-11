// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentModel _$DepartmentModelFromJson(Map<String, dynamic> json) =>
    DepartmentModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      organizationId: json['organization_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$DepartmentModelToJson(DepartmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'organization_id': instance.organizationId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
