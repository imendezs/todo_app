import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateTaskService {
  Future<void> updateTask(
    String taskId,
    String newTitle,
    String newDescription,
    String newDate,
    String newStatus,
    String newPriority,
  ) async {
    try {
      DateTime parsedDate = DateTime.parse(newDate);
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
        'title': newTitle,
        'description': newDescription,
        'taskDate': newDate,
        'date': Timestamp.fromDate(parsedDate),
        'status': newStatus,
        'priority': newPriority
      });
    } catch (e) {
      throw Exception("Error al actualizar la tarea: $e");
    }
  }

  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({'status': newStatus});
    } catch (e) {
      throw Exception("Error al actualizar estado: $e");
    }
  }
}
