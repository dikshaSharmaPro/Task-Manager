import '../data/task_model.dart';

class TaskState {
  final List<Task> tasks;
  const TaskState({this.tasks = const []});

  TaskState copyWith({List<Task>? tasks}) {
    return TaskState(tasks: tasks ?? this.tasks);
  }
}
