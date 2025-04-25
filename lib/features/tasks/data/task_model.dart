class Task {
  final String id;
  final String title;
  final String description;
  final String datetime;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.datetime,
    this.isCompleted = false,
  });
  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? datetime,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      datetime: datetime ?? this.datetime,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'datetime': datetime,
        'isCompleted': isCompleted,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        datetime: json['datetime'],
        isCompleted: json['isCompleted'] ?? false,
      );
}
