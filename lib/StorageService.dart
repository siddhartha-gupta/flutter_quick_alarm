part of quick_alarm;

class StorageService {
  static SharedPreferences prefs;

  static Future<void> initialize() async {
    StorageService.prefs = await SharedPreferences.getInstance();

    return Future<bool>.value(true);
  }

  static void setItem(String key, String value) {
    StorageService.prefs.setString(key, value);
  }

  static String getItem(String key) {
    return StorageService.prefs.getString(key);
  }
}
