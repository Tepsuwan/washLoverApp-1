import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_token_service/agora_token_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class VoiceCallController {
  late RtcEngine engine;

  // Timer
  late Timer meetingTimer;
  int meetingDuration = 0;
  RxString meetingDurationTxt = "00:00".obs;

  // States
  final isMuted = false.obs;
  final isJoined = false.obs;

  // Remote users
  RxList<int> remoteUsers = <int>[].obs;
  int? remoteUidOne;

  // Network Quality
  int networkQuality = 3;
  Color networkQualityBarColor = Colors.green;

  // Channel
  String channelId = "";
  String agoraAuthToken = "";

  final int uid = Random().nextInt(19000);

  VoiceCallController({
    required String channel,
  }) {
    channelId = channel;
    _generateAgoraAuthToken();
    init();
  }

  // ----------------------------------------------------------------------
  // INIT
  // ----------------------------------------------------------------------
  Future<void> init() async {
    if (getAgoraAppId().isEmpty) {
      Get.snackbar("Error", "Agora APP_ID Is Not Valid");
      return;
    }

    engine = createAgoraRtcEngine();

    await engine.initialize(
      RtcEngineContext(
        appId: getAgoraAppId(),
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    addEventHandlers();

    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    // ❗ Voice Call: enableAudio only
    await engine.enableAudio();

    joinChannel();
  }

  // ----------------------------------------------------------------------
  // TOKEN GENERATOR
  // ----------------------------------------------------------------------
  void _generateAgoraAuthToken() {
    final role = RtcRole.publisher;

    final expirationInSeconds = 3600;
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final expireTimestamp = currentTimestamp + expirationInSeconds;

    agoraAuthToken = RtcTokenBuilder.build(
      appId: getAgoraAppId(),
      appCertificate: getAgoraAppCertificate(),
      channelName: channelId,
      uid: uid.toString(),
      role: role,
      expireTimestamp: expireTimestamp,
    );
  }

  // ----------------------------------------------------------------------
  // EVENT HANDLERS
  // ----------------------------------------------------------------------
  void addEventHandlers() {
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onConnectionStateChanged: (connection, state, reason) {
          dev.log("Connection State Changed: $state, reason: $reason");
        },

        onJoinChannelSuccess: (connection, elapsed) {
          dev.log("Local user joined: ${connection.localUid}");
          isJoined.value = true;
        },

        onLeaveChannel: (connection, stats) {
          dev.log("Local user left");
          isJoined.value = false;
          remoteUsers.clear();
        },

        onUserJoined: (connection, remoteUid, elapsed) {
          dev.log("Remote user joined: $remoteUid");
          remoteUsers.add(remoteUid);
          remoteUidOne = remoteUid;
          startMeetingTimer();
        },

        onUserOffline: (connection, remoteUid, reason) {
          dev.log("Remote user left: $remoteUid");
          remoteUsers.remove(remoteUid);
          remoteUidOne = null;
        },

        onTokenPrivilegeWillExpire: (connection, token) {
          dev.log("Token will expire soon!");
        },

        onNetworkQuality: (connection, remoteUid, txQuality, rxQuality) {
          networkQuality = getNetworkQuality(txQuality.index);
          networkQualityBarColor = getNetworkQualityBarColor(txQuality.index);
        },

        onError: (err, msg) {
          dev.log("==========================");
          dev.log("Agora Error: ${err.name}");
          dev.log("Message: $msg");
          dev.log("==========================");
        },
      ),
    );
  }

  // ----------------------------------------------------------------------
  // JOIN CHANNEL
  // ----------------------------------------------------------------------
  Future<void> joinChannel() async {
    await engine.joinChannel(
      token: agoraAuthToken,
      channelId: channelId,
      uid: uid,
      options: const ChannelMediaOptions(),
    );
  }

  // ----------------------------------------------------------------------
  // MEETING TIMER
  // ----------------------------------------------------------------------
  void startMeetingTimer() {
    meetingTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        int min = meetingDuration ~/ 60;
        int sec = meetingDuration % 60;

        final minStr = min < 10 ? "0$min" : "$min";
        final secStr = sec < 10 ? "0$sec" : "$sec";

        meetingDurationTxt.value = "$minStr:$secStr";

        meetingDuration++;
      },
    );
  }

  // ----------------------------------------------------------------------
  // AUDIO CONTROLS
  // ----------------------------------------------------------------------
  void onToggleMuteAudio() async {
    isMuted.value = !isMuted.value;
    await engine.muteLocalAudioStream(isMuted.value);
  }

  // ----------------------------------------------------------------------
  // END CALL
  // ----------------------------------------------------------------------
  void endCall() {
    engine.leaveChannel();
    try {
      meetingTimer.cancel();
    } catch (_) {}
  }
}
