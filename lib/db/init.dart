import 'dart:convert';
import 'dart:io';
import 'package:dachstein_pistes/globals/init.dart';
import 'package:json_schema2/json_schema2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'model.dart';
import 'package:synchronized/synchronized.dart';
import 'package:dachstein_pistes/logging/init.dart';

Future<void> init() async {
  var lock = Lock();
  await lock.synchronized(() async {
    logger.info("init db started");

    final prefs = await SharedPreferences.getInstance();
    sleep(const Duration(milliseconds: 200)); // file is written asynchronously
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

    // TODO Gernot start
    String expectedDate = appSettings.refreshSettings.last;
    // TODO Gernot end

    await init();
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    prefs.setString(
        packageName(),
        jsonEncode(appSettings.toJson())
    );
    sleep(const Duration(milliseconds: 200)); // file is written asynchronously

    // TODO Gernot start
    String actualDate = (await get()).refreshSettings.last;
    logger.info("asserting $actualDate == $expectedDate");
    assert(actualDate == expectedDate);
    // TODO Gernot end

    logger.info('db set finished');
  });
}
