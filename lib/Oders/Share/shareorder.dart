import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharePrefs {
  static const String keyItems = 'selected_items';

  /// 🔹 บันทึก List<Map<String, dynamic>> ลง SharedPreferences
  static Future<void> saveItems(List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(items);
    await prefs.setString(keyItems, jsonString);
  }

  /// 🔹 ดึงข้อมูลกลับมา
  static Future<List<Map<String, dynamic>>> getItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(keyItems);
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString);
    print("✅ Decoded items count: ${decoded.length}");
    print("🧾 Items detail: ${jsonEncode(decoded)}");
    return List<Map<String, dynamic>>.from(decoded);
  }

  /// 🔹 ล้างข้อมูลทั้งหมด
  static Future<void> clearItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyItems);
  }
}
