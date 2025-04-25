// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:taskmanager/core/routes.dart';

// import '../provider/task_provider.dart';
// import '../widgets/animated_task_list.dart';

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
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final provider = Provider.of<TaskProvider>(context, listen: false);

//       provider.onTaskAdded = () {
//         final taskLength = provider.tasks.length;
//         if (_listKey.currentState != null && taskLength > 0) {
//           try {
//             _listKey.currentState!.insertItem(0);
//           } catch (e) {
//             print('InsertItem error: $e');
//           }
//         }
//       };

//       _resetAnimatedList(provider.tasks.length);
//     });
//   }

//   void _resetAnimatedList(int count) {
//     for (int i = 0; i < count; i++) {
//       try {
//         _listKey.currentState?.insertItem(i);
//       } catch (_) {}
//     }
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
//       body: AnimatedTaskList(listKey: _listKey),
//     );
//   }
// }

//SUPABASE

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/core/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../provider/task_provider.dart';
import '../widgets/animated_task_list.dart';
import '../data/task_model.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _loadTasksFromSupabase();
  }

  Future<void> _loadTasksFromSupabase() async {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase.from('tasks').select();
      final taskList = (response)
          .map(
            (data) => Task.fromJson(data),
          )
          .toList();

      provider.setTasks(taskList);

      _resetAnimatedList(taskList.length);
    } catch (e) {
      // print(' Error loading tasks: $e');
    }
  }

  void _resetAnimatedList(int count) {
    for (int i = 0; i < count; i++) {
      try {
        _listKey.currentState?.insertItem(i);
      } catch (_) {}
    }
  }

  Future<void> _onRefresh() async {
    await _loadTasksFromSupabase();
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
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: AnimatedTaskList(listKey: _listKey),
      ),
    );
  }
}
