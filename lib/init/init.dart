import 'package:dachstein_pistes/backgroundjob/init.dart' as bg;
import 'package:dachstein_pistes/logging/init.dart' as lg;
import 'package:flutter/cupertino.dart';

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  // setup logging (makes sure to also log to android's logcat)
  lg.init();
  lg.logger.i("init started");

  // setup alarm manager (androids way of cronjob)
  bg.init();

  lg.logger.i("init finished");
}