import 'package:flutter/material.dart';

class ScheduledSession {
  final String id;
  final String subject;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String room;
  final int dayOfWeek; // 1 = Monday, ..., 7 = Sunday

  ScheduledSession({
    required this.id,
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.dayOfWeek,
  });

  String get timeRange =>
      "${_formatTime(startTime)} - ${_formatTime(endTime)}";

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute $period";
  }
}
