import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApistatusRealtime {
  Future<Map<String, dynamic>?> getStatusRealtime(
      String deviceId, String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final endpoint = prefs.getString('endpoint');

    final url = Uri.parse('$endpoint/api/get_destination?device_id=$deviceId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        print(
            '⚠️ [$id] Error: ${response.statusCode} (${response.reasonPhrase})');
        return null;
      }
    } catch (e) {
      print('❌ [$id] Error fetching destination status: $e');
      return null;
    }
  }
}

class ApistatusDriver {
  Future<Map<String, dynamic>?> getDestinationDriver(
      String deviceId, String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final endpoint = prefs.getString('endpoint');

    final url = Uri.parse('$endpoint/api/get_last_location?device_id=$deviceId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        print(
            '⚠️ [$id] Error: ${response.statusCode} (${response.reasonPhrase})');
        return null;
      }
    } catch (e) {
      print('❌ [$id] Error fetching destination status: $e');
      return null;
    }
  }
}
