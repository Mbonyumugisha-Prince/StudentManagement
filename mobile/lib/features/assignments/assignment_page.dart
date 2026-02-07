import 'package:flutter/material.dart';
import 'assignment_form.dart';
import 'assignment_model.dart';
import '../authentication/login.dart';
import '../profile/profile_page.dart';
import '../attendance/attendance_page.dart';
import '../dashboard/dashboard_page.dart';
import '../widgets/backgroundWithPattern.dart';
import '../widgets/headerText.dart';

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
      backgroundColor: const Color(0xFFF4F5F4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AssignmentForm(assignment: assignment),
    );

    if (result != null) {
      setState(() {
        assignments.removeWhere((a) => a.id == result.id);
        assignments.add(result);
        assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      });
    }
  }

  void _deleteAssignment(Assignment a) {
    setState(() => assignments.remove(a));
  }

  @override
  Widget build(BuildContext context) {
    final bg = Colors.black;
    final card = const Color(0xFFF4F5F4);

    return Scaffold(
      backgroundColor: bg,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E293B),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _openForm(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedNavIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
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
          setState(() => selectedNavIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_reg_outlined),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Assignment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            label: 'Scheduling',
          ),
        ],
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
                            backgroundColor: const Color(0xFF1E293B),
                            child: Text(
                              _initials,
                              style: const TextStyle(
                                color: Colors.white,
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
                                    onPressed: () => Navigator.of(context).pop(),
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
                                      backgroundColor: const Color(0xFF1E293B),
                                      foregroundColor: Colors.white,
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
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                    if (selectedTab == index)
                                      Container(
                                        margin: const EdgeInsets.only(top: 6),
                                        height: 3,
                                        width: 24,
                                        color: Colors.black,
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
                                ? const Color(0xFFDC2626)
                                : a.priority == 'Medium'
                                    ? const Color(0xFFF59E0B)
                                    : const Color(0xFF10B981);
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
                                          setState(() => a.isCompleted =
                                              !a.isCompleted);
                                        },
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: a.isCompleted
                                                ? const Color(0xFF1E293B)
                                                : Colors.transparent,
                                            border: Border.all(
                                                color: Colors.black26),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: a.isCompleted
                                              ? const Icon(
                                                  Icons.check,
                                                  size: 14,
                                                  color: Colors.white,
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
                                          color: Colors.grey.shade200,
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
                                          size: 16, color: Colors.black45),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          a.course,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black54,
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
