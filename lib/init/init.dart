import 'package:dachstein_pistes/backgroundjob/init.dart' as bg;
import 'package:dachstein_pistes/logging/init.dart' as lg;
import 'package:flutter/cupertino.dart';

Future<void> init() async {
  lg.logger.info("init started");

  WidgetsFlutterBinding.ensureInitialized();

  // setup logging (makes sure to also log to androids logcat)
  lg.init(lg.logger);

  // setup alarm manager (androids way of cronjob)
  bg.init();

  lg.logger.info("init finished");
}