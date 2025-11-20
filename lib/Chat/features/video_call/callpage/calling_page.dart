import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_mapwash/Chat/features/video_call/controller/simple_call_controller.dart';
import 'package:my_flutter_mapwash/Chat/features/video_call/view/voice_call_page.dart';

class CallingPage extends StatelessWidget {
  final SimpleCallController controller = Get.put(SimpleCallController());

  final String callerId;
  final String receiverId;

  CallingPage({required this.callerId, required this.receiverId});

  @override
  Widget build(BuildContext context) {
    controller.startCall(callerId, receiverId);

    return StreamBuilder(
      stream: controller.callStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox();

        final data = snapshot.data!.data();
        final status = data?["status"];
        final channelId = data?["channelId"];

        if (status == "accepted") {
          return VoiceCallPage(channelName: channelId);
        }

        if (status == "rejected") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
          });
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Calling $receiverId ...",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                SizedBox(height: 20),
                CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        );
      },
    );
  }
}
