import 'package:flutter/material.dart';
import 'package:todo_app/screens/login/login_screen.dart';
import 'package:todo_app/services/login/auth_login.dart';
import 'package:todo_app/widgets/app_colors.dart';
import 'package:todo_app/widgets/login/user_form.dart';
import 'package:todo_app/widgets/logo_with_title.dart';
import 'package:todo_app/widgets/login/login_button.dart';
import 'package:todo_app/widgets/responsive_helper.dart';
import 'package:todo_app/widgets/snackbar.dart';

class RegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final AuthLogin _auth = AuthLogin();

  String? correo;
  String? password;

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorOne,
      ),
      backgroundColor: AppColors.colorOne,
      body: LogoWithTitle(
        title: "To-Do List",
        children: [
          AuthForm(
            formKey: _formKey,
            onSavedCorreo: (value) => correo = value,
            onSavedPassword: (value) => password = value,
          ),
          SizedBox(height: responsive.spacingMedium),
          LoginButton(
            text: "Registrar",
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                var result = await _auth.createAcount(correo ?? "", password ?? "");

                if (result == 1) {
                  showCustomSnackBar(
                    context,
                    message: "La contraseña es muy débil",
                    colorPrincipal: AppColors.alertAmber,
                    colorIcon: Colors.white.withOpacity(0.8),
                    borderColor: AppColors.alertAmber,
                    icon: Icons.warning,
                  );
                } else if (result == 2) {
                  showCustomSnackBar(
                    context,
                    message: "Este correo ya está registrado",
                    colorPrincipal: AppColors.alertRed,
                    colorIcon: Colors.white.withOpacity(0.8),
                    borderColor: AppColors.alertRed,
                    icon: Icons.error,
                  );
                } else if (result != null) {
                  showCustomSnackBar(
                    context,
                    message: "Registro exitoso. Puede iniciar sesión para acceder a su cuenta.",
                    colorPrincipal: AppColors.alertGreen,
                    colorIcon: Colors.white.withOpacity(0.8),
                    borderColor: AppColors.alertGreen,
                    icon: Icons.check_circle,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } else {
                  showCustomSnackBar(
                    context,
                    message: "Error desconocido al registrar usuario",
                    colorPrincipal: Colors.grey.shade600,
                    colorIcon: Colors.white.withOpacity(0.8),
                    borderColor: Colors.grey,
                    icon: Icons.error_outline,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
