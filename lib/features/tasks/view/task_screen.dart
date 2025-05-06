import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/core/routes.dart';
import 'package:taskmanager/features/tasks/provider/task_bloc.dart';
import 'package:taskmanager/features/tasks/provider/task_managementlogic.dart';
import 'package:taskmanager/features/tasks/provider/task_state.dart';
import 'package:taskmanager/features/tasks/widgets/task_pie_chart.dart';

import '../widgets/animated_task_list.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<String> insertedIds = [];

  @override
  void initState() {
    super.initState();

    // Load tasks on screen mount
    context.read<TaskBloc>().add(LoadTasksEvent());
  }

  void _resetAnimatedList(int count) {
    for (int i = 0; i < count; i++) {
      try {
        _listKey.currentState?.insertItem(i);
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 16, 22),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 16, 22),
        title: Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "My Tasks",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(67, 40, 123, 1),
                    Color.fromRGBO(75, 71, 184, 1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.addTask);
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Add Task',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          // Animate on new task addition
          if (_listKey.currentState != null &&
              state.tasks.isNotEmpty &&
              !insertedIds.contains(state.tasks.first.id)) {
            insertedIds.add(state.tasks.first.id);
            _listKey.currentState!.insertItem(0);
          }
        },
        builder: (context, state) {
          int totalTasks = state.tasks.length;
          int completedTasks =
              state.tasks.where((task) => task.isCompleted).length;
          return Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      height: 200,
                      child: TaskPieChart(
                        totalTasks: totalTasks,
                        completedTasks: completedTasks,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildLegendItem(
                          color: Color.fromRGBO(75, 71, 184, 1),
                          label: 'Completed',
                        ),
                        const SizedBox(width: 16),
                        buildLegendItem(
                          color: Color.fromRGBO(189, 187, 232, 1),
                          label: 'Pending',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: AnimatedTaskList(listKey: _listKey, tasks: state.tasks),
              ),
            ],
          );
        },
      ),
    );
  }
}

//SUPABASE
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:taskmanager/core/routes.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:taskmanager/features/tasks/provider/task_bloc.dart';
// import 'package:taskmanager/features/tasks/provider/task_provider.dart';
// import 'package:taskmanager/features/tasks/provider/task_state.dart';

// import '../widgets/animated_task_list.dart';
// import '../data/task_model.dart';

// class TaskScreen extends StatefulWidget {
//   const TaskScreen({super.key});

//   @override
//   State<TaskScreen> createState() => _TaskScreenState();
// }

// class _TaskScreenState extends State<TaskScreen> {
//   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

//   @override
//   void initState() {
//     super.initState();
//     _loadTasksFromSupabase();
//   }

//   Future<void> _loadTasksFromSupabase() async {
//     final supabase = Supabase.instance.client;

//     try {
//       final response = await supabase.from('tasks').select();
//       final taskList = (response as List<dynamic>)
//           .map((data) => Task.fromJson(data))
//           .toList();

//       // Emit the new task list using BLoC
//       context.read<TaskBloc>().add(SetTasksEvent(taskList));
//       _resetAnimatedList(taskList.length);
//     } catch (e) {
//       // Handle any error that occurs during task loading
//     }
//   }

//   void _resetAnimatedList(int count) {
//     for (int i = 0; i < count; i++) {
//       try {
//         _listKey.currentState?.insertItem(i);
//       } catch (_) {}
//     }
//   }

//   Future<void> _onRefresh() async {
//     await _loadTasksFromSupabase();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 15, 16, 22),
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 15, 16, 22),
//         title: Row(
//           children: [
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text(
//                 "My Tasks",
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             const Spacer(),
//             Container(
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [
//                     Color.fromRGBO(67, 40, 123, 1),
//                     Color.fromRGBO(75, 71, 184, 1),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                   shadowColor: Colors.transparent,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 12,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: () {
//                   Navigator.pushNamed(context, AppRoutes.addTask);
//                 },
//                 child: const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.add, color: Colors.white),
//                     SizedBox(width: 8),
//                     Text(
//                       'Add Task',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: BlocBuilder<TaskBloc, TaskState>(
//         builder: (context, state) {
//           if (state.tasks.isEmpty) {
//             return const Center(
//               child: Text("No tasks available.",
//                   style: TextStyle(color: Colors.white)),
//             );
//           }

//           return RefreshIndicator(
//             onRefresh: _onRefresh,
//             child: AnimatedTaskList(
//               listKey: _listKey,
//               tasks: state.tasks,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
