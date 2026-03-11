// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeModel _$EmployeeModelFromJson(
  Map<String, dynamic> json,
) => EmployeeModel(
  id: json['id'] as String?,
  userId: json['user_id'] as String?,
  tenantId: json['tenant_id'] as String?,
  organizationId: json['organization_id'] as String?,
  name: json['name'] as String?,
  role: json['role'] as String?,
  photo: json['photo'] as String?,
  managerId: json['manager_id'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  houseAddress: json['house_address'],
  departmentId: json['department_id'] as String?,
  designationId: json['designation_id'] as String?,
  employeeId: json['employee_id'] as String?,
  salary: (json['salary'] as num?)?.toInt(),
  joiningDate: json['joining_date'] == null
      ? null
      : DateTime.parse(json['joining_date'] as String),
  emergencyContacts: json['emergency_contacts'] as List<dynamic>?,
  dateOfBirth: json['date_of_birth'],
  nid: json['nid'],
  bloodGroup: json['blood_group'],
  employeeType: json['employee_type'] as String?,
  educations: json['educations'],
  skills: json['skills'],
  certifications: json['certifications'],
  status: json['status'] as String?,
  officeId: json['office_id'] as String?,
  isGeoEnable: json['is_geo_enable'] as bool?,
  latitude: json['latitude'],
  longitude: json['longitude'],
  radius: json['radius'] as num?,
  outsideFenceAction: json['outside_fence_action'] as String?,
  fenceAttendancePermission: json['fence_attendance_permission'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  department: json['department'] == null
      ? null
      : DepartmentModel.fromJson(json['department'] as Map<String, dynamic>),
  office: json['office'] == null
      ? null
      : DepartmentModel.fromJson(json['office'] as Map<String, dynamic>),
  designation: json['designation'] == null
      ? null
      : DepartmentModel.fromJson(json['designation'] as Map<String, dynamic>),
  organization: json['organization'] == null
      ? null
      : Organization.fromJson(json['organization'] as Map<String, dynamic>),
  manager: json['manager'] == null
      ? null
      : Manager.fromJson(json['manager'] as Map<String, dynamic>),
  subordinates: (json['subordinates'] as List<dynamic>?)
      ?.map((e) => Manager.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$EmployeeModelToJson(EmployeeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'tenant_id': instance.tenantId,
      'organization_id': instance.organizationId,
      'name': instance.name,
      'role': instance.role,
      'photo': instance.photo,
      'manager_id': instance.managerId,
      'phone': instance.phone,
      'email': instance.email,
      'house_address': instance.houseAddress,
      'department_id': instance.departmentId,
      'designation_id': instance.designationId,
      'employee_id': instance.employeeId,
      'salary': instance.salary,
      'joining_date': instance.joiningDate?.toIso8601String(),
      'emergency_contacts': instance.emergencyContacts,
      'date_of_birth': instance.dateOfBirth,
      'nid': instance.nid,
      'blood_group': instance.bloodGroup,
      'employee_type': instance.employeeType,
      'educations': instance.educations,
      'skills': instance.skills,
      'certifications': instance.certifications,
      'status': instance.status,
      'office_id': instance.officeId,
      'is_geo_enable': instance.isGeoEnable,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radius': instance.radius,
      'outside_fence_action': instance.outsideFenceAction,
      'fence_attendance_permission': instance.fenceAttendancePermission,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'department': instance.department,
      'office': instance.office,
      'designation': instance.designation,
      'organization': instance.organization,
      'manager': instance.manager,
      'subordinates': instance.subordinates,
    };
