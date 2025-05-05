import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/features/tasks/data/task_model.dart';
import 'package:taskmanager/features/tasks/provider/task_bloc.dart';
import 'package:taskmanager/features/tasks/provider/task_managementlogic.dart';
import 'package:taskmanager/features/tasks/provider/task_state.dart';
import 'package:taskmanager/features/tasks/view/add_task_screen.dart';

import '../widgets/task_tile.dart';

class AnimatedTaskList extends StatelessWidget {
  final List<Task> tasks;
  final GlobalKey<AnimatedListState> listKey;
  const AnimatedTaskList({
    super.key,
    required this.listKey,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        final tasks = state.tasks;

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
                onToggle: () {
                  context
                      .read<TaskBloc>()
                      .add(ToggleTaskCompletionEvent(index));
                },
                onDelete: () {
                  final removedTask = task;
                  listKey.currentState?.removeItem(
                    index,
                    (context, animation) => SizeTransition(
                      sizeFactor: animation,
                      child: TaskTile(task: removedTask),
                    ),
                  );
                  context
                      .read<TaskBloc>()
                      .add(DeleteTaskEvent(index, () => tasks[index]));
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
      },
    );
  }
}
