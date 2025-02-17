import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/services/update_task_service.dart';
import 'package:todo_app/widgets/app_colors.dart';
import 'package:todo_app/widgets/delete_task_dialog.dart';
import 'package:todo_app/widgets/responsive_helper.dart';
import 'package:todo_app/widgets/snackbar.dart';
import 'package:todo_app/widgets/update_edit_dialog.dart';

class TaskCard extends StatefulWidget {
  final String title;
  final String description;
  final String status;
  final String priority;
  final Color colorStatus;
  final Color colorPriority;
  final String createdAt;
  final String taskDate;
  final String taskId;

  const TaskCard({
    Key? key,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.colorStatus,
    required this.colorPriority,
    required this.createdAt,
    required this.taskDate,
    required this.taskId,
  }) : super(key: key);

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late String currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Dismissible(
      key: Key(widget.taskId),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          setState(() {
            currentStatus = 'Completada';
          });
          try {
            await UpdateTaskService().updateTaskStatus(widget.taskId, 'Completada');
            showCustomSnackBar(
              context,
              message: "Tarea marcada como completada",
              colorPrincipal: AppColors.alertGreen,
              colorIcon: Colors.white.withOpacity(0.8),
              borderColor: AppColors.alertGreen,
              icon: Icons.check_circle,
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al actualizar estado: $e')),
            );
          }
        } else if (direction == DismissDirection.endToStart) {
          setState(() {
            currentStatus = 'Pendiente';
          });
          try {
            await UpdateTaskService().updateTaskStatus(widget.taskId, 'Pendiente');
            showCustomSnackBar(
              context,
              message: "Tarea marcada como pendiente",
              colorPrincipal: AppColors.alertGreen,
              colorIcon: Colors.white.withOpacity(0.8),
              borderColor: AppColors.alertGreen,
              icon: Icons.check_circle,
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al actualizar estado: $e')),
            );
          }
        }
        return false;
      },
      background: Container(
        padding: EdgeInsets.all(responsive.paddingMedium),
        margin: EdgeInsets.symmetric(horizontal: responsive.paddingMedium, vertical: responsive.paddingSmall),
        decoration: BoxDecoration(
          color: AppColors.alertGreen.withOpacity(0.3),
          borderRadius: BorderRadius.circular(responsive.borderRadiusMedium),
        ),
        alignment: Alignment.centerLeft,
        child: Icon(Icons.check_circle, color: AppColors.alertGreen),
      ),
      secondaryBackground: Container(
        padding: EdgeInsets.all(responsive.paddingMedium),
        margin: EdgeInsets.symmetric(horizontal: responsive.paddingMedium, vertical: responsive.paddingSmall),
        decoration: BoxDecoration(
          color: AppColors.alertAmber.withOpacity(0.3),
          borderRadius: BorderRadius.circular(responsive.borderRadiusMedium),
        ),
        alignment: Alignment.centerRight,
        child: Icon(Icons.pending, color: AppColors.alertAmber),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: responsive.spacingSmall,
          horizontal: responsive.spacingMedium,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.colorThree.withOpacity(0.02),
            borderRadius: BorderRadius.circular(responsive.borderRadiusMedium),
          ),
          child: Padding(
            padding: EdgeInsets.all(responsive.paddingMedium),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: responsive.textMedium * 0.9,
                                fontWeight: FontWeight.w600,
                                color: AppColors.title,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: responsive.spacingLarge),
                          Text(
                            widget.taskDate,
                            style: TextStyle(
                              fontSize: responsive.textSmall,
                              color: AppColors.subtitle,
                            ),
                          ),
                          SizedBox(width: responsive.spacingSmall),
                        ],
                      ),
                      SizedBox(height: responsive.spacingSmall),
                      Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Text(
                              widget.description,
                              style: TextStyle(
                                fontSize: responsive.textSmall,
                                fontWeight: FontWeight.w400,
                                color: AppColors.subtitle2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(flex: 4, child: Container()),
                        ],
                      ),
                      SizedBox(height: responsive.spacingSmall * 1.5),
                      Row(
                        children: [
                          Container(
                            constraints: BoxConstraints(minWidth: responsive.containerWidthSmall * 0.7),
                            padding: EdgeInsets.symmetric(
                              vertical: responsive.paddingSmall * 0.3,
                            ),
                            decoration: BoxDecoration(
                              color: currentStatus == 'Completada' ? AppColors.alertGreen : AppColors.alertAmber,
                              borderRadius: BorderRadius.circular(responsive.borderRadiusSmall),
                            ),
                            child: Text(
                              currentStatus,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.colorFour.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.textSmall,
                              ),
                            ),
                          ),
                          SizedBox(width: responsive.spacingSmall),
                          Container(
                            constraints: BoxConstraints(minWidth: responsive.containerWidthSmall * 0.9),
                            padding: EdgeInsets.symmetric(
                              vertical: responsive.paddingSmall * 0.3,
                            ),
                            decoration: BoxDecoration(
                              color: widget.colorPriority,
                              borderRadius: BorderRadius.circular(responsive.borderRadiusSmall),
                            ),
                            child: Text(
                              "Prioridad ${widget.priority}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.colorFour.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.textSmall,
                              ),
                            ),
                          ),
                          Spacer(),
                          _buildIconButton(
                            icon: Icons.edit,
                            color: Colors.blue,
                            onPressed: () {
                              showModal(
                                configuration: FadeScaleTransitionConfiguration(
                                    transitionDuration: Duration(milliseconds: 800),
                                    reverseTransitionDuration: Duration(milliseconds: 500)),
                                context: context,
                                builder: (BuildContext context) {
                                  return TaskEditDialog(
                                    taskId: widget.taskId,
                                    title: widget.title,
                                    description: widget.description,
                                    createdAt: widget.createdAt,
                                    taskDate: widget.taskDate,
                                    currentStatus: widget.status,
                                    priority: widget.priority,
                                    color: Colors.blue,
                                  );
                                },
                              );
                            },
                            responsive: responsive,
                          ),
                          SizedBox(width: responsive.spacingSmall),
                          _buildIconButton(
                            icon: Icons.delete_rounded,
                            color: AppColors.alertRed,
                            onPressed: () {
                              showModal(
                                configuration: FadeScaleTransitionConfiguration(
                                    transitionDuration: Duration(milliseconds: 800),
                                    reverseTransitionDuration: Duration(milliseconds: 500)),
                                context: context,
                                builder: (BuildContext context) {
                                  return DeleteTaskDialog(
                                    taskId: widget.taskId,
                                    title: widget.title,
                                    description: widget.description,
                                    createdAt: widget.createdAt,
                                    taskDate: widget.taskDate,
                                  );
                                },
                              );
                            },
                            responsive: responsive,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required ResponsiveHelper responsive,
  }) {
    return IconButton(
      icon: Icon(
        icon,
        size: responsive.iconSmall * 1.2,
        color: color.withOpacity(0.8),
      ),
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color.withOpacity(0.05)),
      ),
    );
  }
}
