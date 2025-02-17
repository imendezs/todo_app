import 'package:flutter/material.dart';
import 'package:todo_app/widgets/app_colors.dart';
import 'package:todo_app/widgets/responsive_helper.dart';

class DynamicFloatingButton extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const DynamicFloatingButton({
    super.key,
    required this.labelText,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    return FloatingActionButton.extended(
      label: Row(
        children: [
          Icon(
            icon,
            color: AppColors.colorFour.withOpacity(0.8),
          ),
          const SizedBox(width: 8),
          Text(labelText,
              style: TextStyle(color: AppColors.colorFour.withOpacity(0.8), fontSize: responsive.textSmall * 1.1)),
        ],
      ),
      backgroundColor: color,
      onPressed: onPressed,
    );
  }
}
