import 'package:flutter/material.dart';
import 'assignment_model.dart';

class AssignmentForm extends StatefulWidget {
  final Assignment? assignment;

  const AssignmentForm({super.key, this.assignment});

  @override
  State<AssignmentForm> createState() => _AssignmentFormState();
}

class _AssignmentFormState extends State<AssignmentForm> {
  final titleCtrl = TextEditingController();
  final courseCtrl = TextEditingController();
  DateTime? dueDate;
  String priority = "Medium";

  @override
  void initState() {
    super.initState();
    if (widget.assignment != null) {
      titleCtrl.text = widget.assignment!.title;
      courseCtrl.text = widget.assignment!.course;
      dueDate = widget.assignment!.dueDate;
      priority = widget.assignment!.priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.assignment == null
                    ? "New Assignment"
                    : "Edit Assignment",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),

          _inputLabel("TITLE"),
          _inputField(titleCtrl, "e.g. Research Paper"),

          _inputLabel("COURSE"),
          _inputField(courseCtrl, "e.g. Entrepreneurial Leadership"),

          _inputLabel("DUE DATE"),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked != null) setState(() => dueDate = picked);
            },
            child: _inputField(
              TextEditingController(
                text: dueDate == null
                    ? ""
                    : "${dueDate!.day}/${dueDate!.month}/${dueDate!.year}",
              ),
              "dd/mm/yyyy",
              enabled: false,
              icon: Icons.calendar_today,
            ),
          ),

          _inputLabel("PRIORITY"),
          DropdownButtonFormField(
            value: priority,
            items: ["High", "Medium", "Low"]
                .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                .toList(),
            onChanged: (v) => priority = v!,
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E293B),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("ADD TASK"),
              onPressed: () {
                if (titleCtrl.text.isEmpty || dueDate == null) return;

                Navigator.pop(
                  context,
                  Assignment(
                    id: widget.assignment?.id ??
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleCtrl.text,
                    course: courseCtrl.text,
                    dueDate: dueDate!,
                    priority: priority,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputLabel(String text) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 4),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      );

  Widget _inputField(
    TextEditingController controller,
    String hint, {
    bool enabled = true,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: icon == null ? null : Icon(icon),
      ),
    );
  }
}
