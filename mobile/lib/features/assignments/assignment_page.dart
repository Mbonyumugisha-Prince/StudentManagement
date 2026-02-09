import 'package:flutter/material.dart';
import 'assignment_form.dart';
import 'assignment_model.dart';
import 'assignment_store.dart';
import '../authentication/login.dart';
import '../profile/profile_page.dart';
import '../attendance/attendance_page.dart';
import '../dashboard/dashboard_page.dart';
import '../schedule/schedule_page.dart';
import '../widgets/backgroundWithPattern.dart';
import '../widgets/headerText.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class AssignmentsPage extends StatefulWidget {
  final String displayName;
  final String firstName;
  final String lastName;
  final String email;

  const AssignmentsPage({
    super.key,
    this.displayName = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
  });

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  List<Assignment> assignments = [];
  int selectedTab = 0;
  int selectedNavIndex = 2;
  final _assignmentStore = AssignmentStore.instance;

  @override
  void initState() {
    super.initState();
    _assignmentStore.seedIfEmpty();
    _loadAssignments();
    _assignmentStore.addListener(_loadAssignments);
  }

  @override
  void dispose() {
    _assignmentStore.removeListener(_loadAssignments);
    super.dispose();
  }

  void _loadAssignments() {
    setState(() {
      assignments = _assignmentStore.getAll();
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

  /// Filter assignments based on selected tab
  List<Assignment> get filteredAssignments {
    switch (selectedTab) {
      case 1: // High Priority
        return assignments.where((a) => a.priority == 'High').toList();
      case 2: // Medium Priority
        return assignments.where((a) => a.priority == 'Medium').toList();
      case 3: // Low Priority
        return assignments.where((a) => a.priority == 'Low').toList();
      case 4: // This Week
        final now = DateTime.now();
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return assignments.where((a) {
          return a.dueDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
                 a.dueDate.isBefore(endOfWeek.add(const Duration(days: 1)));
        }).toList();
      default: // All
        return assignments;
    }
  }

  void _openForm({Assignment? assignment}) async {
    final result = await showModalBottomSheet<Assignment>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AssignmentForm(assignment: assignment),
    );

    if (result != null) {
      if (assignment != null) {
        // Update existing assignment
        _assignmentStore.update(result);
      } else {
        // Add new assignment
        _assignmentStore.add(result);
      }
    }
  }

  void _deleteAssignment(Assignment a) {
    _assignmentStore.delete(a.id);
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

    return Scaffold(
      backgroundColor: bg,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add, color: AppColors.primaryWhite),
        onPressed: () => _openForm(),
      ),
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
                                    onPressed: () => Navigator.of(context).pop(),
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
                                      backgroundColor: AppColors.primaryRed,
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
                      title: 'Assignments',
                      subtitle: 'Tasks & Deadlines',
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            "All",
                            "High Priority",
                            "Medium Priority",
                            "Low Priority",
                            "This Week",
                          ]
                              .asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key;
                            final label = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(right: 24),
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => selectedTab = index),
                                child: Column(
                                  children: [
                                    Text(
                                      label,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: selectedTab == index
                                            ? AppColors.primaryBlue
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                    if (selectedTab == index)
                                      Container(
                                        margin: const EdgeInsets.only(top: 6),
                                        height: 3,
                                        width: 24,
                                        color: AppColors.primaryRed,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const Divider(height: 32),
                      Expanded(
                        child: ListView.separated(
                          itemCount: filteredAssignments.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) {
                            final a = filteredAssignments[i];
                            final priorityColor = a.priority == 'High'
                                ? AppColors.primaryRed
                                : a.priority == 'Medium'
                                    ? AppColors.accentYellow
                                    : AppColors.success;
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          a.isCompleted = !a.isCompleted;
                                          _assignmentStore.update(a);
                                        },
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: a.isCompleted
                                                ? AppColors.primaryBlue
                                                : Colors.transparent,
                                            border: Border.all(
                                                color: AppColors.textSecondary),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: a.isCompleted
                                              ? const Icon(
                                                  Icons.check,
                                                  size: 14,
                                                  color: AppColors.primaryWhite,
                                                )
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          a.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            decoration: a.isCompleted
                                                ? TextDecoration.lineThrough
                                                : null,
                                            color: a.isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      PopupMenuButton(
                                        itemBuilder: (_) => [
                                          const PopupMenuItem(
                                              value: 'edit',
                                              child: Text("Edit")),
                                          const PopupMenuItem(
                                              value: 'delete',
                                              child: Text("Delete")),
                                        ],
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            _openForm(assignment: a);
                                          }
                                          if (value == 'delete') {
                                            _deleteAssignment(a);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.background,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          "Due ${a.formattedDate}",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color:
                                              priorityColor.withOpacity(0.12),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          a.priority,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: priorityColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(Icons.book_outlined,
                                          size: 16, color: AppColors.textSecondary),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          a.course,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
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
