import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/filter_task_provider.dart';
import 'package:todo_app/widgets/app_colors.dart';
import 'package:todo_app/widgets/home/task_card.dart';
import 'package:todo_app/widgets/responsive_helper.dart';

class TaskList extends StatefulWidget {
  final Stream<QuerySnapshot> taskStream;

  const TaskList({super.key, required this.taskStream});

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterTaskProvider>(context);
    final responsive = ResponsiveHelper(context);

    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            key: ValueKey(DateTime.now().millisecondsSinceEpoch),
            stream: widget.taskStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: AppColors.colorTwo,
                  color: AppColors.colorOne,
                ));
              }

              if (snapshot.hasError) {
                return const Center(child: Text("Error al cargar las tareas."));
              }

              final tasks = snapshot.data?.docs ?? [];
              final filteredTasks = tasks.where((doc) {
                final task = doc.data() as Map<String, dynamic>;
                bool statusMatch =
                    filterProvider.selectedStatuses.isEmpty || filterProvider.selectedStatuses.contains(task['status']);
                bool priorityMatch = filterProvider.selectedPriorities.isEmpty ||
                    filterProvider.selectedPriorities.contains(task['priority']);
                return statusMatch && priorityMatch;
              }).toList();

              if (filteredTasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.library_add_check_outlined,
                        color: AppColors.colorThree.withOpacity(0.1),
                        size: responsive.iconLogo * 1.3,
                      ),
                      Text(
                        "No hay tareas existentes",
                        style: TextStyle(
                            fontSize: responsive.textExtraLarge,
                            color: AppColors.colorThree.withOpacity(0.1),
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                );
              }

              return ListView.builder(
                key: ValueKey(filteredTasks.length),
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index].data() as Map<String, dynamic>;

                  String formattedCreatedAt = _formatTimestamp(task['createdAt']);
                  String formattedDate = _formatTimestamp(task['date']);

                  return TaskCard(
                    key: ValueKey(task['title'] + task['status']),
                    title: task['title'],
                    description: task['description'],
                    status: task['status'],
                    priority: task['priority'],
                    colorStatus: task['status'] == 'Completada' ? AppColors.colorTwo : AppColors.alertAmber,
                    colorPriority: task['priority'] == 'Alta'
                        ? AppColors.alertRed
                        : task['priority'] == 'Media'
                            ? AppColors.alertAmber
                            : AppColors.colorTwo,
                    createdAt: formattedCreatedAt,
                    taskDate: formattedDate,
                    taskId: filteredTasks[index].id,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Fecha no disponible";
    DateTime date = timestamp.toDate();
    return DateFormat('dd MMMM yyyy', 'es_ES').format(date);
  }
}
