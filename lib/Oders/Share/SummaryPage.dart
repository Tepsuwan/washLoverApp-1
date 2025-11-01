import 'package:flutter/material.dart';
import 'package:my_flutter_mapwash/Oders/Share/shareorder.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: SharePrefs.getItems(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final items = snapshot.data!;
        return Scaffold(
          appBar: AppBar(title: const Text('สรุปรายการที่เลือก')),
          body: items.isEmpty
              ? const Center(child: Text('ยังไม่ได้เลือกรายการ'))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return Card(
                      child: ListTile(
                        leading: Image.asset(item['image'], width: 50),
                        title: Text(item['name']),
                        subtitle: Text(
                          '${item['detail']}\nจำนวน ${item['quantity']} ชิ้น | ราคา ${item['price']} บาท',
                        ),
                      ),
                    );
                  },
                ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () async {
                await SharePrefs.clearItems();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('🧹 ล้างข้อมูลเรียบร้อย')),
                );
              },
              child: const Text('ล้างข้อมูล'),
            ),
          ),
        );
      },
    );
  }
}
