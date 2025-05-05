import 'package:taskmanager/features/tasks/data/task_model.dart';

abstract class TaskEvent {}

class LoadTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;
  AddTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final int index;
  final void Function() onDelete;
  DeleteTaskEvent(this.index, this.onDelete);
}

class ToggleTaskCompletionEvent extends TaskEvent {
  final int index;
  ToggleTaskCompletionEvent(this.index);
}

class UpdateTaskEvent extends TaskEvent {
  final Task updatedTask;
  UpdateTaskEvent(this.updatedTask);
}

class SetTasksEvent extends TaskEvent {
  final List<Task> tasks;
  SetTasksEvent(this.tasks);
}
