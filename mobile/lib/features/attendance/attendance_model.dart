class AttendanceRecord {
  final String id;
  final DateTime date;
  final String subject;
  final bool isPresent;

  AttendanceRecord({
    required this.id,
    required this.date,
    required this.subject,
    required this.isPresent,
  });

  String get formattedDate => '${date.day}/${date.month}/${date.year}';
}
