import 'package:flutter/material.dart';
import '../authentication/login.dart';
import '../assignments/assignment_page.dart';
import '../attendance/attendance_page.dart';
import '../attendance/attendance_store.dart';
import '../assignments/assignment_store.dart';
import '../schedule/schedule_store.dart';
import '../schedule/schedule_page.dart';
import '../profile/profile_page.dart';
import '../widgets/backgroundWithPattern.dart';
import '../widgets/headerText.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class DashboardPage extends StatefulWidget {
  final String displayName;
  final String firstName;
  final String lastName;
  final String email;

  const DashboardPage({
    super.key,
    this.displayName = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    // Ensure stores are seeded
    AttendanceStore.instance.seedIfEmpty();
    AssignmentStore.instance.seedIfEmpty();
    ScheduleStore.instance.seedIfEmpty();
    // Listen for assignment changes
    AssignmentStore.instance.addListener(_onAssignmentsChanged);
  }

  @override
  void dispose() {
    AssignmentStore.instance.removeListener(_onAssignmentsChanged);
    super.dispose();
  }

  void _onAssignmentsChanged() {
    setState(() {
      // This will rebuild the widget with updated assignments
    });
  }

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

  String get _formattedDate {
    final now = DateTime.now();
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final weekDays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    return '${weekDays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  String get _academicWeek {
    final now = DateTime.now();
    // Assuming semester started on Jan 6, 2026
    final start = DateTime(2026, 1, 6);
    final diff = now.difference(start).inDays;
    if (diff < 0) return 'Pre-Semester';
    final week = (diff / 7).floor() + 1;
    return 'Week $week';
  }

  void _onNavTap(int index) {
    if (index == selectedNavIndex) return;
    if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => AttendancePage(
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
    if (index == 3) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => SchedulePage(
            displayName: widget.displayName,
            firstName: widget.firstName,
            lastName: widget.lastName,
            email: widget.email,
          ),
        ),
      );
      return;
    }
    setState(() => selectedNavIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.primaryBlue;
    final card = AppColors.primaryWhite;
    
    final attendanceStore = AttendanceStore.instance;
    final assignmentStore = AssignmentStore.instance;
    final scheduleStore = ScheduleStore.instance;

    final todaySessions = scheduleStore.getSessionsForDay(DateTime.now().weekday);
    final upcomingAssignments = assignmentStore.getAssignmentsDueWithin(7);

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
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProfilePage(
                                  fullName: _displayName,
                                  email: widget.email,
                                ),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primaryWhite,
                            child: Text(
                              _initials,
                              style: const TextStyle(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
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
                                backgroundColor: AppColors.primaryWhite,
                                title: const Text(
                                  'Confirm Logout',
                                  style: TextStyle(color: AppColors.textPrimary),
                                ),
                                content: const Text(
                                  'Are you sure you want to log out?',
                                  style: TextStyle(color: AppColors.textSecondary),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.textSecondary,
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
                                      backgroundColor:
                                          AppColors.primaryRed,
                                      foregroundColor: AppColors.primaryWhite,
                                    ),
                                    child: const Text('Logout'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.logout, color: AppColors.primaryWhite),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const HeaderText(
                      title: 'Dashboard',
                      subtitle: 'Overview',
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date and Week
                      Container(
                        width: double.infinity,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _formattedDate,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _academicWeek,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(Icons.calendar_today_outlined, color: Colors.blueGrey),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Overview',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _metricItem('Attendance',
                                '${attendanceStore.percentage.toStringAsFixed(1)}%'),
                            _metricItem('Assignments', '${assignmentStore.pendingCount}'), // Pending count
                            _metricItem('Classes Today', '${todaySessions.length}'),
                          ],
                        ),
                      ),
                      if (attendanceStore.isBelowThreshold) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.primaryRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primaryRed),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  color: AppColors.primaryRed),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Your attendance is below 75%. Please improve it.',
                                  style: TextStyle(color: AppColors.primaryRed),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),
                      
                      // Today's Sessions
                      const Text(
                        "Today's Sessions",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (todaySessions.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('No sessions scheduled for today.', style: TextStyle(color: AppColors.textSecondary)),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: todaySessions.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            final session = todaySessions[i];
                            return Container(
                              padding: const EdgeInsets.all(14),
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
                                    width: 4,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryRed,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          session.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          session.location,
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    session.timeRange,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                      const SizedBox(height: 20),

                      // Upcoming Assignments
                      const Text(
                        'Assignments Due Soon',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                       if (upcomingAssignments.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('No assignments due in the next 7 days.', style: TextStyle(color: AppColors.textSecondary)),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: upcomingAssignments.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            final assignment = upcomingAssignments[i];
                            return Container(
                              padding: const EdgeInsets.all(14),
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
                                  Icon(
                                    Icons.assignment_late_outlined,
                                    color: assignment.priority == 'High' ? AppColors.primaryRed : AppColors.accentYellow,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          assignment.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          assignment.course,
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        assignment.formattedDate,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                       Text(
                                        assignment.priority,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11,
                                          color: assignment.priority == 'High' ? AppColors.primaryRed : AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 40), // Bottom padding
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

  Widget _metricItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
