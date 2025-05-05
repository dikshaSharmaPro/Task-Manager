import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/features/tasks/provider/task_provider.dart';

import '../data/shared_pref.dart';
import '../data/task_model.dart';

import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(const TaskState()) {
    on<LoadTasksEvent>((event, emit) async {
      final tasks = await SharedPreferencesHelper.loadTasks();
      emit(state.copyWith(tasks: tasks));
    });

    on<SetTasksEvent>((event, emit) {
      emit(state.copyWith(tasks: event.tasks));
    });

    on<AddTaskEvent>((event, emit) async {
      final updated = [event.task, ...state.tasks];
      await SharedPreferencesHelper.saveTasks(updated);
      emit(state.copyWith(tasks: updated));
    });

    on<DeleteTaskEvent>((event, emit) async {
      final updated = List<Task>.from(state.tasks)..removeAt(event.index);
      await SharedPreferencesHelper.saveTasks(updated);
      event.onDelete();
      emit(state.copyWith(tasks: updated));
    });

    on<ToggleTaskCompletionEvent>((event, emit) async {
      final updated = List<Task>.from(state.tasks);
      updated[event.index].isCompleted = !updated[event.index].isCompleted;
      await SharedPreferencesHelper.saveTasks(updated);
      emit(state.copyWith(tasks: updated));
    });

    on<UpdateTaskEvent>((event, emit) async {
      final updated = List<Task>.from(state.tasks);
      final index = updated.indexWhere((t) => t.id == event.updatedTask.id);
      if (index != -1) {
        updated[index] = event.updatedTask;
        await SharedPreferencesHelper.saveTasks(updated);
        emit(state.copyWith(tasks: updated));
      }
    });
  }
}
