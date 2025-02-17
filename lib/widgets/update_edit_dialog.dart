import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/update_task_status_provider.dart';
import 'package:todo_app/widgets/home/modal_text_button.dart';
import 'package:todo_app/widgets/home/task_form.dart';
import 'package:todo_app/services/update_task_service.dart';
import 'package:todo_app/utils/home/task_form_controller.dart';
import 'package:todo_app/widgets/app_colors.dart';
import 'package:todo_app/widgets/responsive_helper.dart';

class TaskEditDialog extends StatefulWidget {
  final String taskId;
  final String title;
  final String description;
  final String createdAt;
  final String taskDate;
  final String currentStatus;
  final String priority;
  final Color color;

  TaskEditDialog(
      {required this.taskId,
      required this.title,
      required this.description,
      required this.createdAt,
      required this.taskDate,
      required this.currentStatus,
      required this.priority,
      required this.color});

  @override
  _TaskEditDialogState createState() => _TaskEditDialogState();
}

class _TaskEditDialogState extends State<TaskEditDialog> {
  late TaskFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TaskFormController(
        title: widget.title,
        description: widget.description,
        date: widget.taskDate,
        status: widget.currentStatus,
        priority: widget.priority);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<UpdateTaskStatusProvider>(context);
    final responsive = ResponsiveHelper(context);

    return Dialog(
      backgroundColor: AppColors.colorOne,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(responsive.borderRadiusMedium)),
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(responsive.paddingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Editar Tarea",
                style: TextStyle(
                  fontSize: responsive.textMedium,
                  fontWeight: FontWeight.bold,
                  color: AppColors.title,
                ),
              ),
              SizedBox(height: responsive.spacingMedium),
              TaskForm(controller: _controller, checkColor: widget.color),
              SizedBox(height: responsive.spacingMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ModalTextButton(
                    text: "Cancelar",
                    onPressed: () => Navigator.pop(context),
                    foregroundColor: Colors.grey,
                    borderRadius: responsive.borderRadiusSmall,
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.paddingMedium,
                      vertical: responsive.paddingSmall,
                    ),
                  ),
                  ModalTextButton(
                    text: "Guardar",
                    onPressed: taskProvider.isButtonDisabled
                        ? null
                        : () async {
                            taskProvider.setButtonDisabled(true);
                            try {
                              String formattedDate = _formatDate(_controller.dateController.text);
                              await UpdateTaskService().updateTask(
                                widget.taskId,
                                _controller.titleController.text,
                                _controller.descriptionController.text,
                                formattedDate,
                                _controller.selectedStatus,
                                _controller.selectedPriority,
                              );
                            } catch (e) {
                              print("Error al actualizar la tarea: $e");
                            }
                            taskProvider.setButtonDisabled(false);
                            Navigator.pop(context);
                          },
                    foregroundColor: AppColors.colorFour.withOpacity(0.8),
                    backgroundColor: Colors.blue.shade600,
                    isLoading: taskProvider.isButtonDisabled,
                    borderRadius: responsive.borderRadiusSmall,
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.paddingMedium,
                      vertical: responsive.paddingSmall,
                    ),
                    fontSize: responsive.textSmall,
                    loadingSize: responsive.iconSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String date) {
    try {
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date)) {
        return date;
      }
      DateTime parsedDate = DateFormat("dd MMMM yyyy", "es_ES").parse(date);
      String formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);
      return formattedDate;
    } catch (e) {
      return date;
    }
  }
}
