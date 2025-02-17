import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_app/main.dart';

Future<void> scheduleTaskNotifications(String taskTitle, DateTime createdAt, int notificationId) async {
  final now = DateTime.now();
  DateTime notificationTime = createdAt.add(const Duration(seconds: 20));

  if (notificationTime.isBefore(now)) return;

  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'task_channel',
    'Recordatorio de Tareas',
    channelDescription: 'Notificaciones de recordatorio para tareas',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    notificationId,
    'Tarea pendiente 📝',
    'No olvides completar "$taskTitle".',
    tz.TZDateTime.from(notificationTime, tz.local),
    platformChannelSpecifics,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
}
