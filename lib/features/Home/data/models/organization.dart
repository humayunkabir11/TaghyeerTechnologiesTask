import 'package:json_annotation/json_annotation.dart';
part 'organization.g.dart';

@JsonSerializable()
class Organization {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "createdAt")
  final DateTime? createdAt;

  Organization({
    this.id,
    this.createdAt,
  });

  Organization copyWith({
    String? id,
    DateTime? createdAt,
  }) =>
      Organization(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Organization.fromJson(Map<String, dynamic> json) => _$OrganizationFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizationToJson(this);
}
