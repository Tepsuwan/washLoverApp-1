import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AgoraController22 extends GetxController {
  final String channel;
  final String token;
  final int uid;

  late final RtcEngine engine;
  late final RtcEngineEventHandler _handler;

  final RxList<int> remoteUsers = <int>[].obs;
  final RxBool isMuted = false.obs;

  Timer? meetingTimer;

  AgoraController22({
    required this.channel,
    required this.token,
    required this.uid,
  });

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: "YOUR_REAL_APP_ID"));

    _handler = RtcEngineEventHandler(
      onJoinChannelSuccess: (connection, elapsed) {
        debugPrint("Joined channel $channel with uid $uid");
      },
      onUserJoined: (connection, remoteUid, elapsed) {
        remoteUsers.add(remoteUid);
      },
      onUserOffline: (connection, remoteUid, reason) {
        remoteUsers.remove(remoteUid);
      },
    );
    engine.registerEventHandler(_handler);

    await engine.enableAudio();
    await engine.muteLocalAudioStream(false);

    await engine.joinChannel(
      token: token,
      channelId: channel,
      uid: uid,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> toggleMute() async {
    final newMuted = !isMuted.value;
    await engine.muteLocalAudioStream(newMuted);
    isMuted.value = newMuted;
  }

  @override
  void onClose() {
    engine.unregisterEventHandler(_handler);
    engine.leaveChannel();
    engine.release();
    meetingTimer?.cancel();
    super.onClose();
  }
}
