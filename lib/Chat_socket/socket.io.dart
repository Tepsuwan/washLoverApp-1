import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_mapwash/Chat_socket/controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// 1. กำหนด URL ของ Server
const String kSocketUrl = 'https://chat.washlover.com'; // *ต้องเปลี่ยนเป็น IP จริง*

class SocketService {
  late IO.Socket _socket;

  // Stream Controllers เหมือนเดิม
  // final _messageController = StreamController<Message>.broadcast();
  //
  // Stream<Message> get messageStream => _messageController.stream;

  SocketService() {
    _socket = IO.io(kSocketUrl, IO.OptionBuilder().setTransports(['websocket']).build());
  }

  void connect(String currentUsername, String room, WidgetRef ref) {
    _socket.onConnect((_) {
      print('Socket Connected!');
      if (_socket.connected) {
        _socket.emit('join', {'username': currentUsername, 'room': room});
        print(_socket.receiveBuffer);
        print(_socket.sendBuffer);
        print(_socket.id);

        print('Emitted joinRoom event for room: $room');
        print('Emitted joinRoom event for currentUsername: $currentUsername');

        ref.read(chatNotifierProvider.notifier).getChat(room);
      } else {
        print('Socket not connected, cannot join room.');
      }
    });
    _socket.onDisconnect((_) {
      print('Socket Disconnected!');
    });
    _socket.onError((data) {
      print('Socket Error: $data');
    });
    _socket.on('status', (data) {
      print('Socket status: $data');
    });
    _socket.on('webrtc_answer_received', (data) {
      print('Socket webrtc_answer_received: $data');
    });
    _socket.on('room_users_updated', (data) {
      print('Socket room_users_updated: $data');
    });

    _socket.on('incoming_call', (data) {
      print('Socket incoming_call: $data');
    });

    // ตั้งค่า Listener สำหรับรับข้อความ
    _socket.on('receive_message', (data) {
      print('Socket receive_message: $data');
      try {
        final message = Message.fromJson(data);
        // _messageController.add(message);
        print(message.user);
        print(currentUsername);
        if (message.user != currentUsername) {
          print('1');
          ref.read(chatNotifierProvider.notifier).addChat(message);
        }

        // print('Socket ----- data: $data');
      } catch (e) {
        print('Error parsing message: $e');
      }

      // แปลงข้อมูลที่ได้รับจาก Server (Map<String, dynamic>) เป็น Object ChatMessage
      // final message = Message.fromJson(data);
      // _messageController.sink.add(message);
      // print('Socket ----- data: $data');
    });
  }

  void sendMessage(String text, String senderId, String room) {
    if (_socket.connected) {
      _socket.emit('send_message', {'username': senderId, 'room': room, 'message': text});
      // _socket.emit('send_message', {'text': text, 'senderId': senderId, 'timestamp': DateTime.now().toIso8601String()});
    }
  }

  void disconnect() {
    _socket.dispose();
    // _messageController.close();
  }
}
