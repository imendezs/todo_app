import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/filter_task_provider.dart';
import 'package:todo_app/widgets/app_colors.dart';
import 'package:todo_app/widgets/responsive_helper.dart';

class TaskFilterButton extends StatefulWidget {
  const TaskFilterButton({Key? key}) : super(key: key);

  @override
  _TaskFilterButtonState createState() => _TaskFilterButtonState();
}

class _TaskFilterButtonState extends State<TaskFilterButton> {
  late List<String> tempSelectedStatuses;
  late List<String> tempSelectedPriorities;

  @override
  void initState() {
    super.initState();
    final filterProvider = Provider.of<FilterTaskProvider>(context, listen: false);
    tempSelectedStatuses = List.from(filterProvider.selectedStatuses);
    tempSelectedPriorities = List.from(filterProvider.selectedPriorities);
  }

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterTaskProvider>(context);
    int totalFilters = filterProvider.selectedStatuses.length + filterProvider.selectedPriorities.length;
    final responsive = ResponsiveHelper(context);

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.colorTwo,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        minimumSize: const Size(0, 30),
      ),
      onPressed: _showFilterDialog,
      icon: Icon(Icons.filter_list, color: AppColors.colorFour.withOpacity(0.8), size: 18),
      label: Text(
        totalFilters > 0 ? "Filtros ($totalFilters)" : "Filtros",
        style: TextStyle(color: AppColors.colorFour.withOpacity(0.8), fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  void _showFilterDialog() {
    final filterProvider = Provider.of<FilterTaskProvider>(context, listen: false);
    tempSelectedStatuses = List.from(filterProvider.selectedStatuses);
    tempSelectedPriorities = List.from(filterProvider.selectedPriorities);
    final responsive = ResponsiveHelper(context);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: AppColors.colorOne,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              textAlign: TextAlign.center,
              "Filtrar Tareas",
              style: TextStyle(
                fontSize: responsive.textMedium,
                fontWeight: FontWeight.bold,
                color: AppColors.title,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFilterSection(
                    "Estado",
                    ["Pendiente", "Completada"],
                    tempSelectedStatuses,
                    setStateDialog,
                  ),
                  const Divider(),
                  _buildFilterSection(
                    "Prioridad",
                    ["Alta", "Media", "Baja"],
                    tempSelectedPriorities,
                    setStateDialog,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setStateDialog(() {
                    tempSelectedStatuses.clear();
                    tempSelectedPriorities.clear();
                  });
                },
                child: const Text("Restablecer", style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorTwo,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                onPressed: () {
                  filterProvider.updateStatuses(tempSelectedStatuses);
                  filterProvider.updatePriorities(tempSelectedPriorities);
                  Navigator.pop(context);
                },
                child: Text("Aplicar", style: TextStyle(color: AppColors.colorOne, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _buildFilterSection(String title, List<String> options, List<String> selectedList, Function setStateDialog) {
    final responsive = ResponsiveHelper(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(color: AppColors.title, fontSize: responsive.textSmall, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: options.map((option) {
            bool isSelected = selectedList.contains(option);
            return GestureDetector(
              onTap: () {
                setStateDialog(() {
                  if (isSelected) {
                    selectedList.remove(option);
                  } else {
                    selectedList.add(option);
                  }
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: EdgeInsets.symmetric(vertical: responsive.paddingSmall, horizontal: responsive.paddingLarge),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.colorTwo : AppColors.colorThree.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.colorOne : AppColors.subtitle,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
