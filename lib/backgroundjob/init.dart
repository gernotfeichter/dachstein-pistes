import 'dart:developer';
import 'dart:isolate';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

Future<void> job() async {
  const url =
      'https://www.derdachstein.at/de/dachstein-aktuell/gletscherbericht';
  final int isolateId = Isolate.current.hashCode;
  http.Response httpResponse =
    await 
    http.get(Uri.parse(
        url));
  if (httpResponse.statusCode >= 200 &&
      httpResponse.statusCode < 300) {
    print("success");
    var document = parse(httpResponse.body);
    var table = document.getElementById('accordion-pisten-dachstein')
      !.querySelector('table');
    var tableData = table!.getElementsByTagName('td');
    var counter = 0;
    for (var element in tableData) {
      if (counter % 4 == 0) {
        print("mod 4: 0 Rest: ${element.innerHtml}");
        // TODO Gernot continue here
      } else if (counter % 4 == 3) {
        print("mod 4: 3 Rest: ${element.text.trim()}");
      }
      counter++;
    }

  } else {
    throw Exception("http get for url $url returned status "
        "${httpResponse.statusCode} and "
        "content ${httpResponse.body}");
  }
}

init() async {
  await AndroidAlarmManager.initialize();
  const int alarmID = 0;
  await AndroidAlarmManager.oneShot( // TODO Gernot periodic
      const Duration(minutes: 0), alarmID, job);
}
