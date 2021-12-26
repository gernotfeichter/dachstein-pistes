import 'dart:convert';
import 'dart:developer';
import 'package:dachstein_pistes/globals/init.dart';
import 'package:json_schema2/json_schema2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'model.dart';

bool initialized = false;

void init() async{
  log("init db started");

  final prefs = await SharedPreferences.getInstance();
  final appPreferences = prefs.getString(await packageName());
  if (appPreferences != null) {
    log("existing preferences could not be bound, initializing");
    final seed = await rootBundle.loadString("lib/db/seed.json");
    final schemaString = await rootBundle.loadString("lib/db/schema.json");
    final jsonSchema = JsonSchema.createSchema(schemaString);
    log("validating json schema");
    if (jsonSchema.validate(seed, parseJson: true)) {
      prefs.setString(
          await packageName(),
          seed);
    } else {
      log("schema validation error!", level: 3);
      throw Exception("Dachstein Pistes could not start due to schema "
          "validation error from built in json schema.");
    }
  }

  initialized = true;
  log("init db finished");
}

void assertInitialized() {
  if (!initialized) {
    init();
  }
}

Future<AppSettings> get() async {
  log('db get start');
  assertInitialized();
  final prefs = await SharedPreferences.getInstance();
  final appPreferences = prefs.getString(await packageName());
  log('db get finished');
  return AppSettings.fromJson(
    jsonDecode(appPreferences!)
  );
}

void set(AppSettings appSettings) async {
  log('db set start');
  assertInitialized();
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(
      await packageName(),
      jsonEncode(appSettings.toJson())
  );
  log('db set finished');
}
