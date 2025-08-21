enum TodoStatus { waiting, progress, done }

class Todo {
  final String id; // 唯一标识
  final String title;
  final String? subtitle;
  final String? description;
  final DateTime? startTime;
  final DateTime? endTime;
  final TodoStatus status;

  Todo({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    this.startTime,
    this.endTime,
    this.status = TodoStatus.waiting,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'subtitle': subtitle,
    'description': description,
    'startTime': startTime?.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'status': status.index,
  };

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'] ?? DateTime.now().toIso8601String(), // 生成唯一 ID
    title: json['title'],
    subtitle: json['subtitle'],
    description: json['description'],
    startTime: json['startTime'] != null
        ? DateTime.parse(json['startTime'])
        : null,
    endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    status: TodoStatus.values[json['status'] ?? 0],
  );
  //  新增 copyWith 方法，避免直接修改原对象
  Todo copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    TodoStatus? status,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
    );
  }
}
