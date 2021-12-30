import 'dart:developer';

import 'package:dachstein_pistes/backgroundjob/init.dart' as bg;

void init() async {
  log("init started");

  // setup alarm manager (androids way of cronjob)
  bg.init();

  log("init finished");
}