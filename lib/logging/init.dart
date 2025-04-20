import 'package:logging/logging.dart' show Logger;

final Logger logger = Logger("DachsteinPistesMainLogger");
bool loggerInitialized = false;

void init(Logger logger) {
  if (!loggerInitialized) {
    loggerInitialized=true;
  }
}
