import 'package:my_flutter_mapwash/Chat/features/create_join_room/join_room_page.dart';
import 'package:my_flutter_mapwash/chat/chat.dart';
// import 'package:my_flutter_mapwash/features/create_join_room/create_room_page.dart';
import 'package:flutter/material.dart';
// import 'package:my_flutter_mapwash/design_system/text_styles.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(
            //   onPressed: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (_) => CreateRoomPage()),
            //   ),
            //   child: Text("สร้างห้องแชท"),
            // ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => JoinRoomPage(deviceId: '',)),
              ),
              child: Text("เข้าร่วมห้องแชท"),
            ),
            SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () => Get.to(() => ChatPage(
            //         userId: '',
            //         token: '',
            //       )),
            //   child: const Text("แชท"),
            // ),
          ],
        ),
      ),
    );
  }
}
