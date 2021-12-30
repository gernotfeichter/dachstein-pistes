import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// based on 9.1.5
// https://pub.dev/packages/flutter_local_notifications#%EF%B8%8F-android-setup
init() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to
// the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');
  const IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  const MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
}
void onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) {
}

void selectNotification(String? payload) {
}
