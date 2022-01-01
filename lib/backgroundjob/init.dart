import 'dart:developer';
import 'dart:isolate';
import 'package:dachstein_pistes/db/init.dart';
import 'package:dachstein_pistes/db/model.dart';
import 'package:dachstein_pistes/notification/init.dart' as notification;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

Future<void> job() async { // TODO Gernot callback handle
  // fetch db state
  AppSettings appSettings = await get();

  // fetch web state
  const url =
      'https://www.derdachstein.at/de/dachstein-aktuell/gletscherbericht';
  final int isolateId = Isolate.current.hashCode;
  http.Response httpResponse =
  await
  http.get(Uri.parse(
      url));
  if (httpResponse.statusCode >= 200 &&
      httpResponse.statusCode < 300) {
    var document = parse(httpResponse.body);
    var table = document.getElementById('accordion-pisten-dachstein')
    !.querySelector('table');
    var tableData = table!.getElementsByTagName('td');
    var counter = 0;
    String currentPisteState = "unknown";
    for (var element in tableData) {
      if (counter % 4 == 0) {
        if (element.innerHtml.contains("status bg-danger")) {
          currentPisteState = "closed";
        }
        if (element.innerHtml.contains("status bg-success")) {
          currentPisteState = "open";
        }
        if (element.innerHtml.contains("status bg-warning")) {
          currentPisteState = "warning";
        }
      } else if (counter % 4 == 3) {
        var currentPisteName = element.text.trim();
        bool currentPisteNotification = getPisteNotification(
            appSettings,
            currentPisteName
        );
        var oldPiste = appSettings.pistes.firstWhere(
                (element) => element.name == currentPisteName,
                orElse: () {
                  return Piste(
                    name: currentPisteName,
                    state: "unknown",
                    notification: false
                  );
                },
        );
        var currentPiste = Piste(
            name: currentPisteName,
            state: currentPisteState,
            notification: currentPisteNotification
        );

        // and detect diff "web state" to "fetch db state"
        if (oldPiste.state != currentPiste.state &&
            currentPiste.notification) {
          log("notification: Piste $currentPisteName changed from state "
              "${oldPiste.state} to ${currentPiste.state}!");
          notification.displayNotification(
            title: "Dachstein Piste State Changed",
            body: "${currentPiste.name} changed to ${currentPiste.state}");
        }

        // update db
        appSettings.pistes.removeWhere(
                (element) => element.name == currentPisteName);
        appSettings.pistes.insert(0, currentPiste);
        await set(appSettings);
      }
      counter++;
    }
  } else {
    throw Exception("http get for url $url returned status "
        "${httpResponse.statusCode} and "
        "content ${httpResponse.body}");
  }
}

bool getPisteNotification(AppSettings appSettings, String pisteName) {
  return appSettings.pistes
      .firstWhere(
          (element) => element.name == pisteName,
      orElse: () =>
          Piste(
              name: null.toString(),
              state: 'unknown',
              notification: false))
      .notification;
}

init() async {
  await AndroidAlarmManager.initialize();
  const int alarmID = 0;
  await AndroidAlarmManager.periodic(
      const Duration(days: 1), alarmID, job);
}
