part of quick_alarm;

class StorageService {
  static SharedPreferences prefs;

  static Future<void> initialize() async {
    StorageService.prefs = await SharedPreferences.getInstance();

    return Future<bool>.value(true);
  }

  static void setString(String key, String value) {
    StorageService.prefs.setString(key, value);
  }

  static String getString(String key) {
    return StorageService.prefs.getString(key);
  }

  static void setInteger(String key, int value) {
    StorageService.prefs.setInt(key, value);
  }

  static int getInteger(String key) {
    return StorageService.prefs.getInt(key);
  }
}
