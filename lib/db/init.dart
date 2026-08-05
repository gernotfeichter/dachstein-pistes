import 'dart:convert';
import 'dart:io';
import 'package:dachstein_pistes/globals/init.dart';
import 'package:json_schema/json_schema.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'model.dart';
import 'package:synchronized/synchronized.dart';
import 'package:dachstein_pistes/logging/init.dart';

// shared_preferences_bugs_anchor
// This "db" interface uses the popular shared_preferences plugin.
// Unfortunately there is an unresolved race condition bug in the given version,
// such that I had to implement synchronized code.
// --> https://github.com/flutter/flutter/issues/95013
// Also, db writes seem to be flushed out asynchronously without awaiting the
// result, so I introduced sleeps in various places.
// Also, I even re-read and verify settings after writing them.
// Further, it seems to be required to reload settings before each usage to get
// "safe" results.
// If I had known this before, I would not have used this module.
// But I hope it will be fixed soon.

final _lock = Lock();
bool _dbInitialized = false;

Future<void> init() async {
  if (_dbInitialized) return;
  
  await _lock.synchronized(() async {
    await _initInternal();
  });
}

Future<void> _initInternal() async {
  if (_dbInitialized) return;
  logger.i("init db started");

  final prefs = await SharedPreferences.getInstance();
  // see shared_preferences_bugs_anchor at top
  await prefs.reload();
  final appPreferences = prefs.getString(packageName());
  if (appPreferences == null) {
    logger.i("existing preferences could not be found, initializing");
    final seed = await rootBundle.loadString("lib/db/seed.json");
    final schemaString = await rootBundle.loadString("lib/db/schema.json");
    final jsonSchema = JsonSchema.create(schemaString);
    logger.i("validating json schema");
    if (jsonSchema.validate(seed, parseJson: true).isValid) {
      prefs.setString(
          packageName(),
          seed);
    } else {
      logger.e("schema validation error!");
      throw Exception("Dachstein Pistes could not start due to schema "
          "validation error from built in json schema.");
    }
  }

  logger.i("init db finished");
  _dbInitialized = true;
}

Future<AppSettings> get() async {
  return await _lock.synchronized(() async {
    logger.i('db get start');
    await _initInternal();
    final prefs = await SharedPreferences.getInstance();
    // see shared_preferences_bugs_anchor at top
    await Future.delayed(const Duration(milliseconds: 200)); // file is written asynchronously
    await prefs.reload();
    final appPreferences = prefs.getString(packageName());
    logger.i('db get finished');
    return AppSettings.fromJson(
      jsonDecode(appPreferences!)
    );
  });
}

Future<void> set(AppSettings appSettings) async {
  await _lock.synchronized(() async {
    logger.i('db set start');

    await _initInternal();
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    prefs.setString(
        packageName(),
        jsonEncode(appSettings.toJson())
    );

    logger.i('db set finished');
  });
}
