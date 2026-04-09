enum TaskStatus {
  inProgress,
  done,
  late,
  abandoned,
}

enum TaskPriority {
  high,
  medium,
  low,
}

enum TaskCategory {
  personal,
  work,
  other,
}

class Task {
  String id;
  String title;
  String description;
  TaskStatus status;
  TaskPriority priority;
  TaskCategory category;
  DateTime createdAt;
  DateTime startDate;
  DateTime dueDate;
  DateTime? reminder;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.status = TaskStatus.inProgress,
    this.priority = TaskPriority.medium,
    this.category = TaskCategory.personal,
    required this.createdAt,
    required this.startDate,
    required this.dueDate,
    this.reminder,
  });
}