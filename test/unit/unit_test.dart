import 'dart:convert';
import 'dart:io';

import 'package:dachstein_pistes/db/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('unit test: AppSettings serialisation', () {
    // Given a json string representing my AppSettings
    String jsonString = File('lib/db/seed.json').readAsStringSync();

    // When I parse it into an object
    AppSettings appSettings = AppSettings.fromJson(
        jsonDecode(jsonString)
    );

    // Then assert that the object reflects the seed.json file
    assert(appSettings.pistes.length == 2);
    Piste firstPiste = appSettings.pistes.first;
    assert(firstPiste.name ==
      "Zugang Skiroute Wilde Abfahrt Edelgriess (Rosmariestollen)");
    assert(firstPiste.state == "unknown");
    assert(firstPiste.notification == true);

    assert(appSettings.refreshSettings.last == "never");
    // TODO Gernot change back to 60!
    //assert(appSettings.refreshSettings.interval == 60);
    assert(appSettings.refreshSettings.interval == 1);
  });
}