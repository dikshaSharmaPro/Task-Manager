import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> deleteTaskFromSupabase(String id) async {
  final supabase = Supabase.instance.client;

  try {
    await supabase.from('tasks').delete().eq('id', id);
    //print('Task deleted: $id');
  } catch (e) {
    // print(' Error deleting task: $e');
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
    await supabase
        .from('tasks')
        .update({
          'title': title,
          'description': description,
          'datetime': datetime,
        })
        .eq('id', id);

    //print(' Task updated: $id');
  } catch (e) {
    //print(' Error updating task: $e');
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
    await supabase.from('tasks').insert({
      'id': id,
      'title': title,
      'description': description,
      'datetime': datetime,
    });

    //print(' Task inserted: $result');
  } catch (e) {
    rethrow;
  }
}
