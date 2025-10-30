import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_flutter_mapwash/Header/headerOrder.dart';
import 'package:my_flutter_mapwash/Home/API/api_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  static const Color lightBlue = Color(0xFFE8F1FF);
  static const Color primaryBlue = Color(0xFF1E62F9);

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  List<dynamic> _historyData = [
    // {
    //   'date': '2025-10-15',
    //   'time': '14:30',
    //   'status': 'completed',
    //   'price_net': 150.75,
    //   // 'phone': '0812345678',
    // },
  ];
  Future<void> _loadHistory() async {
    try {
      List<dynamic> data = await api_history.fetchHistory();

      setState(() {
        if (data.isNotEmpty) {
          _historyData = data; // มีข้อมูล → แสดงเลย
        } else {
          _historyData = []; // ไม่มีข้อมูล → แสดงว่าไม่มีประวัติ
        }
      });
    } catch (e) {
      print('Error loading history: $e');
      setState(() => _historyData = []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: headerOrder(
        title: 'ประวัติการทำรายการ',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(169, 80, 171, 245), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Container(
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage('assets/images/news.png'),
          //       fit: BoxFit.cover,
          //       opacity: 0.4,
          //     ),
          //   ),
          // ),
          ////////////////////////////////////////// ประวัติรายการ //////////////////////////////////////////
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBalanceCard(),

                // ====== หัวข้อส่วนบน ======
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'ประวัติรายการ',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          color: Color(0xFF1B1B1B),
                        ),
                      ),
                      Text(
                        'ต.ค. 2568',
                        style: TextStyle(
                          color: Color(0xFF8A8A8A),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1.2,
                          color: Colors.grey.withOpacity(0.15),
                        ),
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding:
                      EdgeInsets.only(left: 24, right: 24, top: 6, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'อัปเดตล่าสุดเมื่อ 21 ต.ค. 2568 เวลา 18:45',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                // ====== เนื้อหา ======
                Expanded(
                  child: _historyData.isEmpty
                      ? _buildEmptyHistory()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
                          itemCount: _historyData.length,
                          itemBuilder: (context, index) {
                            var item = _historyData[index];
                            String date = item['set_at'] ?? '-';
                            String time = item['started_at'] ?? '-';
                            String status = (item['status'] ?? '').toString();
                            String price = item['duration_str'] ?? '0.0';

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFDFEFF),
                                    Color(0xFFF7F9FF),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {},
                                  splashColor:
                                      const Color(0xFF1E62F9).withOpacity(0.08),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // ===== ไอคอน =====
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF4E9FFF),
                                                Color(0xFF1E62F9)
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.blueAccent
                                                    .withOpacity(0.25),
                                                blurRadius: 8,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.local_laundry_service_rounded,
                                            color: Colors.white,
                                            size: 26,
                                          ),
                                        ),

                                        const SizedBox(width: 16),

                                        // ===== ข้อมูล =====
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                formatThaiDate(date, time),
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              // Text(
                                              //   _getStatusText(status),
                                              //   style: const TextStyle(
                                              //     fontSize: 16,
                                              //     fontWeight: FontWeight.w600,
                                              //     color: Colors.black87,
                                              //   ),
                                              // ),
                                              // const SizedBox(height: 6),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: _getStatusColor(status)
                                                      .withOpacity(
                                                          0.25), // เข้มขึ้นจาก 0.1 → 0.25
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: _getStatusColor(
                                                            status)
                                                        .withOpacity(
                                                            0.5), // เสริมขอบเข้มเล็กน้อย
                                                    width: 1,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: _getStatusColor(
                                                              status)
                                                          .withOpacity(
                                                              0.15), // เพิ่มเงาเบา ๆ
                                                      blurRadius: 4,
                                                      offset:
                                                          const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  _getStatusText(status),
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors
                                                        .white, // เปลี่ยนเป็นขาวให้ตัดกับพื้นสี
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // ===== ราคา =====
                                        Text(
                                          '฿$price',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                            color: Color(0xFF1E62F9),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHistoryList() {
    return ListView.builder(
      itemCount: _historyData.length,
      itemBuilder: (context, index) {
        final item = _historyData[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue, // แบล็คกราวน์สีน้ำเงิน
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${item['date']}',
                  style: TextStyle(color: Colors.white)),
              Text('Time: ${item['time']}',
                  style: TextStyle(color: Colors.white)),
              Text('Status: ${item['status']}',
                  style: TextStyle(color: Colors.white)),
              Text('Price Net: \$${item['price_net']}',
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white, // พื้นหลังสีขาวล้วน
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage('assets/images/news.png'),
                  fit: BoxFit.cover,
                  opacity: 0.05,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(width: 6),
                      Text(
                        'ยอดเงินคงเหลือ',
                        style: TextStyle(
                          color: Color(0xFF666666), // สีเทาเข้มแบบเรียบๆ
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 6),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '฿0.00',
                    style: TextStyle(
                      color: Colors.grey[800], // สีเทาเข้มหน่อย
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Transform.rotate(
                            angle: -0.3, // หมุนไปทางซ้ายเล็กน้อย
                            child: Image.asset('assets/images/duck.png',
                                width: 80, height: 40),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'คูปอง',
                            style: TextStyle(
                                color: Color(0xFF888888), fontSize: 18),
                          ),
                          const Text(
                            '0',
                            style: TextStyle(
                                color: Color.fromARGB(255, 131, 124, 124),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Transform.rotate(
                            angle: 0.5, // หมุนไปทางขวาเล็กน้อย
                            child: Image.asset('assets/images/duck.png',
                                width: 80, height: 40),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'คะแนนสะสม',
                            style: TextStyle(
                                color: Color(0xFF888888), fontSize: 18),
                          ),
                          const Text(
                            '0',
                            style: TextStyle(
                                color: Color(0xFF444444),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          // ไม่หมุนเลย ปกติ
                          Image.asset('assets/images/duck.png',
                              width: 80, height: 40),
                          const SizedBox(height: 4),
                          const Text(
                            'เครดิต',
                            style: TextStyle(
                                color: Color(0xFF888888), fontSize: 18),
                          ),
                          const Text(
                            '0',
                            style: TextStyle(
                                color: Color(0xFF444444),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Positioned(top: 10, left: 20, child: _bubble(50)),
            Positioned(top: 40, right: 50, child: _bubble(30)),
            Positioned(bottom: 30, left: 30, child: _bubble(45)),
            Positioned(bottom: 20, right: 20, child: _bubble(30)),
            Positioned(top: 80, left: 100, child: _bubble(35)),
          ],
        ),
      ),
    );
  }

  String formatThaiDate(String date, String time) {
    final monthsThai = [
      'ม.ค.',
      'ก.พ.',
      'มี.ค.',
      'เม.ย.',
      'พ.ค.',
      'มิ.ย.',
      'ก.ค.',
      'ส.ค.',
      'ก.ย.',
      'ต.ค.',
      'พ.ย.',
      'ธ.ค.'
    ];

    try {
      String dateTimeString;
      if (date.contains('T')) {
        dateTimeString = date;
      } else {
        dateTimeString = time.isNotEmpty ? '$date $time' : date;
      }
      DateTime dt = DateTime.parse(dateTimeString).toLocal();
      final buddhistYear = dt.year + 543;
      final thaiMonth = monthsThai[dt.month - 1];
      final formattedTime =
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      return '${dt.day} $thaiMonth $buddhistYear $formattedTime น.';
    } catch (e) {
      return '$date ${time ?? ''}'.trim();
    }
  }

// ฟังก์ชันช่วยสร้างไอเท็มแสดงข้อมูล พร้อมพารามิเตอร์สี
  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value, {
    Color textColor = Colors.black,
    Color labelColor = Colors.black54,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 36,
          color: textColor,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _bubble(double size) {
    final icons = [
      Icons.favorite,
      Icons.star_rounded,
      Icons.circle,
    ];
    final icon = (icons..shuffle()).first;

    final colors = [
      const Color.fromARGB(255, 255, 127, 127),
      const Color.fromARGB(255, 129, 186, 255),
      const Color.fromARGB(255, 79, 170, 255),
      const Color.fromARGB(255, 115, 181, 247),
      const Color.fromARGB(255, 48, 162, 255),
    ];
    final color = (colors..shuffle()).first.withOpacity(0.12);
    final rotation = ([-0.2, 0.1, 0.3]..shuffle()).first;
    return Transform.rotate(
      angle: rotation,
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );
  }

  Widget _buildHistoryCard(dynamic item) {
    String date = item['date'];
    String time = item['time'];
    String status = item['status'];
    // String phone = item['phone'];
    double price = item['price_net'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue[50],
            ),
            child: const Icon(Icons.access_time,
                color: Colors.blueAccent, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatThaiDate(date, time),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    _statusChip(status, _getStatusColor(status)),
                    const SizedBox(width: 6),
                    _statusChip("washing", Colors.blueAccent),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '฿${price.toStringAsFixed(2)}',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  Widget _buildEmptyHistory() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 60,
            ),
            const SizedBox(height: 10),
            Text(
              'ไม่มีประวัติการใช้งาน',
              style: TextStyle(color: Colors.grey[600], fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case '4': // เสร็จสิ้น
        return const Color(0xFF2ECC71); // เขียวสด
      case '3': // ไม่สำเร็จ
        return const Color(0xFFE74C3C); // แดงเข้ม
      case '2': // คนขับรับงานแล้ว
        return const Color(0xFF3498DB); // ฟ้าน้ำทะเล
      case '1': // รอคนขับ
        return const Color(0xFFF1C40F); // เหลืองทอง
      default:
        return Colors.grey; // เผื่อค่าที่ไม่ตรง
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case '4':
        return 'เสร็จสิ้น';
      case '3':
        return 'ไม่สำเร็จ';
      case '2':
        return 'คนขับรับงานแล้ว';
      case '1':
        return 'รอคนขับ';
      default:
        return 'ไม่ทราบสถานะ';
    }
  }
}
