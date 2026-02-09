import 'package:flutter/material.dart';
import '../authentication/login.dart';
import '../assignments/assignment_page.dart';
import '../attendance/attendance_page.dart';
import '../dashboard/dashboard_page.dart';
import '../profile/profile_page.dart';
import '../widgets/backgroundWithPattern.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/headerText.dart';
import '../../core/theme/app_colors.dart';
import 'schedule_store.dart';
import 'schedule_model.dart';

class SchedulePage extends StatefulWidget {
  final String displayName;
  final String firstName;
  final String lastName;
  final String email;

  const SchedulePage({
    super.key,
    this.displayName = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
  });

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int selectedNavIndex = 3;
  late int selectedDay;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now().weekday;
    selectedDay = (today >= 1 && today <= 5) ? today : 1;
    ScheduleStore.instance.seedIfEmpty();
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
    setState(() => selectedNavIndex = index);
  }

  void _openSessionForm({ScheduledSession? session}) async {
    final result = await showModalBottomSheet<ScheduledSession>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ScheduleForm(session: session),
    );

    if (result != null) {
      setState(() {
        if (session == null) {
          ScheduleStore.instance.add(result);
        } else {
          ScheduleStore.instance.update(result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.primaryBlue;
    final card = AppColors.primaryWhite;
    final store = ScheduleStore.instance;
    final sessions = store.getSessionsForDay(selectedDay);
    final dayLabels = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Scaffold(
      backgroundColor: bg,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add, color: AppColors.primaryWhite),
        onPressed: () => _openSessionForm(),
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
                      title: 'Scheduling',
                      subtitle: 'Academic Session Planning',
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
                          children: List.generate(dayLabels.length, (index) {
                            final day = index + 1;
                            final isSelected = selectedDay == day;
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => selectedDay = day),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryBlue
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: isSelected ? AppColors.primaryRed : AppColors.textSecondary),
                                  ),
                                  child: Text(
                                    dayLabels[index],
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.primaryWhite
                                          : AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Sessions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: sessions.isEmpty
                            ? const Center(
                                child: Text('No sessions scheduled.'),
                              )
                            : ListView.separated(
                                itemCount: sessions.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (_, i) {
                                  final s = sessions[i];
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
                                          width: 6,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryRed,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                s.title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                s.sessionType,
                                                style: const TextStyle(
                                                  color: AppColors.textSecondary,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                '${_formatTime(s.startTime)} - ${_formatTime(s.endTime)}',
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              s.location.isEmpty
                                                  ? '-'
                                                  : s.location,
                                              style: const TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Switch(
                                              value: s.isPresent,
                                              activeColor:
                                                  AppColors.primaryWhite,
                                              activeTrackColor:
                                                  AppColors.primaryBlue,
                                              inactiveThumbColor:
                                                  AppColors.primaryBlue,
                                              inactiveTrackColor:
                                                  AppColors.primaryWhite,
                                              onChanged: (v) {
                                                setState(() {
                                                  s.isPresent = v;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        PopupMenuButton(
                                          itemBuilder: (_) => [
                                            const PopupMenuItem(
                                              value: 'edit',
                                              child: Text('Edit'),
                                            ),
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child: Text('Delete'),
                                            ),
                                          ],
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              _openSessionForm(session: s);
                                            }
                                            if (value == 'delete') {
                                              setState(() {
                                                ScheduleStore.instance
                                                    .remove(s.id);
                                              });
                                            }
                                          },
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

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _ScheduleForm extends StatefulWidget {
  final ScheduledSession? session;

  const _ScheduleForm({this.session});

  @override
  State<_ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<_ScheduleForm> {
  final _titleCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  TimeOfDay _start = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _end = const TimeOfDay(hour: 10, minute: 0);
  String _type = 'Class';
  bool _isPresent = true;

  @override
  void initState() {
    super.initState();
    final s = widget.session;
    if (s != null) {
      _titleCtrl.text = s.title;
      _locationCtrl.text = s.location;
      _date = s.date;
      _start = s.startTime;
      _end = s.endTime;
      _type = s.sessionType;
      _isPresent = s.isPresent;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
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
                widget.session == null ? 'New Session' : 'Edit Session',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),
          _inputLabel('Session Title'),
          _textField(_titleCtrl, 'e.g. Data Structures'),
          const SizedBox(height: 12),
          _inputLabel('Date'),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked != null) setState(() => _date = picked);
            },
            child: _pickerField(
              '${_date.day}/${_date.month}/${_date.year}',
              icon: Icons.calendar_today,
            ),
          ),
          const SizedBox(height: 12),
          _inputLabel('Start Time'),
          GestureDetector(
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _start,
              );
              if (picked != null) setState(() => _start = picked);
            },
            child: _pickerField(_formatTime(_start), icon: Icons.schedule),
          ),
          const SizedBox(height: 12),
          _inputLabel('End Time'),
          GestureDetector(
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _end,
              );
              if (picked != null) setState(() => _end = picked);
            },
            child: _pickerField(_formatTime(_end), icon: Icons.schedule),
          ),
          const SizedBox(height: 12),
          _inputLabel('Location (optional)'),
          _textField(_locationCtrl, 'e.g. Room 204'),
          const SizedBox(height: 12),
          _inputLabel('Session Type'),
          DropdownButtonFormField(
            value: _type,
            decoration: _dropdownDecoration(),
            items: const [
              'Class',
              'Mastery Session',
              'Study Group',
              'PSL Meeting',
            ]
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (v) => setState(() => _type = v ?? 'Class'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Present'),
              const Spacer(),
              Switch(
                value: _isPresent,
                activeColor: AppColors.primaryWhite,
                activeTrackColor: AppColors.primaryBlue,
                inactiveThumbColor: AppColors.primaryBlue,
                inactiveTrackColor: AppColors.primaryWhite,
                onChanged: (v) => setState(() => _isPresent = v),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                if (_titleCtrl.text.trim().isEmpty) return;
                final session = ScheduledSession(
                  id: widget.session?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _titleCtrl.text.trim(),
                  date: _date,
                  startTime: _start,
                  endTime: _end,
                  location: _locationCtrl.text.trim(),
                  sessionType: _type,
                  dayOfWeek: _date.weekday,
                  isPresent: _isPresent,
                );
                Navigator.pop(context, session);
              },
              child: const Text('Save Session'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _inputLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _textField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
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
          borderSide: BorderSide(color: AppColors.primaryDark),
        ),
      ),
    );
  }

  Widget _pickerField(String value, {required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
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
        borderSide: BorderSide(color: AppColors.primaryDark),
      ),
    );
  }
}
