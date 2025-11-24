// import 'dart:async';
// import 'dart:math';
// import 'dart:developer' as dev;
//
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:agora_token_service/agora_token_service.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
//
// import '../../../utils/utils.dart';
//
// class VoiceCallController extends GetxController {
//   late RtcEngine engine;
//
//   // Timer
//   Timer? meetingTimer;
//   int meetingDuration = 0;
//   RxString meetingDurationTxt = "00:00".obs;
//
//   // States
//   final isMuted = false.obs;
//   final isSpeakerOn = false.obs;     // ⭐ FIXED (ของเดิม null)
//   final isJoined = false.obs;
//
//   // Remote users
//   RxList<int> remoteUsers = <int>[].obs;
//   int? remoteUidOne;
//
//   // Network Quality
//   int networkQuality = 3;
//   Color networkQualityBarColor = Colors.green;
//
//   // Channel
//   String channelId = "";
//   String agoraAuthToken = "";
//
//   final int uid = Random().nextInt(19000);
//
//   VoiceCallController({
//     required String channel,
//   }) {
//     channelId = channel;
//     _generateAgoraAuthToken();
//     init();
//   }
//
//   // ----------------------------------------------------------------------
//   // INIT
//   // ----------------------------------------------------------------------
//   Future<void> init() async {
//     if (getAgoraAppId().isEmpty) {
//       Get.snackbar("Error", "Agora APP_ID Is Not Valid");
//       return;
//     }
//
//     engine = createAgoraRtcEngine();
//
//     await engine.initialize(
//       RtcEngineContext(
//         appId: getAgoraAppId(),
//         channelProfile: ChannelProfileType.channelProfileCommunication,
//       ),
//     );
//
//     addEventHandlers();
//
//     await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//
//     // Voice-only mode
//     await engine.enableAudio();
//
//     joinChannel();
//   }
//
//   // ----------------------------------------------------------------------
//   // TOKEN GENERATOR
//   // ----------------------------------------------------------------------
//   void _generateAgoraAuthToken() {
//     final role = RtcRole.publisher;
//
//     final expirationInSeconds = 3600;
//     final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//     final expireTimestamp = currentTimestamp + expirationInSeconds;
//
//     agoraAuthToken = RtcTokenBuilder.build(
//       appId: getAgoraAppId(),
//       appCertificate: getAgoraAppCertificate(),
//       channelName: channelId,
//       uid: uid.toString(),
//       role: role,
//       expireTimestamp: expireTimestamp,
//     );
//   }
//
//   // ----------------------------------------------------------------------
//   // EVENT HANDLERS
//   // ----------------------------------------------------------------------
//   void addEventHandlers() {
//     engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (connection, elapsed) {
//           dev.log("Local user joined: ${connection.localUid}");
//           isJoined.value = true;
//         },
//
//         onLeaveChannel: (connection, stats) {
//           dev.log("Local user left");
//           isJoined.value = false;
//           remoteUsers.clear();
//           stopMeetingTimer();
//         },
//
//         onUserJoined: (connection, remoteUid, elapsed) {
//           dev.log("Remote user joined: $remoteUid");
//           remoteUsers.add(remoteUid);
//           remoteUidOne = remoteUid;
//           startMeetingTimer();
//         },
//
//         onUserOffline: (connection, remoteUid, reason) {
//           dev.log("Remote user left: $remoteUid");
//           remoteUsers.remove(remoteUid);
//           remoteUidOne = null;
//         },
//       ),
//     );
//   }
//
//   // ----------------------------------------------------------------------
//   // JOIN CHANNEL
//   // ----------------------------------------------------------------------
//   Future<void> joinChannel() async {
//     await engine.joinChannel(
//       token: agoraAuthToken,
//       channelId: channelId,
//       uid: uid,
//       options: const ChannelMediaOptions(),
//     );
//   }
//
//   // ----------------------------------------------------------------------
//   // MEETING TIMER
//   // ----------------------------------------------------------------------
//   void startMeetingTimer() {
//     stopMeetingTimer();
//
//     meetingTimer = Timer.periodic(
//       const Duration(seconds: 1),
//       (timer) {
//         int min = meetingDuration ~/ 60;
//         int sec = meetingDuration % 60;
//
//         meetingDurationTxt.value =
//             "${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
//
//         meetingDuration++;
//       },
//     );
//   }
//
//   void stopMeetingTimer() {
//     meetingTimer?.cancel();
//     meetingTimer = null;
//   }
//
//   // ----------------------------------------------------------------------
//   // AUDIO CONTROLS
//   // ----------------------------------------------------------------------
//
//   /// Toggle mic mute/unmute
//   void toggleMute() async {
//     isMuted.value = !isMuted.value;
//     await engine.muteLocalAudioStream(isMuted.value);
//   }
//
//   /// Toggle speaker on/off
//   void toggleSpeaker() async {
//     isSpeakerOn.value = !isSpeakerOn.value;
//     await engine.setEnableSpeakerphone(isSpeakerOn.value);
//   }
//
//   // ----------------------------------------------------------------------
//   // END CALL
//   // ----------------------------------------------------------------------
//   void endCall() {
//     engine.leaveChannel();
//     stopMeetingTimer();
//   }
//
//   @override
//   void onClose() {
//     stopMeetingTimer();
//     super.onClose();
//   }
// }
