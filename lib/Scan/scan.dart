// import 'dart:async';
// import 'package:flutter/material.dart';

// class Scan extends StatefulWidget {
//   const Scan({super.key});

//   @override
//   _ScanState createState() => _ScanState();
// }

// class _ScanState extends State<Scan> {
//   Widget _buildEmptyScan() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Image.asset(
//             'assets/images/collectionduck/Artboard21copy10.png',
//             width: 120,
//             height: 90,
//           ),
//           const SizedBox(height: 10),
//           Text(
//             'เปิดใช้งานในเร็วๆนี้',
//             style: TextStyle(color: Colors.grey[600], fontSize: 18),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment:
//               MainAxisAlignment.center, // จัดให้อยู่ตรงกลางแนวตั้ง
//           crossAxisAlignment:
//               CrossAxisAlignment.center, // จัดให้อยู่ตรงกลางแนวนอน
//           children: [
//             _buildEmptyScan(),
//             const SizedBox(height: 20), // ระยะห่างระหว่าง widget
//             // ElevatedButton(
//             //   onPressed: () {
//             //     print("ปุ่มถูกกดแล้ว!");
//             //   },
//             //   style: ElevatedButton.styleFrom(
//             //     backgroundColor: Colors.blue, // สีพื้นหลังของปุ่ม
//             //     foregroundColor: Colors.white, // สีตัวอักษร
//             //     padding:
//             //         const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//             //     shape: RoundedRectangleBorder(
//             //       borderRadius: BorderRadius.circular(8),
//             //     ),
//             //   ),
//             //   child: const Text(
//             //     "เริ่มสแกน",
//             //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:my_flutter_mapwash/Oders/Share/SummaryPage.dart';
import 'package:my_flutter_mapwash/Oders/Share/shareorder.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  List<Map<String, dynamic>> items = [
    {
      "name": "เครื่องซักผ้า",
      "detail": "ขนาด 16 kg.",
      "price": "50",
      "quantity": "2",
      "image": "assets/images/sakpa.png",
    },
    {
      "name": "เครื่องอบผ้า",
      "detail": "ขนาด 16 kg.",
      "price": "70",
      "quantity": "1",
      "image": "assets/images/ooppa2.png",
    },
    {
      "name": "น้ำยาซักผ้า",
      "detail": "น้ำยาซักผ้าอย่างอ่อนโยน",
      "price": "120",
      "quantity": "1",
      "image": "assets/images/notag.png",
    },
    {
      "name": "น้ำยาปรับผ้านุ่ม",
      "detail": "น้ำยาอย่างอ่อนโยน",
      "price": "30",
      "quantity": "3",
      "image": "assets/images/notag.png",
    },
    {
      "name": "อุณหภูมิน้ำ",
      "detail": "อุณหภูมิน้ำเย็น",
      "price": "30",
      "quantity": "3",
      "image": "assets/images/water01.png",
    },
  ];

  // ✅ เพิ่ม List<bool> เพื่อเก็บสถานะการเลือก
  late List<bool> selected;

  @override
  void initState() {
    super.initState();
    selected = List<bool>.filled(items.length, false);
  }

  void _toggleSelect(int index) async {
    setState(() {
      selected[index] = !selected[index];
    });
   _saveSelections();
  }

  void _saveSelections() async {
    final selectedItems = [
      for (int i = 0; i < items.length; i++)
        if (selected[i]) items[i]
    ];
    await SharePrefs.saveItems(selectedItems);
  }

  void _goToSummary() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SummaryPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เลือกอุปกรณ์ซักผ้า')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, i) {
          final item = items[i];
          return Card(
            child: ListTile(
              leading: Image.asset(item['image'], width: 50),
              title: Text(item['name']),
              subtitle: Text('${item['detail']} | ${item['price']} บาท'),
              trailing: Checkbox(
                value: selected[i],
                onChanged: (_) => _toggleSelect(i),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _goToSummary,
          child: const Text('ดูสรุป'),
        ),
      ),
    );
  }
}
