import 'package:flutter/material.dart';
import '../attendance/attendance_store.dart';
import '../widgets/backgroundWithPattern.dart';
import '../../core/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  final String fullName;
  final String email;

  const ProfilePage({
    super.key,
    required this.fullName,
    required this.email,
  });

  String get _initials {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.primaryDark;
    final card = AppColors.background;
    final attendance = AttendanceStore.instance;
    attendance.seedIfEmpty();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: AppColors.primaryWhite,
        elevation: 0,
        title: const Text('Profile'),
      ),
      body: BackgroundWithPattern(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final minBodyHeight =
                (constraints.maxHeight - 160).clamp(0, double.infinity)
                    as double;
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: AppColors.primaryWhite,
                      child: Text(
                        _initials,
                        style: const TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      fullName.isEmpty ? 'User' : fullName,
                      style: const TextStyle(
                        color: AppColors.primaryWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: minBodyHeight),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: card,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(28),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Personal Info',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _infoRow('Full Name',
                                  fullName.isEmpty ? 'User' : fullName),
                              const SizedBox(height: 12),
                              _infoRow('Email', email.isEmpty ? '-' : email),
                              const SizedBox(height: 24),
                              const Text(
                                'Attendance Overview',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _statRow('Overall Attendance',
                                  '${attendance.percentage.toStringAsFixed(1)}%'),
                              const SizedBox(height: 8),
                              _statRow('Present',
                                  '${attendance.presentClasses}'),
                              const SizedBox(height: 8),
                              _statRow('Absent', '${attendance.absentClasses}'),
                              const SizedBox(height: 24),
                              const Text(
                                'Assignment Grades',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _gradeItem('Building Flutter App', 'A'),
                              const SizedBox(height: 10),
                              _gradeItem('Training Model', 'B+'),
                              const SizedBox(height: 10),
                              _gradeItem('Entrepreneurial Leadership', 'A-'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.black54),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _gradeItem(String title, String grade) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryDark.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              grade,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
