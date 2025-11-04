import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_mapwash/Layouts/main_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_flutter_mapwash/Login/login_page.dart';
import 'package:my_flutter_mapwash/api_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _startScreen = const Scaffold(
    body: Center(child: CircularProgressIndicator()),
  );

  @override
  void initState() {
    super.initState();

    api_config.loadEndpoint();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final phone = prefs.getString('phone');
    final password = prefs.getString('password');
    final endpoint = prefs.getString('endpoint');

    double currentLat = 13.7563;
    double currentLng = 100.5018;

    await prefs.setDouble('lat', currentLat);
    await prefs.setDouble('lng', currentLng);

    // if (token != null && phone != null && password != null) {
    try {
      final url = Uri.parse('$endpoint/api/auth/token');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phone,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        await prefs.setString('token', token);
        setState(() {
          _startScreen = const MainLayout();
        });
        return;
      } else {
        await prefs.clear();
      }
    } catch (e) {
      debugPrint('Login check error: $e');
    }
    // }

    setState(() {
      _startScreen = LoginPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Kanit'),
      home: _startScreen,
    );
  }
}
