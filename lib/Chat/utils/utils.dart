// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:share_plus/share_plus.dart';

// String getAgoraAppId() {
//   return 'ef0a2920a8414c648d0e92f553b9fd63';
//   // return "<YOUR APP ID HERE>"; // Return Your Agora App Id
// }

// String getAgoraAppCertificate() {
//   return 'd8fe908a26f54ce3b5ce471a9c1a0b27';
// }

// bool checkNoSignleDigit(int no) {
//   int len = no.toString().length;
//   if (len == 1) {
//     return true;
//   }
//   return false;
// }

// String generateRandomString(int len) {
//   var r = Random();
//   const _chars =
//       'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
//   return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
// }

// void shareToApps(String roomId) async {
//   await Share.share(
//     'Hey There, Lets Connect via Video call in App using code : ' + roomId,
//   );
// }

// Future<bool> handlePermissionsForCall(BuildContext context) async {
//   Map<Permission, PermissionStatus> statuses = await [
//     Permission.camera,
//     Permission.microphone,
//   ].request();

//   if (statuses[Permission.camera]?.isPermanentlyDenied ?? false) {
//     showCustomDialog(
//       context,
//       "Permission Required",
//       "Camera Permission Required for Video Call111",
//       () {
//         Navigator.pop(context);
//         openAppSettings();
//       },
//     );
//     return false;
//   } else if (statuses[Permission.microphone]?.isPermanentlyDenied ?? false) {
//     showCustomDialog(
//       context,
//       "Permission Required",
//       "Microphone Permission Required for Video Call2222",
//       () {
//         Navigator.pop(context);
//         openAppSettings();
//       },
//     );
//     return false;
//   }

//   if (statuses[Permission.camera]?.isDenied ?? false) {
//     return false;
//   } else if (statuses[Permission.microphone]?.isDenied ?? false) {
//     return false;
//   }
//   return true;
// }

// void showCustomDialog(
//   BuildContext context,
//   String title,
//   String message,
//   VoidCallback okPressed,
// ) async {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       // return object of type Dialog

//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10.0))),
//         title: Text(
//           title,
//           style: TextStyle(fontFamily: 'WorkSansMedium'),
//         ),
//         content: Text(
//           message,
//           style: TextStyle(fontFamily: 'WorkSansMedium'),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: Text(
//               "OK",
//               style: TextStyle(fontFamily: 'WorkSansMedium'),
//             ),
//             onPressed: okPressed,
//           ),
//         ],
//       );
//     },
//   );
// }

// int getNetworkQuality(int txQuality) {
//   switch (txQuality) {
//     case 0:
//       return 2;

//     case 1:
//       return 4;

//     case 2:
//       return 3;

//     case 3:
//       return 2;

//     case 4:
//       return 1;
//   }
//   return 0;
// }

// Color getNetworkQualityBarColor(int txQuality) {
//   switch (txQuality) {
//     case 0:
//       return Colors.green;
//     case 1:
//       return Colors.green;
//     case 2:
//       return Colors.yellow;
//     case 3:
//       return Colors.redAccent;
//     case 4:
//       return Colors.red;
//   }
//   return Colors.yellow;
// }



import 'dart:math';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

// ❗ ควรย้ายไป .env หรือ backend
String getAgoraAppId() => 'ef0a2920a8414c648d0e92f553b9fd63';
String getAgoraAppCertificate() => 'd8fe908a26f54ce3b5ce471a9c1a0b27';

bool checkNoSignleDigit(int no) => no.toString().length == 1;

String generateRandomString(int len) {
  const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final r = Random();
  return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
}

void shareToApps(String roomId) async {
  await Share.share(
    'Hey there! Join my call using room code: $roomId',
  );
}

///
/// 📌 ใช้สำหรับ Video Call → ขอ Camera + Mic
/// 📌 ใช้สำหรับ Voice Call → ขอ Mic อย่างเดียว
///
Future<bool> handlePermissionsForCall(
  BuildContext context, {
  bool isVideoCall = true,
}) async {
  List<Permission> perms = [
    Permission.microphone,
  ];

  if (isVideoCall) {
    perms.add(Permission.camera);
  }

  Map<Permission, PermissionStatus> statuses = await perms.request();

  // Check permanently denied
  for (var permission in perms) {
    if (statuses[permission]?.isPermanentlyDenied ?? false) {
      showCustomDialog(
        context,
        "Permission Required",
        isVideoCall
            ? "Camera & Microphone permissions required for video call."
            : "Microphone permission required for voice call.",
        () {
          Navigator.pop(context);
          openAppSettings();
        },
      );
      return false;
    }
  }

  // Check denied
  for (var permission in perms) {
    if (statuses[permission]?.isDenied ?? false) {
      return false;
    }
  }

  return true;
}

void showCustomDialog(
  BuildContext context,
  String title,
  String message,
  VoidCallback okPressed,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: okPressed,
          ),
        ],
      );
    },
  );
}

///
/// Agora Network Quality: 0→5
/// คุณ mapping ค่าใหม่ได้ตามต้องการ
///
int getNetworkQuality(int q) {
  switch (q) {
    case 0: return 2; // Unknown
    case 1: return 4; // Excellent
    case 2: return 3; // Good
    case 3: return 2; // Poor
    case 4: return 1; // Bad
    case 5: return 0; // Very Bad
  }
  return 0;
}

Color getNetworkQualityBarColor(int q) {
  switch (q) {
    case 0:
    case 1:
      return Colors.green;
    case 2:
      return Colors.yellow;
    case 3:
      return Colors.orange;
    case 4:
    case 5:
      return Colors.red;
  }
  return Colors.yellow;
}
