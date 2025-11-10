import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class API_account {
  static Future<Map<String, dynamic>?> fetchapiaccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String endpoint = prefs.getString('endpoint') ?? '';

    try {
      final response = await http.get(
        Uri.parse("${endpoint}/api/member/profile"),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        if (jsonBody.containsKey('data')) {
          return jsonBody['data'];
        } else {
          return jsonBody;
        }
      } else {
        print("❌ Error ${response.statusCode}: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("❗ Exception while fetching user data: $e");
      return null;
    }
  }

  static Future fetchapipoint() async {}
}
