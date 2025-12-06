import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_flutter_mapwash/Chat/test.dart';
import 'package:my_flutter_mapwash/Payment/walletQrcode.dart';
import 'package:my_flutter_mapwash/Status/API/api_status.dart';
import 'package:my_flutter_mapwash/Status/realtime_status.dart';

import '../Chat_socket/chat_screen.dart';

class Status extends StatefulWidget {
  const Status({super.key});

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  List<dynamic> _statusData = [];
  final api = ApistatusOrder();
  int status = 0;
  Timer? _timer;
  bool isStat = false;

  String apiKey = "DRIVER"; // 👈 ใส่ API KEY จริงของคุณ
  String? paymentStatus;
  // ใช้ orderId เป็น key
  Map<String, Future<Map<String, dynamic>?>> _futureCache = {};

  @override
  void initState() {
    super.initState();
    _loadStatus();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    // ยิงทุก 5 วินาที
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {
        _futureCache.clear();
      });
    });
  }

  Future<void> _loadStatus() async {
    try {
      List<dynamic> data = await api_status.fetchstatus();
      final filtered = data.where((e) => e['status'] != 4).toList();
      setState(() {
        _statusData = filtered;
        status = _statusData[0]['status'];
      });
    } catch (e) {
      print('Error loading status: $e');
      setState(() => _statusData = []);
    }
  }

  Future<Map<String, dynamic>?> _getFuture(
      String deviceId, String orderId) async {
    if (!_futureCache.containsKey(orderId)) {
      _futureCache[orderId] = api.fetchDestinationStatus(deviceId, orderId);
    }
    Map<String, dynamic>? statusData = await _futureCache[orderId];
    status = statusData?['status'] ?? 0;
    print(status);
    return statusData;
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

  Map<String, dynamic> getStatusInfo(int status) {
    switch (status) {
      case 1:
        return {'text': 'กำลังหาคนขับ... ⏱︎', 'color': Colors.green};
      case 2:
        return {'text': 'คนขับรับงาน', 'color': Colors.blue};
      case 3:
        return {'text': 'กำลังซัก', 'color': Colors.orange};
      default:
        return {'text': 'เสร็จสิ้น', 'color': Colors.pink};
    }
  }

  Color getPaymentStatusColor(String status) {
    status = status.toLowerCase();

    if (status.contains("ชำระเงินเรียบร้อย") ||
        status.contains("success") ||
        status.contains("paid")) {
      return Colors.green;
    }

    if (status.contains("รอ") ||
        status.contains("pending") ||
        status.contains("ค้างชำระ")) {
      return Colors.red;
    }

    if (status.contains("ไม่สำเร็จ") ||
        status.contains("fail") ||
        status.contains("error")) {
      return Colors.red;
    }

    return Colors.grey; // default
  }

  /// 2) เช็คสถานะการชำระเงิน

  Future<String> checkPaymentStatus(String orderId) async {
    final url =
        "https://payment.washlover.com/api/check-payment?ref1=$orderId&ref4=$apiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["data"]["status"] == "success") {
        return data["data"]["msg"];
      } else {
        return data["data"]["msg"] ?? "รอการชำระเงิน";
      }
    } else {
      return "เช็คสถานะไม่สำเร็จ";
    }
  }

  Widget _buildTransactionItem({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String amount,
    required String time,
    required String id,
    required String device_id,
    required dynamic status,
    required dynamic payment,
    required String paymentStatusText,
  }) {
    return GestureDetector(
      onTap: () {
        double totalPrice = double.parse(amount);
        _timer?.cancel();
        if (isStat == true) {
          if (paymentStatusText == "รอการชำระเงิน") {
            isStat == false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Qrcode(),
                settings: RouteSettings(
                  arguments: {
                    'totalPrice': totalPrice,
                    'address': 'ไม่พบที่อยู่',
                    'addressBranch': 'ไม่พบสาขาที่ใกล้ที่สุด',
                    'coupon': '',
                    'payment': 'manual',
                  },
                ),
              ),
            );
          } else {
            isStat == true;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => realtime_status(
                  id: id,
                  deviceId: device_id,
                ),
              ),
            ).then((_) {
              _startAutoRefresh();
            });
          }
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          title: Text(title, style: const TextStyle(fontSize: 14)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: getPaymentStatusColor(paymentStatusText),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  paymentStatusText,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),

          // ✅ เพิ่มไอคอน chat ที่ฝั่งขวา
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[500],
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              if (status != 1)
                IconButton(
                  icon: const Icon(Icons.chat, color: Colors.blueAccent),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(device_id),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyStatus() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/collectionduck/Artboard1copy4.png',
            width: 120,
            height: 90,
          ),
          const SizedBox(height: 10),
          Text(
            'ไม่มีประวัติการใช้งาน',
            style: TextStyle(color: Colors.grey[600], fontSize: 18),
          ),
        ],
      ),
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _statusData.isEmpty
            ? _buildEmptyStatus()
            : ListView.builder(
                itemCount: _statusData.length,
                itemBuilder: (context, index) {
                  final order = _statusData[index];
                  final orderStatus =
                      int.tryParse(order['status']?.toString() ?? '0') ?? 0;

                  if (orderStatus == 4) return const SizedBox.shrink();

                  final price = '5.0';
                  final deviceId = order['device_id'].toString();
                  final orderId = order['id'].toString();
                  final statusInfo = getStatusInfo(orderStatus);
                  isStat = true;
                  return FutureBuilder<Map<String, dynamic>?>(
                    future: _getFuture(deviceId, orderId),
                    builder: (context, snapshotOrder) {
                      String apiText = '...';
                      Color apiColor = statusInfo['color'];

                      if (snapshotOrder.hasData && snapshotOrder.data != null) {
                        String rawStatus =
                            snapshotOrder.data!['status']?.toString() ?? '';
                        int statusInt = int.tryParse(rawStatus) ?? 0;
                        final statusFromApi = getStatusInfo(statusInt);
                        apiText = statusFromApi['text'];
                        apiColor = statusFromApi['color'];
                      }

                      return FutureBuilder<Map<String, dynamic>?>(
                        future: _getFuture(deviceId, orderId),
                        builder: (context, snapshotOrder) {
                          String apiText = '...';
                          Color apiColor = statusInfo['color'];

                          if (snapshotOrder.hasData &&
                              snapshotOrder.data != null) {
                            String rawStatus =
                                snapshotOrder.data!['status']?.toString() ?? '';
                            int statusInt = int.tryParse(rawStatus) ?? 0;
                            final statusFromApi = getStatusInfo(statusInt);
                            apiText = statusFromApi['text'];
                            apiColor = statusFromApi['color'];
                          }

                          return FutureBuilder<String>(
                            future: checkPaymentStatus(deviceId),
                            builder: (context, paySnap) {
                              String payText = "กำลังตรวจสอบ...";

                              if (paySnap.hasData) payText = paySnap.data!;

                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  _buildTransactionItem(
                                    context: context,
                                    icon: Icons.online_prediction_sharp,
                                    color: apiColor,
                                    title: '$apiText',
                                    subtitle:
                                        "${formatDate(order['set_at'] ?? '')}",
                                    amount: '$price',
                                    time: formatTime(order['set_at'] ?? ''),
                                    id: orderId,
                                    device_id: deviceId,
                                    status: status,
                                    payment: order['payment'],
                                    paymentStatusText: payText,
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
