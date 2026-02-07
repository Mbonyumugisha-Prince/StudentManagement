import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/authentication/login.dart';

void main() {
  runApp(const StudentAcademicApp());
}

class StudentAcademicApp extends StatelessWidget {
  const StudentAcademicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Student Academic Platform',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
