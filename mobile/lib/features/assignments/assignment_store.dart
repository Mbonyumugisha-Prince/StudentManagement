import 'assignment_model.dart';

class AssignmentStore {
  AssignmentStore._();
  static final AssignmentStore instance = AssignmentStore._();

  final List<Assignment> _assignments = [];
  bool _seeded = false;
  final List<Function()> _listeners = [];

  List<Assignment> getAll() => List.unmodifiable(_assignments);

  void addListener(Function() listener) {
    _listeners.add(listener);
  }

  void removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  void add(Assignment assignment) {
    _assignments.add(assignment);
    _assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    _notifyListeners();
  }

  void update(Assignment assignment) {
    final index = _assignments.indexWhere((a) => a.id == assignment.id);
    if (index != -1) {
      _assignments[index] = assignment;
      _assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      _notifyListeners();
    }
  }

  void delete(String id) {
    _assignments.removeWhere((a) => a.id == id);
    _notifyListeners();
  }

  void seedIfEmpty() {
    if (_seeded || _assignments.isNotEmpty) return;
    _seeded = true;
    final now = DateTime.now();
    
    // Seed some assignments
    add(Assignment(
      id: 'seed-1',
      title: 'Calculus Problem Set',
      course: 'Mathematics',
      dueDate: now.add(const Duration(days: 1)),
      priority: 'High',
      isCompleted: false,
    ));
    add(Assignment(
      id: 'seed-2',
      title: 'Physics Lab Report',
      course: 'Physics',
      dueDate: now.add(const Duration(days: 3)),
      priority: 'Medium',
      isCompleted: false,
    ));
    add(Assignment(
      id: 'seed-3',
      title: 'History Essay',
      course: 'History',
      dueDate: now.add(const Duration(days: 6)),
      priority: 'Low',
      isCompleted: true,
    ));
    add(Assignment(
      id: 'seed-4',
      title: 'Programming Project',
      course: 'Computer Science',
      dueDate: now.add(const Duration(days: 8)),
      priority: 'High',
      isCompleted: false,
    ));
  }

  /// Get assignments due within the next [days] days (inclusive of today)
  List<Assignment> getAssignmentsDueWithin(int days) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final limit = today.add(Duration(days: days + 1)); // +1 to include the last day fully if comparing timestamps, but strict date compare is safer

    return _assignments.where((a) {
      return a.dueDate.isAfter(today.subtract(const Duration(seconds: 1))) && 
             a.dueDate.isBefore(limit) && 
             !a.isCompleted;
    }).toList();
  }

  int get pendingCount => _assignments.where((a) => !a.isCompleted).length;
}
