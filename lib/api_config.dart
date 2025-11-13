import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class api_config {
  static String endpoint = ''; // ค่าเริ่มต้น

  /// โหลด endpoint จาก cache หรือ server
  static Future<void> loadEndpoint() async {
    final prefs = await SharedPreferences.getInstance();
    String cached = prefs.getString('endpoint') ?? '';
    // ✅ ถ้าไม่มีค่าใน cache → ยิง API ไปโหลด
    try {
      final url = Uri.parse('https://washlover.com/endpoint/gps');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['endpoint'] != null) {
          endpoint = data['endpoint'];
          await prefs.setString('endpoint', endpoint);
          print('🌐 โหลด endpoint ใหม่: $endpoint');
        } else {
          print('❌ API ตอบกลับไม่ถูกต้อง: $data');
        }
      } else {
        print('❌ API status code: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ โหลด endpoint ไม่สำเร็จ: $e');
    }
  }
}
