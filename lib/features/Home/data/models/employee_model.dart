import 'package:hrx/features/Home/data/models/manager.dart';
import 'package:hrx/features/Home/data/models/manager.dart';
import 'package:json_annotation/json_annotation.dart';
import 'department_model.dart';
import 'organization.dart';

part 'employee_model.g.dart';


@JsonSerializable()
class EmployeeModel {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "user_id")
  final String? userId;
  @JsonKey(name: "tenant_id")
  final String? tenantId;
  @JsonKey(name: "organization_id")
  final String? organizationId;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "role")
  final String? role;
  @JsonKey(name: "photo")
  final String? photo;
  @JsonKey(name: "manager_id")
  final String? managerId;
  @JsonKey(name: "phone")
  final String? phone;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "house_address")
  final dynamic houseAddress;
  @JsonKey(name: "department_id")
  final String? departmentId;
  @JsonKey(name: "designation_id")
  final String? designationId;
  @JsonKey(name: "employee_id")
  final String? employeeId;
  @JsonKey(name: "salary")
  final int? salary;
  @JsonKey(name: "joining_date")
  final DateTime? joiningDate;
  @JsonKey(name: "emergency_contacts")
  final List<dynamic>? emergencyContacts;
  @JsonKey(name: "date_of_birth")
  final dynamic dateOfBirth;
  @JsonKey(name: "nid")
  final dynamic nid;
  @JsonKey(name: "blood_group")
  final dynamic bloodGroup;
  @JsonKey(name: "employee_type")
  final String? employeeType;
  @JsonKey(name: "educations")
  final dynamic educations;
  @JsonKey(name: "skills")
  final dynamic skills;
  @JsonKey(name: "certifications")
  final dynamic certifications;
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "office_id")
  final String? officeId;
  @JsonKey(name: "is_geo_enable")
  final bool? isGeoEnable;
  @JsonKey(name: "latitude")
  final dynamic latitude;
  @JsonKey(name: "longitude")
  final dynamic longitude;
  @JsonKey(name: "radius")
  final num? radius;
  @JsonKey(name: "outside_fence_action")
  final String? outsideFenceAction;
  @JsonKey(name: "fence_attendance_permission")
  final String? fenceAttendancePermission;
  @JsonKey(name: "created_at")
  final DateTime? createdAt;
  @JsonKey(name: "updated_at")
  final DateTime? updatedAt;
  @JsonKey(name: "department")
  final DepartmentModel? department;
  @JsonKey(name: "office")
  final DepartmentModel? office;
  @JsonKey(name: "designation")
  final DepartmentModel? designation;
  @JsonKey(name: "organization")
  final Organization? organization;
  @JsonKey(name: "manager")
  final Manager? manager;
  @JsonKey(name: "subordinates")
  final List<Manager>? subordinates;

  EmployeeModel({
    this.id,
    this.userId,
    this.tenantId,
    this.organizationId,
    this.name,
    this.role,
    this.photo,
    this.managerId,
    this.phone,
    this.email,
    this.houseAddress,
    this.departmentId,
    this.designationId,
    this.employeeId,
    this.salary,
    this.joiningDate,
    this.emergencyContacts,
    this.dateOfBirth,
    this.nid,
    this.bloodGroup,
    this.employeeType,
    this.educations,
    this.skills,
    this.certifications,
    this.status,
    this.officeId,
    this.isGeoEnable,
    this.latitude,
    this.longitude,
    this.radius,
    this.outsideFenceAction,
    this.fenceAttendancePermission,
    this.createdAt,
    this.updatedAt,
    this.department,
    this.office,
    this.designation,
    this.organization,
    this.manager,
    this.subordinates,
  });

  EmployeeModel copyWith({
    String? id,
    String? userId,
    String? tenantId,
    String? organizationId,
    String? name,
    String? role,
    dynamic photo,
    String? managerId,
    String? phone,
    String? email,
    dynamic houseAddress,
    String? departmentId,
    String? designationId,
    String? employeeId,
    int? salary,
    DateTime? joiningDate,
    List<dynamic>? emergencyContacts,
    dynamic dateOfBirth,
    dynamic nid,
    dynamic bloodGroup,
    String? employeeType,
    dynamic educations,
    dynamic skills,
    dynamic certifications,
    String? status,
    String? officeId,
    bool? isGeoEnable,
    dynamic latitude,
    dynamic longitude,
    int? radius,
    String? outsideFenceAction,
    String? fenceAttendancePermission,
    DateTime? createdAt,
    DateTime? updatedAt,
    DepartmentModel? department,
    DepartmentModel? office,
    DepartmentModel? designation,
    Organization? organization,
    Manager? manager,
    List<Manager>? subordinates,
  }) =>
      EmployeeModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        tenantId: tenantId ?? this.tenantId,
        organizationId: organizationId ?? this.organizationId,
        name: name ?? this.name,
        role: role ?? this.role,
        photo: photo ?? this.photo,
        managerId: managerId ?? this.managerId,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        houseAddress: houseAddress ?? this.houseAddress,
        departmentId: departmentId ?? this.departmentId,
        designationId: designationId ?? this.designationId,
        employeeId: employeeId ?? this.employeeId,
        salary: salary ?? this.salary,
        joiningDate: joiningDate ?? this.joiningDate,
        emergencyContacts: emergencyContacts ?? this.emergencyContacts,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        nid: nid ?? this.nid,
        bloodGroup: bloodGroup ?? this.bloodGroup,
        employeeType: employeeType ?? this.employeeType,
        educations: educations ?? this.educations,
        skills: skills ?? this.skills,
        certifications: certifications ?? this.certifications,
        status: status ?? this.status,
        officeId: officeId ?? this.officeId,
        isGeoEnable: isGeoEnable ?? this.isGeoEnable,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        radius: radius ?? this.radius,
        outsideFenceAction: outsideFenceAction ?? this.outsideFenceAction,
        fenceAttendancePermission: fenceAttendancePermission ?? this.fenceAttendancePermission,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        department: department ?? this.department,
        office : office ?? this.office,
        designation: designation ?? this.designation,
        organization: organization ?? this.organization,
        manager: manager ?? this.manager,
        subordinates: subordinates ?? this.subordinates,
      );

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => _$EmployeeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);
}
