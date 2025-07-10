import 'package:shared_preferences/shared_preferences.dart';

class Preferences { 
  SharedPreferences? prefs;

  Preferences()  {
  }

  Future<void> init() async {
    print("init");
    prefs = await SharedPreferences.getInstance();
    print(prefs);
  }

  String getValue(String key){
    if (prefs == null) {
      print("prefs null");
      return "";
    }
    return prefs!.getString(key) ?? "";
  }

  void saveKey(String key, String value){
    if (prefs == null) {
      return ;
    }
    prefs!.setString(key, value);
  }
}
