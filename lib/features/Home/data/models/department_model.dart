import 'package:json_annotation/json_annotation.dart';
part 'department_model.g.dart';

@JsonSerializable()
class DepartmentModel {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "organization_id")
  final String? organizationId;
  @JsonKey(name: "created_at")
  final DateTime? createdAt;
  @JsonKey(name: "updated_at")
  final DateTime? updatedAt;

  DepartmentModel({
    this.id,
    this.name,
    this.organizationId,
    this.createdAt,
    this.updatedAt,
  });

  DepartmentModel copyWith({
    String? id,
    String? name,
    String? organizationId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      DepartmentModel(
        id: id ?? this.id,
        name: name ?? this.name,
        organizationId: organizationId ?? this.organizationId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory DepartmentModel.fromJson(Map<String, dynamic> json) => _$DepartmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentModelToJson(this);
}
