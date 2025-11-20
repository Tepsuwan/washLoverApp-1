import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_mapwash/Chat/features/video_call/controller/simple_call_controller.dart';
import 'package:my_flutter_mapwash/Chat/features/video_call/view/voice_call_page.dart';

class IncomingCallPage extends StatelessWidget {
  final String callId;
  final String callerId;
  final String channelId;

  final SimpleCallController controller = Get.put(SimpleCallController());

  IncomingCallPage({
    required this.callId,
    required this.callerId,
    required this.channelId,
  }) {
    controller.callId = callId;
    controller.channelId = channelId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Incoming Call from $callerId",
                style: TextStyle(color: Colors.white, fontSize: 20)),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                controller.acceptCall();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VoiceCallPage(channelName: channelId),
                  ),
                );
              },
              child: Text("Accept"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.rejectCall();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Reject"),
            ),
          ],
        ),
      ),
    );
  }
}
