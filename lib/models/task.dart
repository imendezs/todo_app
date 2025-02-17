import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String title;
  final String description;
  final String status;
  final DateTime date;
  final String userId;
  final String priority;

  Task({
    required this.title,
    required this.description,
    required this.status,
    required this.date,
    required this.userId,
    required this.priority,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'date': date,
      'userId': userId,
      'priority': priority,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
