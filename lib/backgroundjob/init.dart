import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:dachstein_pistes/logging/init.dart'  as lg;
import 'package:logging/logging.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:dachstein_pistes/db/init.dart';
import 'package:dachstein_pistes/db/model.dart';
import 'package:dachstein_pistes/notification/init.dart' as notification;
import 'package:dachstein_pistes/widgets/init.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

Future<void> job() async {
  final Logger logger = Logger("DachsteinPistesJobLogger");
  lg.init(logger);

  try {
    logger.info(
        "job started: MainPageState.instanceSet=${MainPageState.instanceSet} "
            "isolate=${Isolate.current.hashCode} "
            "pid=$pid");

    // fetch db state
    AppSettings appSettings = await get();

    // fetch web state
    const url =
        'https://www.derdachstein.at/de/dachstein-aktuell/gletscherbericht';
    http.Response httpResponse = MainPageState.response ?? await http.get(
        Uri.parse(url));
    logger.info(
        "response was ${httpResponse.body.substring(0, 100)} (rest truncated)");
    if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
      var document = parse(httpResponse.body);
      var table = document
          .getElementById('accordion-pisten-dachstein')!
          .querySelector('table');
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
          bool currentPisteNotification =
          getPisteNotification(appSettings, currentPisteName);
          var oldPiste = appSettings.pistes.firstWhere(
                (element) => element.name == currentPisteName,
            orElse: () {
              return Piste(
                  name: currentPisteName,
                  state: "unknown",
                  notification: false);
            },
          );
          var currentPiste = Piste(
              name: currentPisteName,
              state: currentPisteState,
              notification: currentPisteNotification);

          // and detect diff "web state" to "fetch db state"
          logger.info("detect diff");
          if (oldPiste.state != currentPiste.state &&
              currentPiste.notification) {
            logger.info("notification: Piste $currentPisteName changed from state "
                "${oldPiste.state} to ${currentPiste.state}!");
            notification.displayNotification(
                title: "Dachstein Piste State Changed",
                body: "${currentPiste.name} changed to ${currentPiste.state}");
          }

          // update db
          logger.info("prepare update db");
          appSettings.pistes
              .removeWhere((element) => element.name == currentPisteName);
          appSettings.pistes.insert(0, currentPiste);
          appSettings.refreshSettings.last = DateTime.now().toString();
        }
        counter++;
      }
      logger.info("update db");
      logger.info("date=${appSettings.refreshSettings.last}");
      await set(appSettings);

      // notify main thread (ui)
      logger.info("notifyMainThread");
      notifyMainThread();
      logger.info("job finished successfully");
    } else {
      throw Exception("http get for url $url returned status "
          "${httpResponse.statusCode} and "
          "content ${httpResponse.body}");
    }
  } catch (e) {
    logger.warning("job failed with error ${e.toString()}");
  }
}

bool getPisteNotification(AppSettings appSettings, String pisteName) {
  return appSettings.pistes
      .firstWhere((element) => element.name == pisteName,
          orElse: () => Piste(
              name: null.toString(), state: 'unknown', notification: false))
      .notification;
}

void notifyMainThread() {
  // instance actually can be null if run through AlarmManager because
  // it has no ui and no ui state,
  // which is the main use case for this method!
  if (MainPageState.instanceSet) {
    SendPort sendPort = MainPageState.instance.getSendPort();
    sendPort.send(true);
  }
}

init() async {
  await AndroidAlarmManager.initialize();
  const int alarmID = 0;
  AppSettings appSettings = await get();
  int interval = appSettings.refreshSettings.interval;

  if (interval != 0) {
    // schedule new
    await AndroidAlarmManager.periodic(
        Duration(minutes: interval),
        alarmID,
        job,
        allowWhileIdle: true,
        wakeup: true,
        rescheduleOnReboot: true);
  } else {
    // delete old
    try {
      AndroidAlarmManager.cancel(alarmID);
    } catch (_) {
      lg.logger.info("error cancelling alarm with id $alarmID");
    }

  }
}
