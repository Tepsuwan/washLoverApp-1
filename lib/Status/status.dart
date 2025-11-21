import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_flutter_mapwash/Chat/chat.dart';
import 'package:my_flutter_mapwash/Chat/test.dart';
import 'package:my_flutter_mapwash/Chat_socket/chat_page.dart' hide ChatScreen;
import 'package:my_flutter_mapwash/Status/API/api_status.dart';
import 'package:my_flutter_mapwash/Status/realtime_status.dart';

class Status extends StatefulWidget {
  const Status({super.key});

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  List<dynamic> _statusData = [];
  final api = ApistatusOrder();
  Timer? _timer;

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
        _futureCache
            .clear(); // เคลียร์ cache เพื่อ FutureBuilder จะเรียก API ใหม่
      });
    });
  }

  Future<void> _loadStatus() async {
    try {
      List<dynamic> data = await api_status.fetchstatus();
      final filtered = data.where((e) => e['status'] != 4).toList();
      setState(() {
        _statusData = filtered;
      });
    } catch (e) {
      print('Error loading status: $e');
      setState(() => _statusData = []);
    }
  }

  Future<Map<String, dynamic>?> _getFuture(String deviceId, String orderId) {
    if (!_futureCache.containsKey(orderId)) {
      _futureCache[orderId] = api.fetchDestinationStatus(deviceId, orderId);
    }
    return _futureCache[orderId]!;
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
  }) {
    return GestureDetector(
      onTap: () {
        _timer?.cancel();

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
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          title: Text(title, style: const TextStyle(fontSize: 14)),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),

          // ✅ เพิ่มไอคอน chat ที่ฝั่งขวา
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // จำนวนเงินและเวลา
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
              // ปุ่มไอคอนแชต
              IconButton(
                icon: const Icon(Icons.chat, color: Colors.blueAccent),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Chat222(),
                    ),
                  );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ChatScreen(
                  //         chatId: id,       // ส่ง id ไปยังหน้าสนทนา. ChatApp
                  //         deviceId: device_id,
                  //         title: title,     // อาจใช้เป็นชื่อหัวแชต
                  //         ),
                  //   ),
                  // );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ChatApp(
                  //         // chatId: id,       // ส่ง id ไปยังหน้าสนทนา. ChatApp
                  //         // deviceId: device_id,
                  //         // title: title,     // อาจใช้เป็นชื่อหัวแชต
                  //         ),
                  //   ),
                  // );
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
        padding: const EdgeInsets.all(16.0),
        child: _statusData.isEmpty
            ? _buildEmptyStatus()
            : ListView.builder(
                itemCount: _statusData.length,
                itemBuilder: (context, index) {
                  final order = _statusData[index];
                  final orderStatus =
                      int.tryParse(order['status']?.toString() ?? '0') ?? 0;
                  if (orderStatus == 4) return const SizedBox.shrink();

                  final price =
                      double.tryParse(order['price']?.toString() ?? '0') ?? 0.0;
                  final statusInfo = getStatusInfo(orderStatus);
                  final deviceId = order['device_id'].toString();
                  final orderId = order['id'].toString();

                  return FutureBuilder<Map<String, dynamic>?>(
                    future: _getFuture(deviceId, orderId),
                    builder: (context, snapshot) {
                      String apiText = '...';
                      Color apiColor = statusInfo['color'];
                      if (snapshot.hasData && snapshot.data != null) {
                        String rawStatus =
                            snapshot.data!['status']?.toString() ?? '';
                        int statusInt = int.tryParse(rawStatus) ?? 0;
                        final statusFromApi = getStatusInfo(statusInt);
                        apiText = statusFromApi['text'];
                        apiColor = statusFromApi['color'];
                      }

                      return _buildTransactionItem(
                        context: context,
                        icon: Icons.online_prediction_sharp,
                        color: apiColor,
                        title: apiText,
                        subtitle: formatDate(order['set_at'] ?? ''),
                        amount:
                            '฿${price < 0 ? 0.0 : price.toStringAsFixed(2)}',
                        time: formatTime(order['set_at'] ?? ''),
                        id: orderId,
                        device_id: deviceId,
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
