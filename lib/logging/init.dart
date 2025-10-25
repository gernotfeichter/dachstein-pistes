import 'package:simple_native_logger/simple_native_logger.dart';

late SimpleNativeLogger logger;
bool loggerInitialized = false;

void init() {
  if (!loggerInitialized) {
    SimpleNativeLogger.init();
    logger = SimpleNativeLogger(tag: "DachsteinPistesMain");
    loggerInitialized=true;
  }
}
