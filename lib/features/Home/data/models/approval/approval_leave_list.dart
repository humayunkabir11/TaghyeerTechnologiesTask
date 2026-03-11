import 'package:json_annotation/json_annotation.dart';
import '../../../../Leave/data/models/leave_data.dart';
import 'meta.dart';

part 'approval_leave_list.g.dart';


@JsonSerializable()
class ApprovalLeaveList {
  @JsonKey(name: "data")
  final List<LeaveData>? data;
  @JsonKey(name: "meta")
  final Meta? meta;

  ApprovalLeaveList({
    this.data,
    this.meta,
  });

  ApprovalLeaveList copyWith({
    List<LeaveData>? data,
    Meta? meta,
  }) =>
      ApprovalLeaveList(
        data: data ?? this.data,
        meta: meta ?? this.meta,
      );

  factory ApprovalLeaveList.fromJson(Map<String, dynamic> json) => _$ApprovalLeaveListFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalLeaveListToJson(this);
}