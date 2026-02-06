class Assignment {
  final String id;
  String title;
  String course;
  DateTime dueDate;
  String priority; // High / Medium / Low
  bool isCompleted;

  Assignment({
    required this.id,
    required this.title,
    required this.course,
    required this.dueDate,
    this.priority = 'Medium',
    this.isCompleted = false,
  });

  /// Convert Assignment → JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'course': course,
        'dueDate': dueDate.toIso8601String(),
        'priority': priority,
        'isCompleted': isCompleted,
      };

  /// Convert JSON → Assignment
  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'],
      title: json['title'],
      course: json['course'],
      dueDate: DateTime.parse(json['dueDate']),
      priority: json['priority'],
      isCompleted: json['isCompleted'],
    );
  }

  /// For UI display (e.g. "Due Oct 24")
  String get formattedDate =>
      "${dueDate.day}/${dueDate.month}/${dueDate.year}";
}
