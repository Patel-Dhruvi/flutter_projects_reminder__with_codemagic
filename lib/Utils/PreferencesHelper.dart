import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper{

   static const String PREF_SELECTED_IMAGE = "pref_selected_img";
   static const String PREF_SELECTED_TEXT_SIZE = "pref_selected_text_size";
   static const String PREF_SELECTED_TEXT_INDEX = "pref_selected_text_index";
   static const String PREF_IS_ASSET_IMAGE = "pref_is_asset_image";
   static const String PREF_IS_FILE_IMAGE = "pref_is_file_image";
   static const String PREF_IS_TASK_DONE = "pref_is_task_done";
   static const String PREF_SHOW_WEEKDAY_NAME = "pref_show_weekday_name";
   static const String PREF_IS_VIBRATE = "pref_is_vibrate";

  static Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  static Future<String> getStringValue(String key) async
  {
    final p = await prefs;
    return p.getString(key) ?? null;
  }

  static Future setStringValue(String key,String value) async
  {
    final p = await prefs;
    return p.setString(key, value);
  }

   static Future<int> getIntValue(String key) async {
     final p = await prefs;
     return p.getInt(key) ?? 0;
   }

   static Future setIntValue(String key, int value) async {
     final p = await prefs;
     return p.setInt(key, value);
   }

   static Future<double> getDoubleValue(String key) async {
     final p = await prefs;
     return p.getDouble(key) ?? 0.0;
   }

   static Future setDoubleValue(String key, double value) async {
     final p = await prefs;
     return p.setDouble(key, value);
   }

   static Future<bool> getBoolValue(String key) async {
     final p = await prefs;
     return p.getBool(key) ?? false;
   }

   static Future setBoolValue(String key, bool value) async {
     final p = await prefs;
     return p.setBool(key, value);
   }

   static Future<bool> getVibrateBoolValue(String key) async {
     final p = await prefs;
     return p.getBool(key) ?? true;
   }

   static Future setVibrateBoolValue(String key, bool value) async {
     final p = await prefs;
     return p.setBool(key, value);
   }

}

