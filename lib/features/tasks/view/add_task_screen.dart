import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/core/app_Logic.dart';
import 'package:taskmanager/features/tasks/data/task_model.dart';
import 'package:taskmanager/features/tasks/provider/task_bloc.dart';
import 'package:taskmanager/features/tasks/provider/task_managementlogic.dart';
import 'package:taskmanager/features/tasks/widgets/customtextfield.dart';

import 'package:uuid/uuid.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? taskToEdit;

  const AddTaskScreen({super.key, this.taskToEdit});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.taskToEdit != null) {
      titleController.text = widget.taskToEdit!.title;
      descController.text = widget.taskToEdit!.description;
      selectedDate = DateFormat.yMMMd().add_jm().parse(
        widget.taskToEdit!.datetime,
      );
    }
  }

  void _selectDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          selectedDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _saveTask() {
    final title = titleController.text.trim();
    final desc = descController.text.trim();

    if (title.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title and select date/time'),
        ),
      );
      return;
    }

    final formattedDate = DateFormat.yMMMd().add_jm().format(selectedDate!);

    if (widget.taskToEdit == null) {
      final id = const Uuid().v4();
      final newTask = Task(
        id: id,
        title: title,
        description: desc,
        datetime: formattedDate,
      );

      context.read<TaskBloc>().add(AddTaskEvent(newTask));
      // addTaskToSupabase(id, title, desc, formattedDate);
    } else {
      final updatedTask = widget.taskToEdit!.copyWith(
        title: title,
        description: desc,
        datetime: formattedDate,
      );

      context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));
      // updateTaskInSupabase(
      //   id: updatedTask.id,
      //   title: updatedTask.title,
      //   description: updatedTask.description,
      //   datetime: updatedTask.datetime,
      // );
    }

    Navigator.pushNamedAndRemoveUntil(context, '/tasks', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF1E1E2C),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(67, 40, 123, 1),
                          Color.fromRGBO(75, 71, 184, 1),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.taskToEdit == null ? 'Add New Task' : 'Edit Task',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            buildTextField(titleController, "Title", true),
            const SizedBox(height: 16),
            buildTextField(
              descController,
              "Description (optional)",
              false,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _selectDateTime,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate != null
                          ? DateFormat.yMMMd().add_jm().format(selectedDate!)
                          : 'Select Date & Time',
                      style: TextStyle(
                        color:
                            selectedDate != null
                                ? Colors.white
                                : Colors.white54,
                        fontSize: 16,
                      ),
                    ),
                    const Icon(Icons.calendar_month, color: Colors.white70),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/tasks',
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white70, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
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
                      onPressed: _saveTask,
                      child: const Text(
                        'Save Task',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
