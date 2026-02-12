import 'package:flutter/material.dart';

class Logger {
  static void log(String message) {
    debugPrint('📱 [App]: $message');
  }

  static void error(String message, [dynamic error]) {
    debugPrint('❌ [Error]: $message${error != null ? ' - $error' : ''}');
  }

  static void success(String message) {
    debugPrint('✅ [Success]: $message');
  }
}
