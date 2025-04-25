import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/features/tasks/view/add_task_screen.dart';

import '../provider/task_provider.dart';
import '../widgets/task_tile.dart';

class AnimatedTaskList extends StatelessWidget {
  final GlobalKey<AnimatedListState> listKey;
  const AnimatedTaskList({super.key, required this.listKey});

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final tasks = taskProvider.tasks;
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/notask.png', height: 200),
            const SizedBox(height: 20),
            const Text(
              'No tasks yet!',
              style: TextStyle(color: Colors.white70, fontSize: 20),
            ),
          ],
        ),
      );
    }
    return AnimatedList(
      key: listKey,
      initialItemCount: tasks.length,
      itemBuilder: (context, index, animation) {
        if (index >= tasks.length) return const SizedBox();
        final task = tasks[index];
        return SizeTransition(
          sizeFactor: animation,
          child: TaskTile(
            task: task,
            onToggle: () => taskProvider.toggleTaskCompletion(index),
            onDelete: () {
              final removedTask = task;
              listKey.currentState?.removeItem(
                index,
                (context, animation) => SizeTransition(
                  sizeFactor: animation,
                  child: TaskTile(task: removedTask),
                ),
              );
              taskProvider.deleteTask(index, () {});
            },
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskScreen(taskToEdit: task),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
