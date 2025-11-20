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

    agoraController = Get.put(
      VoiceCallController(channel: widget.channelName),
      permanent: false,
    );
  }

  Future<void> _endCall() async {
    agoraController.endCall();

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    if (Get.isRegistered<VoiceCallController>()) {
      Get.delete<VoiceCallController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3C3C3C),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TOP SECTION
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Obx(() {
                  return Column(
                    children: [
                      Text(
                        '${agoraController.remoteUsers.length}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        agoraController.meetingDurationTxt.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                }),
              ),

              // CONTROL BUTTONS 3x2
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /// Mute button
                      Obx(() => _buildControlButton(
                            icon: agoraController.isMuted.value
                                ? Icons.mic_off
                                : Icons.mic,
                            label: 'mute',
                            onPressed: agoraController.toggleMute,
                            backgroundColor: agoraController.isMuted.value
                                ? Colors.white
                                : Colors.white54,
                            iconColor: agoraController.isMuted.value
                                ? Colors.black
                                : Colors.white,
                            iconSize: 35,
                          )),

                      _buildControlButtonNon(
                        icon: Icons.dialpad,
                        label: 'keypad',
                        onPressed: () {},
                        iconSize: 35,
                      ),

                      /// Speaker button
                      Obx(() => _buildControlButton(
                            icon: agoraController.isSpeakerOn.value
                                ? Icons.volume_up
                                : Icons.volume_down,
                            label: 'speaker',
                            onPressed: agoraController.toggleSpeaker,
                            backgroundColor: agoraController.isSpeakerOn.value
                                ? Colors.white
                                : Colors.white54,
                            iconColor: agoraController.isSpeakerOn.value
                                ? Colors.black
                                : Colors.white,
                            iconSize: 35,
                          )),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildControlButtonNon(
                        icon: Icons.add,
                        label: 'add call',
                        onPressed: () {},
                        iconSize: 35,
                      ),
                      _buildControlButtonNon(
                        icon: Icons.videocam,
                        label: 'FaceTime',
                        onPressed: () {},
                        iconSize: 35,
                      ),
                      _buildControlButtonNon(
                        icon: Icons.group,
                        label: 'contacts',
                        onPressed: () {},
                        iconSize: 35,
                      ),
                    ],
                  ),
                ],
              ),

              // END CALL BUTTON
              GestureDetector(
                onTap: _endCall,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.call_end,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildControlButton({
  required IconData icon,
  required String label,
  required VoidCallback onPressed,
  double iconSize = 28,
  Color backgroundColor = Colors.white54,
  Color iconColor = Colors.white,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: iconSize, color: iconColor),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    ],
  );
}

Widget _buildControlButtonNon({
  required IconData icon,
  required String label,
  required VoidCallback onPressed,
  double iconSize = 28,
  Color backgroundColor = Colors.white54,
  Color iconColor = Colors.white,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: iconSize, color: iconColor),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        label,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 14,
        ),
      ),
    ],
  );
}
