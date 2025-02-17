import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteTaskService {
  Future<void> deleteTask(String taskId) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
    } catch (e) {
      throw Exception("Error al eliminar tarea: $e");
    }
  }
}
