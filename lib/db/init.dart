import 'dart:convert';
import 'dart:developer';
import 'package:dachstein_pistes/globals/init.dart';
import 'package:json_schema2/json_schema2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'model.dart';

Future<void> init({bool testMode = false}) async {
  log("init db started");

  if (testMode) { return; }

  final prefs = await SharedPreferences.getInstance();
  final appPreferences = prefs.getString(packageName());
  if (appPreferences == null) {
    log("existing preferences could not be found, initializing");
    final seed = await rootBundle.loadString("lib/db/seed.json");
    final schemaString = await rootBundle.loadString("lib/db/schema.json");
    final jsonSchema = JsonSchema.createSchema(schemaString);
    log("validating json schema");
    if (jsonSchema.validate(seed, parseJson: true)) {
      prefs.setString(
          packageName(),
          seed);
    } else {
      log("schema validation error!", level: 3);
      throw Exception("Dachstein Pistes could not start due to schema "
          "validation error from built in json schema.");
    }
  }

  log("init db finished");
}

Future<AppSettings> get({bool testMode = false}) async {
  log('db get start');
  await init(testMode: testMode);
  final prefs = await SharedPreferences.getInstance();
  final appPreferences = prefs.getString(packageName());
  log('db get finished');
  return AppSettings.fromJson(
    jsonDecode(appPreferences!)
  );
}

Future<void> set(AppSettings appSettings, {bool testMode = false}) async {
  log('db set start');
  await init(testMode: testMode);
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(
      packageName(),
      jsonEncode(appSettings.toJson())
  );
  log('db set finished');
}
