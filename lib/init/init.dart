import 'dart:developer';
import 'package:dachstein_pistes/db/init.dart' as db;

void init() {
  log("init started");

  //
  db.init();

  // setup alarm manager (androids way of cronjob)

  // load application state from db (regularly)

  log("init finished");
}