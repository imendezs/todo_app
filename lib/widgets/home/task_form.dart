import 'package:flutter/material.dart';
import 'package:todo_app/utils/home/task_form_controller.dart';
import 'package:todo_app/widgets/app_colors.dart';
import 'package:todo_app/widgets/responsive_helper.dart';

class TaskForm extends StatefulWidget {
  final TaskFormController controller;
  final Color checkColor;

  const TaskForm({super.key, required this.controller, required this.checkColor});

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDateField(context),
          const SizedBox(height: 10),
          _buildTextField(widget.controller.titleController, "Título"),
          const SizedBox(height: 10),
          _buildTextField(widget.controller.descriptionController, "Descripción", maxLines: 3),
          const SizedBox(height: 10),
          _buildStatusAndPrioritySelector(),
        ],
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return TextField(
      controller: widget.controller.dateController,
      decoration: InputDecoration(
        labelText: "Fecha de vencimiento",
        labelStyle: TextStyle(color: AppColors.colorThree.withOpacity(0.5)),
        suffixIcon: Icon(Icons.calendar_month),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.colorThree, width: 2),
        ),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: AppColors.colorOne == Colors.white
                  ? ThemeData.light().copyWith(
                      colorScheme: ColorScheme.light(
                        surface: AppColors.colorOne,
                        primary: AppColors.colorThree,
                        onPrimary: AppColors.colorOne,
                      ),
                    )
                  : ThemeData.dark().copyWith(
                      colorScheme: ColorScheme.dark(
                        surface: AppColors.colorOne,
                        primary: AppColors.colorFour,
                        onPrimary: AppColors.colorOne,
                      ),
                    ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          setState(() {
            widget.controller.dateController.text = pickedDate.toLocal().toString().split(' ')[0];
          });
        }
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      cursorColor: AppColors.colorThree,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.subtitle2),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.colorThree, width: 2),
        ),
      ),
      maxLines: maxLines,
    );
  }

  Widget _buildStatusAndPrioritySelector() {
    final responsive = ResponsiveHelper(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Estado",
                style: TextStyle(
                  fontSize: responsive.textSmall,
                  fontWeight: FontWeight.bold,
                  color: AppColors.subtitle,
                ),
              ),
              _buildStatusTile("Pendiente"),
              _buildStatusTile("Completada"),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Prioridad",
                style: TextStyle(
                  fontSize: responsive.textSmall,
                  fontWeight: FontWeight.bold,
                  color: AppColors.subtitle,
                ),
              ),
              SizedBox(height: responsive.spacingSmall),
              _buildPrioritySelector(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusTile(String status) {
    final responsive = ResponsiveHelper(context);
    return Transform.translate(
      offset: Offset(-10, -4),
      child: RadioListTile(
        contentPadding: EdgeInsets.only(left: 0),
        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        activeColor: widget.checkColor,
        title: Text(
          status,
          style: TextStyle(fontSize: responsive.textSmall),
        ),
        value: status,
        groupValue: widget.controller.selectedStatus,
        onChanged: (value) {
          setState(() {
            widget.controller.selectedStatus = value as String;
          });
        },
      ),
    );
  }

  Widget _buildPrioritySelector() {
    final responsive = ResponsiveHelper(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.subtitle2),
            borderRadius: BorderRadius.circular(8),
            color: AppColors.colorOne,
          ),
          child: DropdownButton<String>(
            value: widget.controller.selectedPriority,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  widget.controller.selectedPriority = newValue;
                });
              }
            },
            items: ["Alta", "Media", "Baja"].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                      color: AppColors.subtitle, fontWeight: FontWeight.bold, fontSize: responsive.textSmall * 0.9),
                ),
              );
            }).toList(),
            icon: Icon(Icons.arrow_drop_down, color: AppColors.subtitle2),
            dropdownColor: AppColors.colorOne,
            underline: SizedBox(),
          ),
        ),
      ],
    );
  }
}
