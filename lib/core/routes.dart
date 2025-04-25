import 'package:flutter/material.dart';
import 'package:taskmanager/features/tasks/view/add_task_screen.dart';
import 'package:taskmanager/features/tasks/view/splash.dart';
import 'package:taskmanager/features/tasks/view/task_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String task = '/tasks';
  static const String addTask = '/add-task';
  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashScreen(),
    task: (_) => const TaskScreen(),
    addTask: (_) => const AddTaskScreen(),
  };
}
