// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Manager _$ManagerFromJson(Map<String, dynamic> json) => Manager(
  id: json['id'] as String?,
  name: json['name'] as String?,
  employeeId: json['employee_id'] as String?,
  email: json['email'] as String?,
  designation: json['designation'] == null
      ? null
      : DepartmentModel.fromJson(json['designation'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ManagerToJson(Manager instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'employee_id': instance.employeeId,
  'email': instance.email,
  'designation': instance.designation,
};
