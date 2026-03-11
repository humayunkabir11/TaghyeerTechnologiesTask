import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hrx/core/extentions/custom_extentions.dart';
import 'package:hrx/features/Attandencee/data/models/today_attendance_response_model.dart';

import '../../../../core/custom_assets/assets.gen.dart';
import '../../../Main/data/models/shift/assignment.dart';
import 'summary_tile.dart';

class AttendanceSummary extends StatelessWidget {
  final Assignment? assignment;
  final TodayAttendanceResponseModelData? todayAttendance;

  const AttendanceSummary({super.key, this.assignment, this.todayAttendance});

  // ================= HELPERS =================

  Duration _diff(DateTime? start, DateTime? end) {
    if (start == null || end == null) return Duration.zero;
    if (end.isBefore(start)) return Duration.zero;
    return end.difference(start);
  }

  String _formatHours(Duration d) {
    final hours = d.inMinutes / 60;
    return "${hours.toStringAsFixed(1)}h";
  }

  String _formatOvertime(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    return "${h}h ${m}m";
  }

  int _parseOvertime(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  DateTime? _combineDateWithTime(DateTime? date, String? time) {
    if (date == null || time == null) return null;
    final parts = time.split(":");
    if (parts.length < 2) return null;

    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkIn = todayAttendance?.data?.checkInTime;
    final checkOutVal = todayAttendance?.data?.checkOutTime;
    final DateTime? checkOut = checkOutVal;
    final now = DateTime.now();

    // Shift end datetime
    final shiftEnd = _combineDateWithTime(checkIn, assignment?.endTime);

    // ---------------- SHIFT PROGRESS ----------------
    // Calculate actual work duration (excluding breaks)
    Duration actualWorkDuration = Duration.zero;

    if (checkIn != null) {
      final breaks = todayAttendance?.data?.attendanceBreaks ?? [];

      if (breaks.isEmpty) {
        // No breaks yet, work duration = checkIn to now
        actualWorkDuration = _diff(checkIn, checkOut ?? now);
      } else {
        // Calculate work time segments
        DateTime? lastWorkEnd = checkIn;

        for (final breakEntry in breaks) {
          if (breakEntry.breakStart != null) {
            // Add work time before this break
            actualWorkDuration += _diff(lastWorkEnd, breakEntry.breakStart);

            // Update last work end time
            // breakEnd is dynamic, needs explicit casting
            if (breakEntry.breakEnd != null) {
              final breakEndTime = breakEntry.breakEnd is DateTime
                  ? breakEntry.breakEnd as DateTime
                  : breakEntry.breakEnd is String
                  ? DateTime.tryParse(breakEntry.breakEnd as String)
                  : null;

              if (breakEndTime != null) {
                lastWorkEnd = breakEndTime;
              } else {
                // Break end couldn't be parsed, treat as ongoing
                lastWorkEnd = breakEntry.breakStart;
              }
            } else {
              // Break is ongoing, so work stopped at break start
              lastWorkEnd = breakEntry.breakStart;
            }
          }
        }

        // Add work time after last break (if break ended or no active break)
        final lastBreak = breaks.lastOrNull;
        if (lastBreak?.breakEnd != null) {
          // Last break has ended, add work time from break end to now/checkout
          final lastBreakEndTime = lastBreak?.breakEnd is DateTime
              ? lastBreak?.breakEnd as DateTime
              : lastBreak?.breakEnd is String
              ? DateTime.tryParse(lastBreak?.breakEnd as String)
              : null;

          if (lastBreakEndTime != null) {
            actualWorkDuration += _diff(lastBreakEndTime, checkOut ?? now);
          }
        }
        // If last break is ongoing (breakEnd is null), we already stopped counting
      }
    }

    // Calculate total expected shift duration
    final shiftStart = _combineDateWithTime(checkIn, assignment?.startTime);
    final totalDuration = _diff(shiftStart, shiftEnd);

    // Calculate progress percentage based on actual work vs expected shift duration
    final progressPercent = totalDuration.inSeconds == 0
        ? 0
        : ((actualWorkDuration.inSeconds / totalDuration.inSeconds) * 100)
              .clamp(0, 100)
              .round();

    // ---------------- OVERTIME ----------------
    final endTime = checkOut ?? now;
    final isOvertime = shiftEnd != null && endTime.isAfter(shiftEnd);
    final overtimeDuration = isOvertime
        ? _diff(shiftEnd, endTime)
        : Duration.zero;

    // ---------------- UI ----------------
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 12,
          children: [
            /// Checked In
            Expanded(
              child: SummaryTile(
                label:
                    todayAttendance?.hrxData?.checkInStatus?.capitalize?.replaceAll("_",  " ") ??
                    "-",
                title: "Checked In",
                subtitle: checkIn?.toAmPm ?? "-",
                icon: Assets.icons.icPersonCheck.svg(),
                circleColor: const Color(0xFF03BCA5),
              ),
            ),

            /// Shift Schedule
            Expanded(
              child: SummaryTile(
                label: assignment?.shift?.name ?? "-",
                title: "Shift Schedule",
                subtitle:
                    "${assignment?.startTime?.toAmPm ?? "-"} - ${assignment?.endTime?.toAmPm ?? "-"}",
                icon: Assets.icons.icClock.svg(),
                circleColor: const Color(0xFF00BCE4),
              ),
            ),
          ],
        ),
        const Gap(12),
        Row(
          spacing: 12,
          children: [
            /// Shift Progress
            Expanded(
              child: SummaryTile(
                label: "$progressPercent%",
                title: "Shift Progress",
                subtitle:
                    "${_formatHours(actualWorkDuration)} / ${_formatHours(totalDuration)} completed"
                        .toUpperCase(),
                icon: Assets.icons.icCalendarSchedule.svg(),
                circleColor: const Color(0xFF5001ED),
              ),
            ),

            /// Overtime
            Expanded(
              child: SummaryTile(
                label: isOvertime
                    ? _formatHours(Duration(minutes: _parseOvertime(todayAttendance?.hrxData?.overtimeInMinutes)))
                    : "No Overtime",
                title: "Overtime",
                subtitle: isOvertime
                    ? "Overtime Worked".toUpperCase()
                    : "No Overtime".toUpperCase(),
                icon: Assets.icons.icTimer.svg(),
                circleColor: isOvertime
                    ? const Color(0xFFED3A3A)
                    : const Color(0xFFEDAA00),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
