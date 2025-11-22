import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Chat222 extends StatefulWidget {
  const Chat222({super.key});

  @override
  State<Chat222> createState() => _Chat222State();
}

class _Chat222State extends State<Chat222> {
  late final WebViewController _controller; 
  final TextEditingController _textController = TextEditingController();
  bool _elementsReady = false; 
  bool _isLoading = true;

  final String url =
      'https://chat.washlover.com/?chat_id=1111&name=wi222&status=';

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)

      // ⭐ ช่องทางรับข้อความจากเว็บ
      ..addJavaScriptChannel(
        'ChatMessage',
        onMessageReceived: (data) {
          print("📩 NEW INCOMING MESSAGE: ${data.message}");

          // แจ้งเตือนผู้ใช้
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("ข้อความใหม่: ${data.message}"),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      )

      ..addJavaScriptChannel(
        'FlutterReady',
        onMessageReceived: (message) {
          setState(() {
            _elementsReady = true;
            _isLoading = false;
          });
          print('JS ready message: ${message.message}');
        },
      )

      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            print('Page finished loading: $url');

            // ⭐ Inject JS ดักจับข้อความใหม่
            await _controller.runJavaScript('''
              // รอ element พร้อมก่อนค่อยเริ่มตรวจข้อความ
              function waitForElements() {
                const input = document.querySelector('input[type=text]');
                const sendButton = document.querySelector('button[type=submit]');
                const messageBoxes = document.querySelectorAll('.message, .chat-message, .msg');

                if (input && sendButton) {
                  
                  window.sendMessageToChat = function(message) {
                    input.value = message;
                    sendButton.click();
                    console.log("ส่งข้อความสำเร็จ: " + message);
                  }

                  FlutterReady.postMessage("ready");

                  // ⭐ เริ่มจับข้อความใหม่
                  let lastCount = messageBoxes.length;

                  function detectNewMessage() {
                    const msgs = document.querySelectorAll('.message, .chat-message, .msg');
                    if (msgs.length > lastCount) {
                      const newMsg = msgs[msgs.length - 1].innerText;
                      ChatMessage.postMessage(newMsg);
                      lastCount = msgs.length;
                    }
                    setTimeout(detectNewMessage, 800);
                  }

                  detectNewMessage();

                } else {
                  setTimeout(waitForElements, 100);
                }
              }

              waitForElements();
            ''');
          },

          onWebResourceError: (error) {
            print('WebView Error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  void _sendMessage() {
    final message = _textController.text.trim();
    if (message.isEmpty) return;

    final escapedMessage = jsonEncode(message);

    _controller.runJavaScript('''
      if (window.sendMessageToChat) {
        sendMessageToChat($escapedMessage);
        console.log("เรียก sendMessageToChat เรียบร้อย");
      } else {
        console.log("sendMessageToChat ยังไม่พร้อม");
      }
    ''');

    _textController.clear();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WashLover Chat Native')),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: WebViewWidget(
                  key: const ValueKey('webview'),
                  controller: _controller,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Colors.grey[200],
                // child: Row(
                //   children: [
                //     Expanded(
                //       child: TextField(
                //         controller: _textController,
                //         decoration:
                //             const InputDecoration(hintText: 'พิมพ์ข้อความ...'),
                //         onSubmitted: (_) =>
                //             _elementsReady ? _sendMessage() : null,
                //       ),
                //     ),
                //     IconButton(
                //       icon: const Icon(Icons.send),
                //       onPressed: _elementsReady ? _sendMessage : null,
                //     ),
                //   ],
                // ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
