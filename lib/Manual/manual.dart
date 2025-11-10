import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_flutter_mapwash/Header/headerOrder.dart';

class manual extends StatelessWidget {
  const manual({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: headerOrder(
        title: 'คู่มือการใช้งาน', // ใส่ title ที่ต้องการแสดง
        onBackPressed: () {
          Navigator.pop(
            context,
          ); // ส่งคูปองที่เลือกกลับไป
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 12),
            Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Image.asset('assets/images/2.png', fit: BoxFit.fitWidth),
                  Image.asset('assets/images/33.png', fit: BoxFit.fitWidth),
                  Image.asset('assets/images/44.png', fit: BoxFit.fitWidth),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(39, 158, 158, 158),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              'assets/images/donot.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(39, 158, 158, 158),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              'assets/images/notop.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            // FAQ Section
            Padding(
              padding: EdgeInsets.all(0),
              child: Column(
                children: [
                  Text(
                    "คำถามที่พบบ่อย",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    "ติดต่อเรา!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "สอบถามเพิ่มเติมได้ที่นี่ ทีมงานของเรายินดีช่วยคุณ",
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  buildContactItem(Icons.location_on,
                      "888/1 หมู่ที่ 3 ตำบลขอนยาง\nอ.กันทรวิชัย จ.มหาสารคาม 44150"),
                  buildContactItem(Icons.phone, "080-339-6668"),
                  buildContactItem(Icons.email, "washlover247@gmail.com"),
                  buildContactItem(Icons.language, "www.washlover.com"),
                ],
              ),
            ),
            SizedBox(height: 0),
            Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  buildContactButton("LINE", Colors.green, Icons.chat, () {
                    print("เปิด LINE");
                  }),
                  buildContactButton(
                      "FACEBOOK MESSENGER", Colors.blue, Icons.facebook, () {
                    print("เปิด Facebook Messenger");
                  }),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(0),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                'assets/images/facebook.png',
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: GoogleFonts.prompt(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _stepText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: GoogleFonts.prompt(
          fontSize: 15,
          color: Colors.black87,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _walletItem2(Widget img, String title, String value) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white,
          child: img,
        ),
        SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.blue),
        ),
      ],
    );
  }

  Widget _walletItem(Widget img, String title, String value) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white,
          child: img,
        ),
        SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.blue),
        ),
      ],
    );
  }

  Widget _duckItem(Widget img, String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white,
          child: img,
        ),
        SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _menuItem(Widget img, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color.fromARGB(255, 245, 245, 245),
            child: img,
          ),
          SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget buildContactButton(
      String text, Color color, IconData icon, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(text, style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }

  Widget buildContactItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 24),
          SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Widget buildExpansionTile(String title, String content,
      {bool isExpanded = false}) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      initiallyExpanded: isExpanded, // ทำให้ Tile แรกเปิดอยู่
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(content, style: TextStyle(color: Colors.black54)),
        ),
      ],
    );
  }

  Widget buildInfoItem(IconData icon, String title, String amount) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue[200]),
        Text(title, style: TextStyle(fontSize: 12, color: Colors.black54)),
        Text(amount,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.amber)),
      ],
    );
  }
}
