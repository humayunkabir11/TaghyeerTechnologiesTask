import 'package:json_annotation/json_annotation.dart';
part 'meta.g.dart';

@JsonSerializable()
class Meta {
  @JsonKey(name: "total")
  final int? total;
  @JsonKey(name: "page")
  final int? page;
  @JsonKey(name: "pageSize")
  final int? pageSize;
  @JsonKey(name: "totalPages")
  final int? totalPages;

  Meta({
    this.total,
    this.page,
    this.pageSize,
    this.totalPages,
  });

  Meta copyWith({
    int? total,
    int? page,
    int? pageSize,
    int? totalPages,
  }) =>
      Meta(
        total: total ?? this.total,
        page: page ?? this.page,
        pageSize: pageSize ?? this.pageSize,
        totalPages: totalPages ?? this.totalPages,
      );

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
