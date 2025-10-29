import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:my_flutter_mapwash/Layouts/main_layout.dart';
import 'package:my_flutter_mapwash/Payment/PaymentFail.dart';
import 'package:my_flutter_mapwash/Payment/PaymentSuccess.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Qrcode extends StatefulWidget {
  @override
  _QrcodeState createState() => _QrcodeState();
}



class _QrcodeState extends State<Qrcode> {
  String displayMessageStatus = "กำลังดำเนินการ";
  String urlLink = "";
  String idWorking = "";
  String amount = "";
  String detail = "";
  String username = "";
  String image = "";
  String status = "";
  String ref = "";
  String dateStr = "";
  String endtime = "";
  String endtimeCount = "";
  String promotionPrice = "";
  String refID = "";
  String ID = "";
  int _remainingSeconds = 29 * 60;
  List<Map<String, dynamic>> addressuser = [];
  List<Map<String, dynamic>> Branch = [];
  late Timer _timer;
  String payment = '';
  List<Map<String, dynamic>> Conferm_Oder = [];
  List<Map<String, dynamic>> jsonData = [];

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            timer.cancel();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _generateRandomString(int length) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    const digits = '0123456789';
    Random rand = Random();
    String randomString = '';
    for (int i = 0; i < length; i++) {
      if (i % 2 == 0) {
        randomString += letters[rand.nextInt(letters.length)];
      } else {
        randomString += digits[rand.nextInt(digits.length)];
      }
    }
    return randomString;
  }

  Future<String?> GetSPFID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('SPFID');
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    initializeDateFormatting('th_TH', null).then((_) {});
    String formattedDate = DateFormat('d MMMM yyyy, E', 'th_TH').format(now);
    String formattedTime = DateFormat('HH:mm').format(now);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 10),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Payment Details (#WASH112)",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.share, color: Colors.pink),
                  ],
                ),
                SizedBox(height: 4),
                Text("$formattedDate", style: TextStyle(color: Colors.grey)),
                Divider(),
                buildInfoRow(
                    "ยูเซอร์", "0987654321", "สถานะ", "กำลังดำเนินการ"),
                buildInfoRow2("เลขอ้างอิง", "wash876fgtgrk4", "จะหมดเวลา",
                    "${_formatTime(_remainingSeconds)} น."),
                buildInfoRow(
                    "รหัสงาน", "#WASH112", "เวลา", "$formattedTime น."),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("จำนวนเงิน:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("฿ 200.00",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 16),
                Image.network(
                  image.isNotEmpty
                      ? image
                      : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR41ht1YjdRUgJ5-jhE-ngXzsDARHIuc3JasMHFCvndLApKv12_kRc9yHBm0Mtz5-MPN3U&usqp=CAU',
                  // width: 300,
                  // height: 250,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "คำเตือน : สามารถสแกน QRCODE ได้เพียงครั้งเดียว ห้ามนำกลับมาใช้ซ้ำเด็ดขาด",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButtonCancle(
                        "ยกเลิก", Colors.grey, Colors.black, context),
                    buildButtonSuccess(
                        "โอนสำเร็จ", Colors.lightGreen, Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(
      String label1, String value1, String label2, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildInfoColumn(label1, value1),
          buildInfoColumn(label2, value2),
        ],
      ),
    );
  }

  Widget buildInfoRow2(
      String label1, String value1, String label2, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildInfoColumn(label1, value1),
          buildInfoColumn2(label2, value2),
        ],
      ),
    );
  }

  Widget buildInfoColumn2(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey)),
        Text(value,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
      ],
    );
  }

  Widget buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey)),
        Text(value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget buildButtonCancle(
      String text, Color bgColor, Color textColor, BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }

  Widget buildButtonSuccess(String text, Color bgColor, Color textColor) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainLayout(),
          ),
          (Route<dynamic> route) => false, // 🔥 ลบทุกหน้าเก่าทิ้งทั้งหมด
        );
      },
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }

  // ฟังก์ชันที่ใช้แสดงการแจ้งเตือน

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('รอดำเนินการ...'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิดการแจ้งเตือน
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
