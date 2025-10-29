import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class api_status {
  // ดึงประวัติจาก API
  static Future<List<dynamic>> fetchstatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String endpoint = prefs.getString('endpoint') ?? '';

    try {
      final response = await http.get(
        Uri.parse("${endpoint}/api/member/history"),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        print("Response: ${response.body}");
        final data = json.decode(response.body);
        if (data is List) {
          return data;
        } else if (data is Map && data['data'] != null) {
          return data['data'];
        } else {
          return [];
        }
      } else {
        print("Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }
}
