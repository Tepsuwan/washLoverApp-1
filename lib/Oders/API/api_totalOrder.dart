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
