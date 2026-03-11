// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_leave_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApprovalLeaveList _$ApprovalLeaveListFromJson(Map<String, dynamic> json) =>
    ApprovalLeaveList(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => LeaveData.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApprovalLeaveListToJson(ApprovalLeaveList instance) =>
    <String, dynamic>{'data': instance.data, 'meta': instance.meta};
