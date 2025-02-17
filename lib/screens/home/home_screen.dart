import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/theme_provider.dart';
import 'package:todo_app/services/home/task_service.dart';
import 'package:todo_app/widgets/app_bar.dart';
import 'package:todo_app/widgets/app_colors.dart';
import 'package:todo_app/widgets/floating_button.dart';
import 'package:todo_app/widgets/home/add_task/add_task_dialog.dart';
import 'package:todo_app/widgets/home/task_filter_button.dart';
import 'package:todo_app/widgets/home/task_list.dart';
import 'package:todo_app/widgets/responsive_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        AppColors.initializeColors(themeProvider.themeMode);
        final user = FirebaseAuth.instance.currentUser!;
        final taskService = TaskService();
        final responsive = ResponsiveHelper(context);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.colorOne,
          appBar: const CustomAppBar(),
          body: Padding(
            padding: EdgeInsets.only(top: responsive.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(responsive.paddingMedium),
                  child: Row(
                    children: [
                      Text(
                        "Lista de tareas",
                        style: TextStyle(
                          fontSize: responsive.textLarge,
                          fontWeight: FontWeight.w500,
                          color: AppColors.title,
                        ),
                      ),
                      const Spacer(),
                      const TaskFilterButton(),
                    ],
                  ),
                ),
                Expanded(
                  child: TaskList(
                    taskStream: taskService.getUserTasks(user.uid),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: DynamicFloatingButton(
            labelText: "Agregar tarea",
            icon: Icons.task_alt_rounded,
            color: AppColors.colorTwo,
            onPressed: () {
              showModal(
                configuration: FadeScaleTransitionConfiguration(
                  transitionDuration: const Duration(milliseconds: 800),
                  reverseTransitionDuration: const Duration(milliseconds: 500),
                ),
                context: context,
                builder: (context) => const AddTaskDialog(),
              );
            },
          ),
        );
      },
    );
  }
}
