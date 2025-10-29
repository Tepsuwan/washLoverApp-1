import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_flutter_mapwash/Status/API/api_status.dart';
import 'package:my_flutter_mapwash/Status/realtime_status.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Status extends StatefulWidget {
  const Status({super.key});

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  List<dynamic> _statusData = [];
  String? phone;

  @override
  void initState() {
    super.initState();
    _loadPhoneAndStatus();
  }

  Future<void> _loadPhoneAndStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPhone = prefs.getString('phone');

    if (storedPhone != null && storedPhone.isNotEmpty) {
      setState(() => phone = storedPhone);
      _loadStatus();
    } else {
      print('Phone not found in SharedPreferences');
    }
  }

  Future<void> _loadStatus() async {
    try {
      List<dynamic> data = await api_status.fetchstatus();
      // กรอง status != 4
      final filtered = data.where((e) => e['status'] != 4).toList();
      setState(() {
        _statusData = filtered;
      });
    } catch (e) {
      print('Error loading status: $e');
      setState(() => _statusData = []);
    }
  }

  String formatDate(String datetime) {
    try {
      DateTime parsedDate = DateTime.parse(datetime);
      return DateFormat('dd MMMM yyyy, E', 'th_TH').format(parsedDate);
    } catch (e) {
      return datetime;
    }
  }

  String formatTime(String datetime) {
    try {
      DateTime parsedDate = DateTime.parse(datetime);
      return DateFormat('HH:mm', 'th_TH').format(parsedDate) + " น.";
    } catch (e) {
      return 'ออนไลน์';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "รายการส่งซัก",
          style: TextStyle(
            color: Color.fromARGB(255, 203, 203, 203),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: phone == null
            ? const Center(child: CircularProgressIndicator())
            : _statusData.isEmpty
                ? const Center(child: Text('ไม่มีข้อมูล'))
                : ListView.builder(
                    itemCount: _statusData.length,
                    itemBuilder: (context, index) {
                      final order = _statusData[index];
                      final price =
                          double.tryParse(order['price']?.toString() ?? '0') ??
                              0.0;
                      return _buildTransactionItem(
                        context,
                        icon: Icons.online_prediction_sharp,
                        color: Colors.green,
                        title: order['id'].toString(),
                        orderId: order['id'].toString(),
                        subtitle: formatDate(order['set_at'] ?? ''),
                        amount:
                            '฿${price < 0 ? 0.0 : price.toStringAsFixed(2)}',
                        time: formatTime(order['set_at'] ?? ''),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String amount,
    required String time,
    required String orderId,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => realtime_status(),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          title: Text(title, style: const TextStyle(fontSize: 14)),
          subtitle: Text(subtitle,
              style: const TextStyle(fontSize: 13, color: Colors.grey)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[500],
                    fontSize: 16),
              ),
              Text(time,
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
