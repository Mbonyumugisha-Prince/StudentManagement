// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/main.dart';

void main() {
  testWidgets('Student Academic App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StudentAcademicApp());

    // Verify that the assignments page loads with expected elements.
    expect(find.text('Assignments'), findsOneWidget);
    expect(find.text('TASKS & DEADLINES'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('High Priority'), findsOneWidget);
    expect(find.text('This Week'), findsOneWidget);
    
    // Verify the floating action button is present.
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
