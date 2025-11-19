import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_mapwash/Chat/features/video_call/controller/voice_call_controller.dart';

class VoiceCallPage extends StatefulWidget {
  final String channelName;

  const VoiceCallPage({
    Key? key,
    required this.channelName,
  }) : super(key: key);

  @override
  State<VoiceCallPage> createState() => _VoiceCallPageState();
}

class _VoiceCallPageState extends State<VoiceCallPage> {
  late VoiceCallController agoraController;

  @override
  void initState() {
    super.initState();
    // สร้าง controller พร้อม channelName
    agoraController = Get.put(
      VoiceCallController(channel: widget.channelName),
    );
    _startVoiceCall();
  }

  Future<void> _startVoiceCall() async {
    await agoraController.engine.enableAudio();
    await agoraController.engine.muteLocalAudioStream(false);
    // await agoraController.engine.joinChannel(
    //   token: agoraController.token,
    //   channelId: widget.channelName,
    //   uid: 0,
    //   options: const ChannelMediaOptions(),
    // );

    // await agoraController.engine.joinChannel(
    //   agoraController.token,
    //   widget.channelName,
    //   null,
    //   uid: 0,
    // );
    await agoraController.engine.setEnableSpeakerphone(true);
  }

  Future<void> _endCall() async {
    await agoraController.engine.leaveChannel();
    await agoraController.engine.release();
    Get.delete<VoiceCallController>();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _endCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Call – ${widget.channelName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_end, color: Colors.red),
            onPressed: _endCall,
          ),
        ],
      ),
      body: Center(
        child: Obx(() {
          final int count = agoraController.remoteUsers.length;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ผู้เข้าร่วม: $count'),
              const SizedBox(height: 20),
              IconButton(
                icon: Icon(
                  agoraController.isMuted.value ? Icons.mic_off : Icons.mic,
                  size: 36,
                ),
                onPressed: () {
                  // agoraController.toggleMute();
                },
              ),
              const SizedBox(height: 10),
              Text(
                agoraController.isMuted.value ? 'ไมค์ปิด' : 'ไมค์เปิด',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          );
        }),
      ),
    );
  }
}
