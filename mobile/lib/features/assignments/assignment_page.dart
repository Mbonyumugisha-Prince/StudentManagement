import 'package:flutter/material.dart';
import 'assignment_form.dart';
import 'assignment_model.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  List<Assignment> assignments = [];
  int selectedTab = 0;

  /// Filter assignments based on selected tab
  List<Assignment> get filteredAssignments {
    switch (selectedTab) {
      case 1: // High Priority
        return assignments.where((a) => a.priority == 'High').toList();
      case 2: // This Week
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
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E293B),
        child: const Icon(Icons.add),
        onPressed: () => _openForm(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                "TASKS & DEADLINES",
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 1.5,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Assignments",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              /// Tabs
              Row(
                children: ["All", "High Priority", "This Week"]
                    .asMap()
                    .entries
                    .map((entry) {
                  final index = entry.key;
                  final label = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = index),
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

              const Divider(height: 32),

              /// Assignment list
              Expanded(
                child: ListView.separated(
                  itemCount: filteredAssignments.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, i) {
                    final a = filteredAssignments[i];
                    return ListTile(
                      leading: Checkbox(
                        value: a.isCompleted,
                        onChanged: (v) {
                          setState(() => a.isCompleted = v!);
                        },
                      ),
                      title: Text(
                        a.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          decoration: a.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Due ${a.formattedDate}",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.circle, size: 8),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              a.course,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                              value: 'edit', child: Text("Edit")),
                          const PopupMenuItem(
                              value: 'delete', child: Text("Delete")),
                        ],
                        onSelected: (value) {
                          if (value == 'edit') _openForm(assignment: a);
                          if (value == 'delete') _deleteAssignment(a);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
