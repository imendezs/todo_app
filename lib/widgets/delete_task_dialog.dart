import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/delete_task_provider.dart';
import 'package:todo_app/widgets/app_colors.dart';
import 'package:todo_app/widgets/home/modal_text_button.dart';
import 'package:todo_app/widgets/responsive_helper.dart';

class DeleteTaskDialog extends StatelessWidget {
  final String taskId;
  final String title;
  final String description;
  final String createdAt;
  final String taskDate;

  DeleteTaskDialog({
    required this.taskId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.taskDate,
  });

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<DeleteTaskProvider>(context);
    final responsive = ResponsiveHelper(context);

    return Dialog(
      backgroundColor: AppColors.colorOne,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(responsive.borderRadiusMedium)),
      child: Padding(
        padding: EdgeInsets.all(responsive.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Eliminar Tarea",
              style: TextStyle(
                fontSize: responsive.textMedium,
                fontWeight: FontWeight.bold,
                color: AppColors.colorThree.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: responsive.spacingSmall),
            Text(
              "¿Estás seguro de eliminar la tarea?",
              style: TextStyle(
                fontSize: responsive.textSmall,
                color: AppColors.subtitle,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: responsive.spacingLarge),
            Container(
              padding: EdgeInsets.all(responsive.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.colorOne == Colors.white
                    ? Colors.black.withOpacity(0.05)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(responsive.borderRadiusMedium),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: responsive.textMedium,
                            fontWeight: FontWeight.w600,
                            color: AppColors.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(width: responsive.spacingMedium),
                      Expanded(
                        child: Text(
                          taskDate,
                          style: TextStyle(
                            fontSize: responsive.textSmall,
                            color: AppColors.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.spacingSmall),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: responsive.textSmall,
                      fontWeight: FontWeight.w300,
                      color: AppColors.subtitle,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.spacingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ModalTextButton(
                  text: "Cancelar",
                  onPressed: () => Navigator.pop(context),
                  foregroundColor: AppColors.colorThree.withOpacity(0.5),
                  borderRadius: responsive.borderRadiusSmall,
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.paddingMedium,
                    vertical: responsive.paddingSmall,
                  ),
                ),
                ModalTextButton(
                  text: "Eliminar",
                  onPressed: taskProvider.isButtonDisabled
                      ? null
                      : () async {
                          await taskProvider.deleteTask(taskId, context);
                          Navigator.pop(context);
                        },
                  foregroundColor: AppColors.colorFour.withOpacity(0.8),
                  backgroundColor: AppColors.alertRed,
                  isLoading: taskProvider.isButtonDisabled,
                  borderRadius: responsive.borderRadiusSmall,
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.paddingMedium,
                    vertical: responsive.paddingSmall,
                  ),
                  fontSize: responsive.textSmall,
                  loadingSize: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
