// lib/services/cart_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APICartSet {
  // ✅ ฟังก์ชันนี้เป็น public (เรียกใช้จากไฟล์อื่นได้)
  static Future<void> sendCartToSet(List<Map<String, dynamic>> items) async {
    print(items);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final phone = prefs.getString('phone');
      final endpoint = prefs.getString('endpoint') ?? '';

      if (token == null) {
        print("❌ ไม่พบ Token, กรุณา Login ก่อน");
        return;
      }
      if (endpoint.isEmpty) {
        print("❌ ไม่พบ Endpoint ใน SharedPreferences");
        return;
      }
      if (phone == null) {
        print("❌ ไม่พบหมายเลขโทรศัพท์ใน SharedPreferences");
        return;
      }
      // ✅ ใช้ http.Request แทน http.post
      final url = Uri.parse('$endpoint/api/cart/$phone');

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // 🔹 ปรับ payload ให้เป็น item เดียวหรือหลายชิ้นได้
      var body = items.length == 1 ? items.first : {"items": items};

      var request = http.Request('POST', url);
      request.body = json.encode(body);
      request.headers.addAll(headers);

      print("📦 Sending data to: $url");
      print("📤 Payload: ${jsonEncode(body)}");

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print("✅ ส่งข้อมูลสำเร็จ: $responseBody");
      } else {
        print(
            "❌ ส่งข้อมูลไม่สำเร็จ (${response.statusCode}): ${response.reasonPhrase}");
      }
    } catch (e) {
      print("⚠️ Error: $e");
    }
  }
}
