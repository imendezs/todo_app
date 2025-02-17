import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/theme_provider.dart';
import 'package:todo_app/screens/login/login_screen.dart';
import 'package:todo_app/widgets/app_colors.dart';
import 'package:todo_app/widgets/responsive_helper.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final responsive = ResponsiveHelper(context);

    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      AppColors.initializeColors(themeProvider.themeMode);

      return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.colorOne,
        surfaceTintColor: AppColors.colorOne,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.paddingMedium),
            child: Row(
              children: [
                CircleAvatar(
                  radius: responsive.iconMedium,
                  backgroundColor: AppColors.colorTwo.withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    color: AppColors.colorTwo,
                    size: responsive.iconMedium,
                  ),
                ),
                SizedBox(width: responsive.spacingSmall),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: TextStyle(
                      color: AppColors.subtitle,
                      fontSize: responsive.textSmall,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(text: "${user?.displayName ?? "Usuario"}\n"),
                      TextSpan(
                        text: user?.email ?? "Sin correo",
                        style: TextStyle(fontSize: responsive.textSmall, color: AppColors.subtitle2),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.paddingMedium),
            child: IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: AppColors.alertRed,
                size: responsive.iconMedium,
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
