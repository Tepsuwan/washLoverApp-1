import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class api_profile {
  static Future<Map<String, dynamic>> fetchProfile() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String endpoint = prefs.getString('endpoint') ?? '';

  try {
    final response = await http.get(
      Uri.parse("$endpoint/api/member/profile"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is Map && data['data'] != null) {
        return data['data'] as Map<String, dynamic>;
      } else if (data is Map) {
        return data as Map<String, dynamic>;
      } else {
        throw Exception("รูปแบบข้อมูลไม่ถูกต้อง (ไม่ใช่ Map)");
      }
    } else {
      print("Error: ${response.statusCode}");
      throw Exception("โหลดข้อมูลไม่สำเร็จ (${response.statusCode})");
    }
  } catch (e) {
    print("Exception: $e");
    throw Exception("เกิดข้อผิดพลาดในการเชื่อมต่อ API: $e");
  }
}

}
