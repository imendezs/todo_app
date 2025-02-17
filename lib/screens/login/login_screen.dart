import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/theme_provider.dart';
import 'package:todo_app/screens/home/home_screen.dart';
import 'package:todo_app/widgets/app_colors.dart';
import 'package:todo_app/widgets/login/user_form.dart';
import 'package:todo_app/widgets/logo_with_title.dart';
import 'package:todo_app/screens/login/register_screen.dart';
import 'package:todo_app/services/login/auth_login.dart';
import 'package:todo_app/widgets/login/login_button.dart';
import 'package:todo_app/widgets/responsive_helper.dart';
import 'package:todo_app/widgets/snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthLogin _auth = AuthLogin();
  String? correo;
  String? password;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.colorOne,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.colorOne,
        surfaceTintColor: AppColors.colorOne,
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme(context);
            },
          ),
          SizedBox(width: responsive.spacingSmall)
        ],
      ),
      body: LogoWithTitle(
        title: "To-Do App",
        children: [
          AuthForm(
            formKey: _formKey,
            onSavedCorreo: (value) => correo = value,
            onSavedPassword: (value) => password = value,
          ),
          SizedBox(height: responsive.spacingMedium),
          LoginButton(
            text: "Iniciar Sesión",
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                if (correo == null || correo!.isEmpty || password == null || password!.isEmpty) {
                  showCustomSnackBar(
                    context,
                    message: 'Por favor ingresa correo y contraseña',
                    colorPrincipal: AppColors.alertAmber,
                    colorIcon: Colors.white.withOpacity(0.8),
                    borderColor: AppColors.alertAmber,
                    icon: Icons.warning,
                  );
                  return;
                }

                var result = await _auth.signInEmailAndPassword(correo!, password!);

                if (result == 1 || result == 2 || result == 3 || result == 4) {
                  showCustomSnackBar(
                    context,
                    message: 'Usuario o contraseña incorrectos',
                    colorPrincipal: AppColors.alertRed,
                    colorIcon: Colors.white.withOpacity(0.8),
                    borderColor: AppColors.alertRed,
                    icon: Icons.error,
                  );
                } else if (result != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }
              } else {
                print("El formulario no es válido");
              }
            },
          ),
          SizedBox(height: responsive.containerHeightSmall * 0.5),
          InkWell(
            highlightColor: AppColors.colorOne,
            onTap: () async {
              var user = await _auth.singInWithGoogle();
              if (user != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              } else {
                showCustomSnackBar(
                  context,
                  message: 'Error al iniciar sesión con Google',
                  colorPrincipal: AppColors.alertRed,
                  colorIcon: Colors.white.withOpacity(0.8),
                  borderColor: AppColors.alertRed,
                  icon: Icons.error,
                );
              }
            },
            child: Container(
              width: responsive.containerWidthSmall * 2,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppColors.colorOne,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 1, color: AppColors.subtitle2.withOpacity(0.2))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    'http://pngimg.com/uploads/google/google_PNG19635.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: responsive.spacingSmall),
                  Text(
                    'Iniciar con Google',
                    style: TextStyle(fontSize: responsive.textSmall, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: responsive.containerHeightSmall * 0.5),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return FutureBuilder(
                      future: Future.delayed(Duration(milliseconds: 600)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Container(color: AppColors.colorOne);
                        }
                        return RegisterScreen();
                      },
                    );
                  },
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Text.rich(
              TextSpan(
                text: "¿No tienes cuenta? ",
                style: TextStyle(color: AppColors.subtitle, fontSize: responsive.textSmall),
                children: [
                  TextSpan(
                    text: "Regístrate",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.colorTwo,
                      fontSize: responsive.textSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
