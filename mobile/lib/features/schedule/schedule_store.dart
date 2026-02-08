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
    _sort();
  }

  void update(ScheduledSession session) {
    final index = _sessions.indexWhere((s) => s.id == session.id);
    if (index == -1) return;
    _sessions[index] = session;
    _sort();
  }

  void remove(String id) {
    _sessions.removeWhere((s) => s.id == id);
  }

  void _sort() {
    _sessions.sort((a, b) {
      if (a.date != b.date) {
        return a.date.compareTo(b.date);
      }
      final aMinutes = a.startTime.hour * 60 + a.startTime.minute;
      final bMinutes = b.startTime.hour * 60 + b.startTime.minute;
      return aMinutes.compareTo(bMinutes);
    });
  }

  void seedIfEmpty() {
    if (_seeded || _sessions.isNotEmpty) return;
    _seeded = true;

    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    DateTime d(int offset) => monday.add(Duration(days: offset));

    add(ScheduledSession(
      id: 's1',
      title: 'Mathematics',
      date: d(0),
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 10, minute: 30),
      location: 'Room 101',
      sessionType: 'Class',
      dayOfWeek: 1,
      isPresent: true,
    ));
    add(ScheduledSession(
      id: 's2',
      title: 'Physics',
      date: d(0),
      startTime: const TimeOfDay(hour: 11, minute: 0),
      endTime: const TimeOfDay(hour: 12, minute: 30),
      location: 'Lab A',
      sessionType: 'Class',
      dayOfWeek: 1,
      isPresent: false,
    ));
    add(ScheduledSession(
      id: 's3',
      title: 'Computer Science',
      date: d(1),
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 11, minute: 0),
      location: 'Room 204',
      sessionType: 'Study Group',
      dayOfWeek: 2,
      isPresent: true,
    ));
    add(ScheduledSession(
      id: 's4',
      title: 'History',
      date: d(2),
      startTime: const TimeOfDay(hour: 10, minute: 0),
      endTime: const TimeOfDay(hour: 11, minute: 30),
      location: 'Room 105',
      sessionType: 'Class',
      dayOfWeek: 3,
      isPresent: true,
    ));
    add(ScheduledSession(
      id: 's5',
      title: 'Math Mastery',
      date: d(2),
      startTime: const TimeOfDay(hour: 13, minute: 0),
      endTime: const TimeOfDay(hour: 14, minute: 30),
      location: 'Room 101',
      sessionType: 'Mastery Session',
      dayOfWeek: 3,
      isPresent: true,
    ));
    add(ScheduledSession(
      id: 's6',
      title: 'Physics PSL',
      date: d(3),
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 10, minute: 30),
      location: 'Room 102',
      sessionType: 'PSL Meeting',
      dayOfWeek: 4,
      isPresent: false,
    ));
    add(ScheduledSession(
      id: 's7',
      title: 'AI Study Group',
      date: d(4),
      startTime: const TimeOfDay(hour: 10, minute: 0),
      endTime: const TimeOfDay(hour: 12, minute: 0),
      location: 'Room 204',
      sessionType: 'Study Group',
      dayOfWeek: 5,
      isPresent: true,
    ));
  }

  List<ScheduledSession> getSessionsForDay(int dayOfWeek) {
    return _sessions.where((s) => s.dayOfWeek == dayOfWeek).toList();
  }
}
