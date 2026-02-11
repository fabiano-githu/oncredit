// lib/config/app_config.dart

import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static const String environment = 'DEV'; // ou PROD
  static String fixedUid = 'dev_uid_001';
  static String baseUrl = 'https://jsbpad-default-rtdb.firebaseio.com';

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    fixedUid = prefs.getString('fixedUid') ?? fixedUid;
    baseUrl = prefs.getString('baseUrl') ?? baseUrl;
  }

  static Future<void> save(String uid, String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fixedUid', uid);
    await prefs.setString('baseUrl', url);

    fixedUid = uid;
    baseUrl = url;
  }
}
