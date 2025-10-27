import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MemberProfile extends StatefulWidget {
  const MemberProfile({super.key});

  @override
  State<MemberProfile> createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    const url = 'https://members.washlover.com/api/member/profile';
    const cookie =
        'session=YOUR_SESSION_COOKIE_HERE'; // 👈 ใส่ค่าจากตอน login

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': cookie,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          profileData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed: ${response.statusCode} ${response.reasonPhrase}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (errorMessage != null) return Center(child: Text(errorMessage!));
    if (profileData == null) return const Center(child: Text('No data'));

    return Scaffold(
      appBar: AppBar(title: const Text('Member Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ชื่อ: ${profileData!['name'] ?? '-'}'),
            Text('อีเมล: ${profileData!['email'] ?? '-'}'),
          ],
        ),
      ),
    );
  }
}
