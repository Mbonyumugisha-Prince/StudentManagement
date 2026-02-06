import 'package:flutter/material.dart';
import 'features/assignments/assignment_page.dart';

void main() {
  runApp(const StudentAcademicApp());
}

class StudentAcademicApp extends StatelessWidget {
  const StudentAcademicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Academic Platform',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const AssignmentsPage(),
    );
  }
}
