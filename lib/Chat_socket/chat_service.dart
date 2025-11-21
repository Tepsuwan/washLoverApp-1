import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  late IO.Socket socket;

  void connect({
    required String username,
    required String room,
  }) {
    socket = IO.io(
      'https://chat.washlover.com',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      print("Connected to server");

      // Join room
      socket.emit('join', {
        "username": username,
        "room": room,
      });
    });

    socket.on('receive_message', (data) {
      print("New message: $data");
      onMessageReceived?.call(data);
    });
  }

  Function(Map<String, dynamic>)? onMessageReceived;

  void sendMessage(String username, String room, String message) {
    socket.emit("send_message", {
      "username": username,
      "room": room,
      "message": message,
    });
  }

  void disconnect(String username, String room) {
    socket.emit('leave', {
      "username": username,
      "room": room,
    });
    socket.disconnect();
  }
}
