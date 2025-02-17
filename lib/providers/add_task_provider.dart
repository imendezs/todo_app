import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/notification_service.dart';

class AddTaskProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isButtonDisabled = false;

  bool get isButtonDisabled => _isButtonDisabled;

  void setButtonDisabled(bool state) {
    _isButtonDisabled = state;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    try {
      final String title = task.title;
      final String description = task.description;

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception("No hay usuario autenticado");
      }
      DateTime createdAt = DateTime.now();
      final Map<String, dynamic> taskData = {
        'title': title,
        'description': description,
        'status': task.status,
        'date': Timestamp.fromDate(task.date),
        'priority': task.priority,
        'createdAt': createdAt,
        'uid': user.uid,
      };
      DocumentReference docRef = await FirebaseFirestore.instance.collection("tasks").add(taskData);
      await scheduleTaskNotifications(title, createdAt, docRef.id.hashCode);
    } catch (error) {
      print("Error al agregar tarea: $error");
    }
  }
}
