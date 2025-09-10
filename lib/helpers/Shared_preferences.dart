import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  SharedPreferences? prefs;

  Preferences();

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  String getValue(String key) {
    if (prefs == null) {
      return "";
    }
    return prefs!.getString(key) ?? "";
  }

  void saveKey(String key, String value) {
    if (prefs == null) {
      return;
    }
    prefs!.setString(key, value);
  }

  void saveList(String key, List<String> value) {
    if (prefs == null) {
      return;
    }
    prefs!.setStringList(key, value);
  }

  List<String> getList(String key) {
    if (prefs == null) {
      return [];
    }
    return prefs!.getStringList(key) ?? [];
  }

  void removeKey(String key) {
    if (prefs == null) {
      return;
    }
    prefs!.remove(key);
  }
}
