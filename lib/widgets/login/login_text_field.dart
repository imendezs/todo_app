import 'package:flutter/material.dart';
import 'package:todo_app/widgets/app_colors.dart';
import 'package:todo_app/widgets/responsive_helper.dart';

class LoginTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final Function(String?)? onSaved;

  const LoginTextField({
    Key? key,
    required this.hintText,
    this.obscureText = false,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.spacingSmall),
      child: TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.subtitle, fontSize: responsive.textMedium),
          filled: true,
          fillColor: AppColors.colorTwo.withOpacity(0.06),
          contentPadding: EdgeInsets.symmetric(
            horizontal: responsive.paddingMedium,
            vertical: responsive.paddingMedium,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(responsive.borderRadiusLarge)),
          ),
        ),
        onSaved: onSaved,
      ),
    );
  }
}
