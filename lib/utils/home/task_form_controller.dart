import 'package:flutter/material.dart';

class TaskFormController {
  final TextEditingController dateController;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  String selectedStatus;
  String selectedPriority;

  TaskFormController({
    String? title,
    String? description,
    String? date,
    String? status,
    String? priority,
  })  : titleController = TextEditingController(text: title ?? ""),
        descriptionController = TextEditingController(text: description ?? ""),
        dateController = TextEditingController(text: date ?? ""),
        selectedStatus = status ?? "Pendiente",
        selectedPriority = priority ?? "Alta";

  void dispose() {
    dateController.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }
}
