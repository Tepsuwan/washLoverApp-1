import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_webrtc/flutter_webrtc.dart';


class ChatApp extends StatelessWidget {
  const ChatApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat & Call App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const JoinScreen(),
    );
  }
}

// =====================
// หน้าสำหรับ Join ห้อง
// =====================
class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final nameController = TextEditingController();
  final roomController = TextEditingController();

  void _joinRoom() {
    final name = nameController.text.trim();
    final room = roomController.text.trim();
    if (name.isEmpty || room.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกชื่อและชื่อห้อง')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatRoomScreen(username: name, room: room),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0f2f5),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black26)],
          ),
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('เข้าร่วมแชท',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'ชื่อของคุณ'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: roomController,
                decoration: const InputDecoration(labelText: 'ชื่อห้อง'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _joinRoom,
                child: const Text('เข้าร่วม'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// =====================
// หน้าห้องแชทหลัก
// =====================
class ChatRoomScreen extends StatefulWidget {
  final String username;
  final String room;
  const ChatRoomScreen({super.key, required this.username, required this.room});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late IO.Socket socket;
  final msgController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];
  List<Map<String, String>> users = [];

  // WebRTC
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  final localRenderer = RTCVideoRenderer();
  final remoteRenderer = RTCVideoRenderer();
  bool inCall = false;

  @override
  void initState() {
    super.initState();
    _initRenderers();
    _connectSocket();
  }

  Future<void> _initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  void _connectSocket() {
    socket = IO.io(
      'https://${Uri.base.host}', // หรือกำหนดตรงๆ เช่น https://your-server.com
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      debugPrint('Connected: ${socket.id}');
      socket.emit('join', {'username': widget.username, 'room': widget.room});
    });

    socket.on('receive_message', (data) {
      setState(() {
        messages.add({'user': data['username'], 'msg': data['message']});
      });
      _scrollToBottom();
    });

    socket.on('room_users_updated', (data) {
      final list = List<Map<String, String>>.from(data['users']
          .map((u) => {'sid': u['sid'], 'username': u['username']}));
      setState(() {
        users = list;
      });
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _sendMessage() {
    final msg = msgController.text.trim();
    if (msg.isEmpty) return;
    socket.emit('send_message', {
      'username': widget.username,
      'room': widget.room,
      'message': msg,
    });
    msgController.clear();
  }

  // =============== VIDEO CALL ===============

  Future<void> _startCall(String targetSid, String targetUser) async {
    // (ตัวอย่าง: โชว์ dialog)
    showDialog(
      context: context,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    await _initWebRTC();
    Navigator.pop(context);
    setState(() => inCall = true);
  }

  Future<void> _initWebRTC() async {
    localStream = await navigator.mediaDevices
        .getUserMedia({'video': true, 'audio': true});
    localRenderer.srcObject = localStream;
  }

  void _hangUp() {
    localStream?.getTracks().forEach((t) => t.stop());
    setState(() => inCall = false);
  }

  @override
  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room),
        actions: [
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                socket.emit('leave', {
                  'username': widget.username,
                  'room': widget.room,
                });
                Navigator.pop(context);
              })
        ],
      ),
      body: inCall ? _buildVideoCallUI() : _buildChatUI(),
    );
  }

  Widget _buildChatUI() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              final isMe = msg['user'] == widget.username;
              return Align(
                alignment:
                    isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe
                        ? const Color(0xffdcf8c6)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: Offset(0, 1))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (!isMe)
                        Text(msg['user']!,
                            style: const TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.bold)),
                      Text(msg['msg'] ?? ''),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: const Color(0xfff0f2f5),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: msgController,
                  decoration:
                      const InputDecoration.collapsed(hintText: 'พิมพ์ข้อความ...'),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoCallUI() {
    return Stack(
      children: [
        RTCVideoView(remoteRenderer, mirror: true),
        Positioned(
          right: 16,
          top: 16,
          width: 120,
          height: 160,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: RTCVideoView(localRenderer, mirror: true),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: _hangUp,
              child: const Icon(Icons.call_end),
            ),
          ),
        ),
      ],
    );
  }
}
