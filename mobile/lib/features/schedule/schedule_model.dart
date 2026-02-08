import 'package:flutter/material.dart';

class ScheduledSession {
  final String id;
  final String title;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String location;
  final String sessionType; // Class, Mastery Session, Study Group, PSL Meeting
  final int dayOfWeek; // 1 = Monday, ..., 7 = Sunday
  bool isPresent;

  ScheduledSession({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.sessionType,
    required this.dayOfWeek,
    this.isPresent = true,
  });

  String get timeRange =>
      "${_formatTime(startTime)} - ${_formatTime(endTime)}";

  String get formattedDate =>
      "${date.day}/${date.month}/${date.year}";

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute $period";
  }
}
