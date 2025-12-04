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
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_flutter_mapwash/Status/API/api_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Qrcode extends StatefulWidget {
  @override
  _QrcodeState createState() => _QrcodeState();
}

class _QrcodeState extends State<Qrcode> {
  String phone = '';
  String displayMessageStatus = "กำลังดำเนินการ";
  String urlLink = "";
  String idWorking = "";
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
  String device_id = "";
  int _remainingSeconds = 29 * 60;
  List<Map<String, dynamic>> addressuser = [];
  List<Map<String, dynamic>> Branch = [];
  late Timer _timer;
  String payment = '';
  List<Map<String, dynamic>> Conferm_Oder = [];
  List<Map<String, dynamic>> jsonData = [];
  List<dynamic> _statusData = [];
  int inNumber = 0;

  String? qrImage;
  // String orderId = ""; // 👈 เปลี่ยนได้
  double amount = 1.0; // 👈 ระบุจำนวนเงิน
  String apiKey = "DRIVER"; // 👈 ใส่ API KEY จริงของคุณ
  bool isCheck = false;
  String? paymentStatus;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    amount = args['totalPrice'];
  }

  @override
  void initState() {
    super.initState();
    getPhone();
    _startCountdown();
    loadStatus();
    loadPhone();
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

  Future<void> generateQR(orderId) async {
    final url =
        "https://payment.washlover.com/create-payment-qr?amount=$amount&order_id=$orderId&ref4=$apiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        qrImage = data["image2"];
        paymentStatus = "กรุณาสแกนเพื่อชำระเงิน";
      });
    } else {
      setState(() {
        paymentStatus = "สร้าง QR ไม่สำเร็จ";
      });
    }
  }

  /// 2) เช็คสถานะการชำระเงิน
  Future<void> checkPaymentStatus(orderId) async {
    final url =
        "https://payment.washlover.com/api/check-payment?ref1=$orderId&ref4=$apiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["data"]["status"] == "success") {
        setState(() {
          paymentStatus = "🎉 ชำระเงินเรียบร้อยแล้ว";
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainLayout(),
            ),
            (Route<dynamic> route) => false, // 🔥 ลบทุกหน้าเก่าทิ้งทั้งหมด
          );
        });
      } else {
        setState(() {
          paymentStatus = "${data["data"]["msg"]}" ?? "รอการชำระเงิน";
        });
      }
    } else {
      setState(() {
        paymentStatus = "เช็คสถานะไม่สำเร็จ";
      });
    }
  }

  Future<void> loadStatus() async {
    String orderId = '';
    try {
      List<dynamic> data = await api_status.fetchstatus();
      final filtered = data.where((e) => e['status'] == 1).toList();
      setState(() {
        _statusData = filtered;
        inNumber = _statusData[0]['status'] ?? 0;
        device_id = _statusData[0]['device_id'] ?? '';
        orderId = _statusData[0]['device_id'] ?? '';
      });
      if (_statusData.isNotEmpty) {
        setState(() {});
        if (isCheck == false) {
          generateQR(orderId);
        }
        isCheck = true;
        checkPaymentStatus(orderId);
      } else {
        generateQR(orderId);
      }
    } catch (e) {
      print('Error loading status: $e');
      setState(() => _statusData = []);
    }
  }

  Future<String?> getPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone');
  }

  void loadPhone() async {
    phone = await getPhone() ?? '';
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
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
                    // ------- เนื้อหาเดิมทั้งหมดของคุณ -------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Payment Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.share, color: Colors.pink),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text("รหัสงาน: $device_id",
                        style: TextStyle(color: Colors.grey)),
                    Divider(),
                    buildInfoRow(
                        "ยูเซอร์", "$phone", "สถานะ", "$paymentStatus"),
                    buildInfoRow2("วันที่", "$formattedDate", "จะหมดเวลา",
                        "${_formatTime(_remainingSeconds)} น."),
                    buildInfoRow3("หมายเลขอ้างอิง", "$device_id"),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "จำนวนเงิน:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "฿ $amount",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    qrImage == null
                        ? Text("กำลังสร้าง QRCODE...")
                        : Image.network(qrImage!, width: 450, height: 450),
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
        ),
      ),
    );
  }

  Widget buildInfoRow3(String label1, String value1) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildInfoColumn(label1, value1),
        ],
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

  Widget buildButtonSuccess(String text, Color bgColor, Color textColor) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: () {
        loadStatus();
        // checkPaymentStatus();
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => MainLayout(),
        //   ),
        //   (Route<dynamic> route) => false, // 🔥 ลบทุกหน้าเก่าทิ้งทั้งหมด
        // );
      },
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }
}
