import 'dart:developer';

class Logger {
  static void logInfo(String message) => log(message, level: 200);
  static void logError(String message) => log(message, level: 500);
}
