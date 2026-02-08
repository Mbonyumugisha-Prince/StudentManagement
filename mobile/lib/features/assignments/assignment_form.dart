import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'assignment_model.dart';

class AssignmentForm extends StatefulWidget {
  final Assignment? assignment;

  const AssignmentForm({super.key, this.assignment});

  @override
  State<AssignmentForm> createState() => _AssignmentFormState();
}

class _AssignmentFormState extends State<AssignmentForm> {
  final _formKey = GlobalKey<FormState>();
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
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
            
                _inputLabel("TITLE"),
                _inputField(
                  controller: titleCtrl,
                  hint: "e.g. Research Paper",
                  validator: (v) => v == null || v.isEmpty ? 'Please enter a title' : null,
                ),
            
                _inputLabel("COURSE"),
                _inputField(
                  controller: courseCtrl,
                  hint: "e.g. Entrepreneurial Leadership",
                  validator: (v) => v == null || v.isEmpty ? 'Please enter a course' : null,
                ),
            
                _inputLabel("DUE DATE"),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppColors.primaryDark,
                              onPrimary: AppColors.primaryGold,
                              onSurface: AppColors.textPrimary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) setState(() => dueDate = picked);
                  },
                  child: AbsorbPointer(
                    child: _inputField(
                      controller: TextEditingController(
                        text: dueDate == null
                            ? ""
                            : "${dueDate!.day}/${dueDate!.month}/${dueDate!.year}",
                      ),
                      hint: "dd/mm/yyyy",
                      icon: Icons.calendar_today,
                      validator: (v) => dueDate == null ? 'Please select a due date' : null,
                    ),
                  ),
                ),
            
                _inputLabel("PRIORITY"),
                DropdownButtonFormField<String>(
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
                      borderSide: const BorderSide(color: AppColors.primaryDark),
                    ),
                  ),
                  items: ["High", "Medium", "Low"]
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => setState(() => priority = v!),
                ),
            
                const SizedBox(height: 24),
            
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: AppColors.primaryGold,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      widget.assignment == null ? "ADD TASK" : "UPDATE TASK",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(
                          context,
                          Assignment(
                            id: widget.assignment?.id ??
                                DateTime.now().millisecondsSinceEpoch.toString(),
                            title: titleCtrl.text,
                            course: courseCtrl.text,
                            dueDate: dueDate!,
                            priority: priority,
                            isCompleted: widget.assignment?.isCompleted ?? false,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputLabel(String text) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.black54,
          ),
        ),
      );

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: icon == null
            ? null
            : Icon(icon, color: AppColors.primaryDark),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryDark),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}