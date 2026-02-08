import 'package:flutter/material.dart';
import 'schedule_model.dart';

class ScheduleStore {
  ScheduleStore._();
  static final ScheduleStore instance = ScheduleStore._();

  final List<ScheduledSession> _sessions = [];
  bool _seeded = false;

  List<ScheduledSession> getAll() => List.unmodifiable(_sessions);

  void add(ScheduledSession session) {
    _sessions.add(session);
    // Sort by day and then start time
    _sessions.sort((a, b) {
      if (a.dayOfWeek != b.dayOfWeek) {
        return a.dayOfWeek.compareTo(b.dayOfWeek);
      }
      final aMinutes = a.startTime.hour * 60 + a.startTime.minute;
      final bMinutes = b.startTime.hour * 60 + b.startTime.minute;
      return aMinutes.compareTo(bMinutes);
    });
  }

  void seedIfEmpty() {
    if (_seeded || _sessions.isNotEmpty) return;
    _seeded = true;

    // Seed data covers Monday to Friday
    // Monday (1)
    add(ScheduledSession(id: 's1', subject: 'Mathematics', startTime: const TimeOfDay(hour: 9, minute: 0), endTime: const TimeOfDay(hour: 10, minute: 30), room: '101', dayOfWeek: 1));
    add(ScheduledSession(id: 's2', subject: 'Physics', startTime: const TimeOfDay(hour: 11, minute: 0), endTime: const TimeOfDay(hour: 12, minute: 30), room: 'Lab A', dayOfWeek: 1));
    
    // Tuesday (2)
    add(ScheduledSession(id: 's3', subject: 'Computer Science', startTime: const TimeOfDay(hour: 9, minute: 0), endTime: const TimeOfDay(hour: 11, minute: 0), room: '204', dayOfWeek: 2));
    
    // Wednesday (3)
    add(ScheduledSession(id: 's4', subject: 'History', startTime: const TimeOfDay(hour: 10, minute: 0), endTime: const TimeOfDay(hour: 11, minute: 30), room: '105', dayOfWeek: 3));
    add(ScheduledSession(id: 's5', subject: 'Mathematics', startTime: const TimeOfDay(hour: 13, minute: 0), endTime: const TimeOfDay(hour: 14, minute: 30), room: '101', dayOfWeek: 3));

    // Thursday (4)
    add(ScheduledSession(id: 's6', subject: 'Physics', startTime: const TimeOfDay(hour: 9, minute: 0), endTime: const TimeOfDay(hour: 10, minute: 30), room: '102', dayOfWeek: 4));

    // Friday (5)
    add(ScheduledSession(id: 's7', subject: 'Computer Science', startTime: const TimeOfDay(hour: 10, minute: 0), endTime: const TimeOfDay(hour: 12, minute: 0), room: '204', dayOfWeek: 5));
    
    // Also add sessions for "Today" regardless of the actual day of week, for demo purposes if today is Sat/Sun
    // Or just rely on the user running this on a weekday. 
    // Ideally, for a demo, we might want to ensure "Today" always has something.
    // However, I will stick to static days. If today is Sunday (7), it will show empty, which is correct.
    // If the user wants to see data, I can add a hack or just ensure the seed covers current day.
    // Let's just trust the static schedule for now.
  }

  List<ScheduledSession> getSessionsForDay(int dayOfWeek) {
    return _sessions.where((s) => s.dayOfWeek == dayOfWeek).toList();
  }
}
