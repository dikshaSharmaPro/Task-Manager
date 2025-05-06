import 'package:supabase_flutter/supabase_flutter.dart';

class AppLogicException implements Exception {
  final String message;
  AppLogicException(this.message);

  @override
  String toString() => 'AppLogicException: $message';
}

Future<void> deleteTaskFromSupabase(String id) async {
  final supabase = Supabase.instance.client;

  try {
    final response = await supabase.from('tasks').delete().eq('id', id);

    if (response.error != null) {
      throw AppLogicException(
        'Failed to delete task: ${response.error!.message}',
      );
    }
  } catch (e) {
    throw AppLogicException('An error occurred while deleting the task: $e');
  }
}

Future<void> updateTaskInSupabase({
  required String id,
  required String title,
  required String description,
  required String datetime,
}) async {
  final supabase = Supabase.instance.client;

  try {
    final response = await supabase
        .from('tasks')
        .update({
          'title': title,
          'description': description,
          'datetime': datetime,
        })
        .eq('id', id);

    if (response.error != null) {
      throw AppLogicException(
        'Failed to update task: ${response.error!.message}',
      );
    }
  } catch (e) {
    throw AppLogicException('An error occurred while updating the task: $e');
  }
}

Future<void> addTaskToSupabase(
  String id,
  String title,
  String description,
  String datetime,
) async {
  final supabase = Supabase.instance.client;

  try {
    final response = await supabase.from('tasks').insert({
      'id': id,
      'title': title,
      'description': description,
      'datetime': datetime,
    });

    if (response == null) {
      throw AppLogicException('Failed to add task: Response is null.');
    }

    if (response.error != null) {
      throw AppLogicException('Failed to add task: ${response.error!.message}');
    }
  } catch (e) {
    throw AppLogicException('An error occurred while adding the task: $e');
  }
}
