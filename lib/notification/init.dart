import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';

// based on 9.1.5
// https://pub.dev/packages/flutter_local_notifications#%EF%B8%8F-android-setup
Future<FlutterLocalNotificationsPlugin> init() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to
// the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('dachstein_piste_notification_icon');
  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  return flutterLocalNotificationsPlugin;
}

void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
}

void selectNotification(String? payload) {
}

void displayNotification({String title = "", String body = ""}) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    await init();
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails('dachstein_pistes', 'piste_state_changed',
      channelDescription: 'Dachstein piste state changed notifications',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      ticker: null);
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);
  var rng = Random();
  await flutterLocalNotificationsPlugin.show(
      rng.nextInt(100000), title, body, platformChannelSpecifics,
      payload: null);
}