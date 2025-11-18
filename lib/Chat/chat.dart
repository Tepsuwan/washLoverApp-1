import 'package:flutter/material.dart';
import 'package:my_flutter_mapwash/Chat/features/create_join_room/join_room_page.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String deviceId;
  final String title;

  const ChatScreen({
    Key? key,
    required this.chatId,
    required this.deviceId,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3FB),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 68, 166, 247),
        elevation: 0,
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(25),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              title, // ใช้ title จาก constructor
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Online',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              deviceId, // ใช้ deviceId ตรง ๆ
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) => JoinRoomPage()),
              // );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JoinRoomPage(
                    deviceId: deviceId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildMessage(isMe: false, message: "Hi Ankur! What’s Up?"),
                  _buildMessage(
                    isMe: true,
                    message:
                        "Oh, hello! All perfectly fine I’m just heading out for something",
                  ),
                  _buildMessage(
                    isMe: true,
                    message:
                        "Yeah sure! I’ll be there this weekend with my brother",
                  ),
                  _buildMessage(isMe: false, message: "Yes! I Am So Happy 😊"),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.add, color: Colors.grey[600]),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Type Your Message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Icon(Icons.send, color: Colors.blue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== ตัวช่วยแสดงข้อความ =====
Widget _buildMessage({required bool isMe, required String message}) {
  return Align(
    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? Colors.green : Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isMe ? Colors.white : Colors.black87,
          fontSize: 15,
        ),
      ),
    ),
  );
}

Widget _buildVoiceMessage({required bool isMe}) {
  return Align(
    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF6C7CFF) : Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_arrow, color: Colors.white),
          SizedBox(width: 5),
          Text(
            "0:12",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    ),
  );
}
