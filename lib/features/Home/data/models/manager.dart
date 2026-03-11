import 'package:hrx/features/Home/data/models/department_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'manager.g.dart';

@JsonSerializable()
class Manager {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "employee_id")
  final String? employeeId;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "designation")
  final DepartmentModel? designation;

  Manager({
    this.id,
    this.name,
    this.employeeId,
    this.email,
    this.designation,
  });

  Manager copyWith({
    String? id,
    String? name,
    String? employeeId,
    String? email,
    DepartmentModel? designation,
  }) =>
      Manager(
        id: id ?? this.id,
        name: name ?? this.name,
        employeeId: employeeId ?? this.employeeId,
        email: email ?? this.email,
        designation: designation ?? this.designation,
      );

  factory Manager.fromJson(Map<String, dynamic> json) => _$ManagerFromJson(json);

  Map<String, dynamic> toJson() => _$ManagerToJson(this);
}