import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_flutter_mapwash/Oders/API/api_saveorder.dart';
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
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await APICartSet.sendCartOk(
          "${data['device_id']}",
          [
            {
              "product_id": 101,
              "quantity": 2,
              "price": 99.0,
            },
            {
              "product_id": 102,
              "quantity": 1,
              "price": 199.0,
            },
          ],
        );
        deleteCart();
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

  static Future<bool> deleteCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String endpoint = prefs.getString('endpoint') ?? '';
    String phone = prefs.getString('phone') ?? '';

    if (token.isEmpty || endpoint.isEmpty || phone.isEmpty) {
      print("Missing required data in SharedPreferences");
      return false;
    }

    try {
      final uri = Uri.parse("$endpoint/api/cart/$phone");
      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("Item deleted successfully");
        return true;
      } else {
        print("Delete failed with status: ${response.statusCode}");
        print("Response body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception while deleting cart item: $e");
      return false;
    }
  }
}

class ApiGetCart {
  /// คืนค่า List ของ cart items หรือ [] ถ้าเกิดข้อผิดพลาด
  static Future<List<dynamic>> getCart() async {
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
        if (data is List) {
          return data;
        } else if (data is Map && data['items'] != null) {
          return data['items'];
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
