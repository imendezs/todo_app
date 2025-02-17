import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/widgets/app_colors.dart';
import 'package:todo_app/widgets/snackbar.dart';

class DeleteTaskProvider extends ChangeNotifier {
  bool _isButtonDisabled = false;

  bool get isButtonDisabled => _isButtonDisabled;

  void setButtonDisabled(bool state) {
    _isButtonDisabled = state;
    notifyListeners();
  }

  Future<void> deleteTask(String taskId, BuildContext context) async {
    try {
      setButtonDisabled(true);
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();

      showCustomSnackBar(
        context,
        message: "Tarea eliminada exitosamente",
        colorPrincipal: AppColors.alertGreen,
        colorIcon: AppColors.colorOne,
        borderColor: AppColors.alertGreen,
        icon: Icons.check_circle,
      );
    } catch (e) {
      showCustomSnackBar(
        context,
        message: "Error al eliminar tarea",
        colorPrincipal: AppColors.alertRed,
        colorIcon: AppColors.colorOne,
        borderColor: AppColors.alertRed,
        icon: Icons.error,
      );
    } finally {
      setButtonDisabled(false);
    }
  }
}
