import 'dart:io';

class AppConfig {
  static String get API_HOST {
    if (Platform.isAndroid || Platform.isIOS) {
      return "10.252.128.135";
    } else {
      return "localhost";
    }
  }
}
