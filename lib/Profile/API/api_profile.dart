import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> fetchProfile() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final endpoint = prefs.getString('endpoint');
  if (token == null) {
    throw Exception('Token not found in SharedPreferences');
  }
  final url = '$endpoint/api/member/profile';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load profile: ${response.statusCode}');
  }
}
