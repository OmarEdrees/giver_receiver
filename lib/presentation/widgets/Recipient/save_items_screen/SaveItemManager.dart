import 'package:shared_preferences/shared_preferences.dart';

class SaveItemManager {
  static const String key = "saved_items";

  static Future<List<String>> getSavedItems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  static Future<void> toggleSaveItem(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> saved = prefs.getStringList(key) ?? [];

    if (saved.contains(itemId)) {
      saved.remove(itemId); // remove saved
    } else {
      saved.add(itemId); // save item
    }

    await prefs.setStringList(key, saved);
  }

  static Future<bool> isItemSaved(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> saved = prefs.getStringList(key) ?? [];
    return saved.contains(itemId);
  }
}
