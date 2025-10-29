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

      List<dynamic> listData = [];

      if (data is List) {
        listData = data;
      } else if (data is Map && data['data'] != null) {
        listData = data['data'];
      }

      // กรองเอา status ที่ไม่เท่ากับ 4
      final filteredData = listData.where((item) {
        return item['status'] != 4;
      }).toList();

      return filteredData;

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
