import 'package:flutter/material.dart';
import 'package:todo_app/widgets/login/login_text_field.dart';

class AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final void Function(String?) onSavedCorreo;
  final void Function(String?) onSavedPassword;

  const AuthForm({
    Key? key,
    required this.formKey,
    required this.onSavedCorreo,
    required this.onSavedPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          LoginTextField(
            hintText: "Correo",
            onSaved: onSavedCorreo,
          ),
          LoginTextField(
            hintText: "Contraseña",
            obscureText: true,
            onSaved: onSavedPassword,
          ),
        ],
      ),
    );
  }
}
