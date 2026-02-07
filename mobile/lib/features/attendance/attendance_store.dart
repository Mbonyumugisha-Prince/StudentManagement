import 'attendance_model.dart';

class AttendanceStore {
  AttendanceStore._();
  static final AttendanceStore instance = AttendanceStore._();

  final List<AttendanceRecord> _records = [];
  bool _seeded = false;

  List<AttendanceRecord> getAll() => List.unmodifiable(_records);

  void add(AttendanceRecord record) {
    _records.add(record);
    _records.sort((a, b) => b.date.compareTo(a.date));
  }

  void seedIfEmpty() {
    if (_seeded || _records.isNotEmpty) return;
    _seeded = true;
    add(AttendanceRecord(
      id: 'seed-1',
      date: DateTime.now().subtract(const Duration(days: 1)),
      subject: 'Mathematics',
      isPresent: true,
    ));
    add(AttendanceRecord(
      id: 'seed-2',
      date: DateTime.now().subtract(const Duration(days: 2)),
      subject: 'Physics',
      isPresent: false,
    ));
    add(AttendanceRecord(
      id: 'seed-3',
      date: DateTime.now().subtract(const Duration(days: 3)),
      subject: 'Computer Science',
      isPresent: true,
    ));
    add(AttendanceRecord(
      id: 'seed-4',
      date: DateTime.now().subtract(const Duration(days: 4)),
      subject: 'Entrepreneurship',
      isPresent: true,
    ));
    add(AttendanceRecord(
      id: 'seed-5',
      date: DateTime.now().subtract(const Duration(days: 5)),
      subject: 'Data Science',
      isPresent: false,
    ));
  }

  int get totalClasses => _records.length;

  int get presentClasses => _records.where((r) => r.isPresent).length;

  int get absentClasses => totalClasses - presentClasses;

  double get percentage {
    if (totalClasses == 0) return 0;
    return (presentClasses / totalClasses) * 100;
  }

  bool get isBelowThreshold => percentage < 75;
}
