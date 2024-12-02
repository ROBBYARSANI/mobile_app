import 'dart:io';

class AppConfig {
  static String get API_HOST {
    if (Platform.isAndroid || Platform.isIOS) {
      return "192.168.224.86";
    } else {
      return "localhost";
    }
  }
}
