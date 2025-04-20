import 'package:dachstein_pistes/widgets/init.dart';
import 'package:flutter/material.dart';
import 'package:dachstein_pistes/init/init.dart' as m;

void main() async {
  await m.init();
  runApp(const MyApp());
}
