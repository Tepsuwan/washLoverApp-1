import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:my_flutter_mapwash/Chat_socket/socket.io.dart';

final onTapMenu = StateProvider<bool>((ref) => false);
final slideTopProvider = StateProvider<bool>((ref) => true);

class Message {
  final String msg;
  final String user; // ID ของผู้ส่ง (เช่น 'user123' คือตัวเรา)
  final DateTime timestamp;

  Message({required this.msg, required this.user, required this.timestamp});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      msg: json['msg'] as String,
      user: json['user'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

class GetListMessenger extends StateNotifier<List<Message>> {
  GetListMessenger(this.ref) : super([]) {
    build();
  }

  final Ref ref;

  void build() {
    var x = [
      Message(
        msg: 'สวัสดีครับ เป็นยังไงบ้าง?',
        user: 'user456',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Message(
        msg: 'สบายดีครับ! คุณล่ะ?',
        user: 'user123',
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
    ];

    state = x;
  }
}

final chatListProvider = StateNotifierProvider<GetListMessenger, List<Message>>((ref) {
  return GetListMessenger(ref);
});

//-------------------

// State เป็นรายการข้อความทั้งหมด
typedef ChatState = List<Message>;

final chatNotifierProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final service = SocketService();

  return ChatNotifier(service);
});

class ChatNotifier extends StateNotifier<ChatState> {
  final SocketService _socketService;

  // ChatNotifier(this._socketService) : super([]) {
  // 3. เริ่มฟัง Stream จาก SocketService ทันทีที่ Notifier ถูกสร้าง
  //   _socketService.messageStream.listen((newMessage) {
  //     // เมื่อได้รับข้อความใหม่ ให้เพิ่มข้อความนั้นลงในรายการสถานะ (state)
  //     // Riverpod จะแจ้งเตือน UI ให้ทำการ rebuild
  //     print('newMessage');
  //     print(newMessage);
  //     state = [...state, newMessage];
  //   });
  // }

  ChatNotifier(this._socketService) : super([]);

  // เมธอดสำหรับส่งข้อความ (UI จะเรียกเมธอดนี้)
  void send(String text, String senderId, String room) {
    _socketService.sendMessage(text, senderId, room);

    // *ทางเลือก*: เพิ่มข้อความที่ส่งทันทีในรายการแชทก่อนรอการตอบกลับจาก server
    // เพื่อให้ UI รู้สึกว่าเร็วขึ้น (Optimistic Update)
    final tempMessage = Message(msg: text, user: senderId, timestamp: DateTime.now());
    state = [...state, tempMessage];
  }

  void addChat(Message tempMessage) {
    // *ทางเลือก*: เพิ่มข้อความที่ส่งทันทีในรายการแชทก่อนรอการตอบกลับจาก server
    // เพื่อให้ UI รู้สึกว่าเร็วขึ้น (Optimistic Update)
    // final tempMessage = Message(msg: text, user: senderId, timestamp: DateTime.now());
    state = [...state, tempMessage];
  }

  void clearChat() {
    // *ทางเลือก*: เพิ่มข้อความที่ส่งทันทีในรายการแชทก่อนรอการตอบกลับจาก server
    // เพื่อให้ UI รู้สึกว่าเร็วขึ้น (Optimistic Update)
    // final tempMessage = Message(msg: text, user: senderId, timestamp: DateTime.now());
    state = [];
  }

  Future<void> getChat(String room) async {
    print('getChat');
    final dio = Dio();
    String path = '${kSocketUrl}/api/history/${room}';
    print(path);
    final resApi = await dio.get(path);

    print('resApi----s');
    print(resApi.statusCode);
    print(resApi.data);
    if (resApi.statusCode == 200) {
      List<dynamic> jsonList = resApi.data;
      List<Message> listMessage = jsonList.map((item) => Message.fromJson(item)).toList();

      state = listMessage;
    }
  }
}
