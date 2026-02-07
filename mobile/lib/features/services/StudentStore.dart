import 'dart:convert';
import '../models/student_data.dart';

class Studentstore {
  Studentstore._();
  static final Studentstore instance = Studentstore._();

  final List<Student> _students = [];
  void save(Student student) {
    _students.add(student);
  }
  
  String toJson() {
     final list = _students.map((s) => s.toMap()).toList();
     return jsonEncode({'students': list});
  }

  List<Student> getAll() => _students;
}