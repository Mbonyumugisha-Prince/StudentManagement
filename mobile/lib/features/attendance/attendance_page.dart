import 'package:flutter/material.dart';
import '../authentication/login.dart';
import '../assignments/assignment_page.dart';
import '../dashboard/dashboard_page.dart';
import 'attendance_store.dart';
import '../widgets/backgroundWithPattern.dart';
import '../widgets/headerText.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class AttendancePage extends StatefulWidget {
  final String displayName;
  final String firstName;
  final String lastName;
  final String email;

  const AttendancePage({
    super.key,
    this.displayName = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
  });

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  int selectedNavIndex = 1; // Attendance is index 1

  String get _displayName {
    final full = '${widget.firstName} ${widget.lastName}'.trim();
    if (full.isNotEmpty) return full;
    return widget.displayName.trim().isEmpty ? 'User' : widget.displayName;
  }

  String get _initials {
    final parts = _displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  void _onNavTap(int index) {
    if (index == selectedNavIndex) return;
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => DashboardPage(
            displayName: widget.displayName,
            firstName: widget.firstName,
            lastName: widget.lastName,
            email: widget.email,
          ),
        ),
      );
      return;
    }
    if (index == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => AssignmentsPage(
            displayName: widget.displayName,
            firstName: widget.firstName,
            lastName: widget.lastName,
            email: widget.email,
          ),
        ),
      );
      return;
    }
    // Handle index 3 (Scheduling) if implemented later
    setState(() => selectedNavIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final bg = Colors.black;
    final card = AppColors.background;
    final store = AttendanceStore.instance;

    return Scaffold(
      backgroundColor: bg,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: selectedNavIndex,
        onTap: _onNavTap,
      ),
      body: BackgroundWithPattern(
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.primaryDark,
                          child: Text(
                            _initials,
                            style: const TextStyle(
                              color: AppColors.primaryGold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: 'Logout',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: Colors.black,
                                title: const Text(
                                  'Confirm Logout',
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: const Text(
                                  'Are you sure you want to log out?',
                                  style: TextStyle(color: Colors.white),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white70,
                                    ),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) => const LoginScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryDark,
                                      foregroundColor: AppColors.primaryGold,
                                    ),
                                    child: const Text('Logout'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.logout, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const HeaderText(
                      title: 'Attendance',
                      subtitle: 'Track your presence',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primaryDark, Colors.black],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryDark.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Overall Attendance',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${store.percentage.toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: store.isBelowThreshold
                                    ? Colors.redAccent.withOpacity(0.2)
                                    : AppColors.primaryGold.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: store.isBelowThreshold
                                      ? Colors.redAccent
                                      : AppColors.primaryGold,
                                ),
                              ),
                              child: Text(
                                store.isBelowThreshold ? 'Warning' : 'Good',
                                style: TextStyle(
                                  color: store.isBelowThreshold
                                      ? Colors.redAccent
                                      : AppColors.primaryGold,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: store.getAll().isEmpty
                            ? const Center(
                                child: Text('No attendance records found.'),
                              )
                            : ListView.separated(
                                itemCount: store.getAll().length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (_, i) {
                                  final r = store.getAll()[i];
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: r.isPresent
                                                ? AppColors.success.withOpacity(0.1)
                                                : AppColors.error.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            r.isPresent
                                                ? Icons.check_circle_outline
                                                : Icons.cancel_outlined,
                                            color: r.isPresent
                                                ? AppColors.success
                                                : AppColors.error,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                r.subject,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                r.formattedDate,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: r.isPresent
                                                ? AppColors.success.withOpacity(0.1)
                                                : AppColors.error.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            r.isPresent ? 'Present' : 'Absent',
                                            style: TextStyle(
                                              color: r.isPresent
                                                  ? AppColors.success
                                                  : AppColors.error,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
