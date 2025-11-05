import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiPost {
  static Future<bool> updateLocation({
    required double lat,
    required double lng,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String endpoint = prefs.getString('endpoint') ?? '';

    try {
      final response = await http.post(
        Uri.parse("$endpoint/api/member/update_location"),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "latitude": lat,
          "longitude": lng,
        }),
      );

      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return true;
        }
      } else {
        print("Error: ${response.statusCode}");
      }
      return false;
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }
}

class ApiGetCart {
  /// คืนค่า List ของ cart items หรือ [] ถ้าเกิดข้อผิดพลาด
  static Future<List<Map<String, dynamic>>> getCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String endpoint = prefs.getString('endpoint') ?? '';
    String phone = prefs.getString('phone') ?? '';

    if (token.isEmpty || endpoint.isEmpty || phone.isEmpty) {
      print("Missing required data in SharedPreferences");
      return [];
    }

    try {
      final uri = Uri.parse("$endpoint/api/cart/$phone");
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['cart']);
      } else {
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
      return [];
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }
}
