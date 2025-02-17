import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/providers/add_task_provider.dart';
import 'package:todo_app/services/home/task_service.dart';
import 'package:todo_app/widgets/home/modal_text_button.dart';
import 'package:todo_app/widgets/home/task_form.dart';
import 'package:todo_app/utils/home/task_form_controller.dart';
import 'package:todo_app/widgets/app_colors.dart';
import 'package:todo_app/widgets/responsive_helper.dart';
import 'package:todo_app/widgets/snackbar.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TaskFormController _controller = TaskFormController();
  final TaskService _taskService = TaskService();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateTask(BuildContext context) async {
    final taskProvider = Provider.of<AddTaskProvider>(context, listen: false);

    try {
      if (_controller.dateController.text.isEmpty) {
        showCustomSnackBar(
          context,
          message: "Debe seleccionar una fecha",
          colorPrincipal: AppColors.alertAmber,
          colorIcon: Colors.white.withOpacity(0.8),
          borderColor: AppColors.alertAmber,
          icon: Icons.warning,
        );
        return;
      }

      if (_controller.titleController.text.isEmpty || _controller.descriptionController.text.isEmpty) {
        showCustomSnackBar(
          context,
          message: "Debe rellenar todos los campos",
          colorPrincipal: AppColors.alertAmber,
          colorIcon: Colors.white.withOpacity(0.8),
          borderColor: AppColors.alertAmber,
          icon: Icons.warning,
        );
        return;
      }

      taskProvider.setButtonDisabled(true);

      final task = Task(
        title: _controller.titleController.text,
        description: _controller.descriptionController.text,
        status: _controller.selectedStatus,
        date: DateTime.parse(_controller.dateController.text),
        userId: FirebaseAuth.instance.currentUser?.uid ?? '',
        priority: _controller.selectedPriority,
      );

      await _taskService.saveTask(task, taskProvider);

      showCustomSnackBar(
        context,
        message: "Tarea agregada exitosamente",
        colorPrincipal: AppColors.alertGreen,
        colorIcon: Colors.white.withOpacity(0.8),
        borderColor: AppColors.alertGreen,
        icon: Icons.check_circle,
      );

      Navigator.pop(context);
    } catch (e) {
      showCustomSnackBar(
        context,
        message: "Ocurrió un error al guardar la tarea. Inténtalo nuevamente.",
        colorPrincipal: Colors.grey.shade600,
        colorIcon: Colors.white.withOpacity(0.8),
        borderColor: Colors.grey,
        icon: Icons.error_outline,
      );
    } finally {
      taskProvider.setButtonDisabled(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<AddTaskProvider>(context);
    final responsive = ResponsiveHelper(context);

    return AlertDialog(
      backgroundColor: AppColors.colorOne,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.borderRadiusMedium),
      ),
      contentPadding: EdgeInsets.all(responsive.paddingMedium),
      title: Text(
        textAlign: TextAlign.center,
        "Agregar Tarea",
        style: TextStyle(
          fontSize: responsive.textMedium,
          fontWeight: FontWeight.bold,
          color: AppColors.title,
        ),
      ),
      content: SizedBox(
        width: responsive.containerWidthLarge * 1,
        child: TaskForm(controller: _controller, checkColor: AppColors.alertGreen),
      ),
      actions: [
        ModalTextButton(
          text: "Cancelar",
          onPressed: () => Navigator.pop(context),
          foregroundColor: AppColors.colorThree.withOpacity(0.5),
          borderRadius: responsive.borderRadiusMedium,
          padding: EdgeInsets.symmetric(
            horizontal: responsive.paddingMedium,
            vertical: responsive.paddingSmall,
          ),
        ),
        ModalTextButton(
          text: "Guardar",
          onPressed: taskProvider.isButtonDisabled ? null : () => _validateTask(context),
          foregroundColor: AppColors.colorFour.withOpacity(0.8),
          backgroundColor: AppColors.colorTwo,
          isLoading: taskProvider.isButtonDisabled,
          borderRadius: responsive.borderRadiusSmall,
          padding: EdgeInsets.symmetric(
            horizontal: responsive.paddingMedium,
            vertical: responsive.paddingSmall,
          ),
          fontSize: responsive.textSmall,
        ),
      ],
    );
  }
}
