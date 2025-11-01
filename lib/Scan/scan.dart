import 'dart:async';
import 'package:flutter/material.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  Widget _buildEmptyScan() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/collectionduck/Artboard21copy10.png',
            width: 120,
            height: 90,
          ),
          const SizedBox(height: 10),
          Text(
            'เปิดใช้งานในเร็วๆนี้',
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
        body: Padding(
            padding: const EdgeInsets.all(16.0), child: _buildEmptyScan()));
  }
}
