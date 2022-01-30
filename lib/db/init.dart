import 'dart:convert';
import 'dart:io';
import 'package:dachstein_pistes/globals/init.dart';
import 'package:json_schema2/json_schema2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'model.dart';
import 'package:synchronized/synchronized.dart';
import 'package:dachstein_pistes/logging/init.dart';

// shared_preferences_bugs_anchor
// This "db" interface uses the popular shared_preferences plugin.
// Unfortunately there is an unresolved race condition bug in the given version,
// such that I to implement synchronized code.
// --> https://github.com/flutter/flutter/issues/95013
// Also, db writes seem to be flushed out asynchronously without awaiting the
// result, so I introduced sleeps in various places.
// Also, I even re-read and verify settings after writing them.
// Further, it seems to be required to reload settings before each usage to get
// "safe" results.
// If I had known this before, I would not have used this module.
// But I hope it will be fixed soon.

Future<void> init() async {
  var lock = Lock();
  await lock.synchronized(() async {
    logger.info("init db started");

    final prefs = await SharedPreferences.getInstance();
    // see shared_preferences_bugs_anchor at top
    await prefs.reload();
    final appPreferences = prefs.getString(packageName());
    if (appPreferences == null) {
      logger.info("existing preferences could not be found, initializing");
      final seed = await rootBundle.loadString("lib/db/seed.json");
      final schemaString = await rootBundle.loadString("lib/db/schema.json");
      final jsonSchema = JsonSchema.createSchema(schemaString);
      logger.info("validating json schema");
      if (jsonSchema.validate(seed, parseJson: true)) {
        prefs.setString(
            packageName(),
            seed);
      } else {
        logger.severe("schema validation error!");
        throw Exception("Dachstein Pistes could not start due to schema "
            "validation error from built in json schema.");
      }
    }

    logger.info("init db finished");
  });
}

Future<AppSettings> get() async {
  var lock = Lock();
  return await lock.synchronized(() async {
    logger.info('db get start');
    await init();
    final prefs = await SharedPreferences.getInstance();
    // see shared_preferences_bugs_anchor at top
    sleep(const Duration(milliseconds: 200)); // file is written asynchronously
    await prefs.reload();
    final appPreferences = prefs.getString(packageName());
    logger.info('db get finished');
    return AppSettings.fromJson(
      jsonDecode(appPreferences!)
    );
  });
}

Future<void> set(AppSettings appSettings) async {
  var lock = Lock();
  await lock.synchronized(() async {
    logger.info('db set start');

/*    // TODO Gernot start
    // see shared_preferences_bugs_anchor at top
    String expectedDate = appSettings.refreshSettings.last;
    // TODO Gernot end*/

    await init();
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    prefs.setString(
        packageName(),
        jsonEncode(appSettings.toJson())
    );

/*    // TODO Gernot start
    // see shared_preferences_bugs_anchor at top
    String actualDate = (await get()).refreshSettings.last;
    logger.info("asserting $actualDate == $expectedDate");
    assert(actualDate == expectedDate);
    // TODO Gernot end*/

    logger.info('db set finished');
  });
}
