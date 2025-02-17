import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/providers/add_task_provider.dart';
import 'package:todo_app/providers/delete_task_provider.dart';
import 'package:todo_app/providers/filter_task_provider.dart';
import 'package:todo_app/providers/theme_provider.dart';
import 'package:todo_app/providers/update_task_status_provider.dart';
import 'package:todo_app/screens/home/home_screen.dart';
import 'package:todo_app/screens/login/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todo_app/widgets/app_colors.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('es_ES', null);
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Bogota'));
  await _initializeNotifications();
  runApp(const MyApp());
}

Future<void> _initializeNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  final initSettings = InitializationSettings(android: androidSettings);
  await flutterLocalNotificationsPlugin.initialize(initSettings);
  final androidImpl =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  if (androidImpl != null) {
    await androidImpl.requestNotificationsPermission();
    final exactAllowed = await androidImpl.requestExactAlarmsPermission();
    if (exactAllowed != true) {
      print("Exact alarms permission not granted.");
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AddTaskProvider()),
        ChangeNotifierProvider(create: (_) => UpdateTaskStatusProvider()),
        ChangeNotifierProvider(create: (_) => DeleteTaskProvider()),
        ChangeNotifierProvider(create: (_) => FilterTaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          AppColors.initializeColors(themeProvider.themeMode);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ToDo Task',
            theme: ThemeData.light().copyWith(
              scaffoldBackgroundColor: AppColors.colorOne,
            ),
            darkTheme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: AppColors.colorOne,
            ),
            themeMode: themeProvider.themeMode,
            home: _handleAuth(),
          );
        },
      ),
    );
  }

  Widget _handleAuth() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null ? const HomeScreen() : LoginScreen();
  }
}
