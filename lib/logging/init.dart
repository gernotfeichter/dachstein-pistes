import 'package:logging/logging.dart';
import 'package:logging_to_logcat/logging_to_logcat.dart';

final Logger logger = Logger("DachsteinPistesMainLogger");

void init() {
  logger.activateLogcat();
}
