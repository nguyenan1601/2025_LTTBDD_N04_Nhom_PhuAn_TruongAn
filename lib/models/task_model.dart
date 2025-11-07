class Task {
  String id;
  String title;
  String description;
  DateTime dueDate;
  Priority priority;
  TaskStatus status;
  DateTime createdAt;
  DateTime? completedAt;
  String? category;
  List<String> tags;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.status = TaskStatus.pending,
    required this.createdAt,
    this.completedAt,
    this.category,
    this.tags = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'priority': priority.index,
      'status': status.index,
      'createdAt':
          createdAt.millisecondsSinceEpoch,
      'completedAt':
          completedAt?.millisecondsSinceEpoch,
      'category': category,
      'tags': tags,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate:
          DateTime.fromMillisecondsSinceEpoch(
            map['dueDate'],
          ),
      priority: Priority.values[map['priority']],
      status: TaskStatus.values[map['status']],
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(
            map['createdAt'],
          ),
      completedAt: map['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['completedAt'],
            )
          : null,
      category: map['category'],
      tags: List<String>.from(map['tags'] ?? []),
    );
  }
}

enum Priority { low, medium, high, urgent }

enum TaskStatus {
  pending,
  inProgress,
  completed,
  cancelled,
}
