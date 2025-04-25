import 'package:flutter/material.dart';

import 'package:taskmanager/features/tasks/data/shared_pref.dart';

import '../data/task_model.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  void Function()? onTaskAdded;

  List<Task> get tasks => List.unmodifiable(_tasks);

  // TaskProvider() {
  //   loadTasks();
  // }

  Future<void> loadTasks() async {
    final tasks = await SharedPreferencesHelper.loadTasks();
    _tasks.clear();
    _tasks.addAll(tasks);

    notifyListeners();
  }

  // Used when loading from Supabase
  void setTasks(List<Task> tasks) {
    _tasks = tasks;
    notifyListeners();
  }

  void addTask(Task task) async {
    _tasks.insert(0, task);
    await SharedPreferencesHelper.saveTasks(_tasks);
    // print("Task added and saved: ${task.title}");
    notifyListeners();
    onTaskAdded?.call();
  }

  void deleteTask(int index, void Function() onDeleteAnimationComplete) async {
    // print("Deleting task: ${_tasks[index].title}");
    _tasks.removeAt(index);
    await SharedPreferencesHelper.saveTasks(_tasks);
    onDeleteAnimationComplete();
    notifyListeners();
  }

  void toggleTaskCompletion(int index) async {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    await SharedPreferencesHelper.saveTasks(_tasks);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }
}
