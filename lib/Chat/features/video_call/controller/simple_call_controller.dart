import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class SimpleCallController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String callId;
  late String channelId;

  var callStatus = "idle".obs;

  // สร้างสายใหม่
  Future<void> startCall(String callerId, String receiverId) async {
    callId = _firestore.collection("calls").doc().id;
    channelId = "ch_${Random().nextInt(10000)}";

    await _firestore.collection("calls").doc(callId).set({
      "callerId": callerId,
      "receiverId": receiverId,
      "channelId": channelId,
      "status": "calling",
    });

    callStatus.value = "calling";
  }

  // รับสาย
  Future<void> acceptCall() async {
    await _firestore.collection("calls").doc(callId).update({
      "status": "accepted",
    });
    callStatus.value = "accepted";
  }

  // ปฏิเสธสาย
  Future<void> rejectCall() async {
    await _firestore.collection("calls").doc(callId).update({
      "status": "rejected",
    });
    callStatus.value = "rejected";
  }

  // ฟังสถานะสาย
  Stream<DocumentSnapshot<Map<String, dynamic>>> callStream() {
    return _firestore.collection("calls").doc(callId).snapshots();
  }
}
