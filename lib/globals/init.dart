import 'package:flutter/services.dart';
import "package:yaml/yaml.dart";

Future<String> packageName() async {
  return loadYaml(await rootBundle.loadString("pubspec.yaml"))["name"];
}
