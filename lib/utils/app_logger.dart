import 'package:flutter/foundation.dart';

class AppLogger {
  static const String _tag = '[DailyQuran]';

  static void log(String message, {String? tag}) {
    if (kDebugMode) {
      print('$_tag ${tag ?? ''} $message');
    }
  }

  static void logError(String message, {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print('$_tag [ERROR] $message');
      if (error != null) print('Error: $error');
      if (stackTrace != null) print('Stack: $stackTrace');
    }
  }

  static void logSuccess(String message) {
    if (kDebugMode) {
      print('$_tag [SUCCESS] $message');
    }
  }
}
