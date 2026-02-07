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
    final card = const Color(0xFFF4F5F4);
    final accent = const Color(0xFF6F8F7B);

    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
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
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),

            _inputLabel("TITLE"),
            _inputField(titleCtrl, "e.g. Research Paper", accent: accent),

            _inputLabel("COURSE"),
            _inputField(courseCtrl, "e.g. Entrepreneurial Leadership",
                accent: accent),

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
                accent: accent,
              ),
            ),

            _inputLabel("PRIORITY"),
            DropdownButtonFormField(
              value: priority,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: accent),
                ),
              ),
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
                  foregroundColor: Colors.white,
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
    Color? accent,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        suffixIcon: icon == null
            ? null
            : Icon(icon, color: accent ?? Colors.black54),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accent ?? Colors.black),
        ),
      ),
    );
  }
}
