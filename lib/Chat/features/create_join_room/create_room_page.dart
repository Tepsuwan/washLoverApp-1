// import 'package:my_flutter_mapwash/features/create_join_room/join_room_page.dart';
// import 'package:my_flutter_mapwash/utils/utils.dart';
// import 'package:my_flutter_mapwash/features/video_call/view/video_call_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_mapwash/Chat/features/create_join_room/join_room_page.dart';
import 'package:my_flutter_mapwash/Chat/features/video_call/view/video_call_page.dart';
import 'package:my_flutter_mapwash/Chat/utils/utils.dart';

// import '../../design_system/text_styles.dart';

class CreateRoomPage extends StatefulWidget {
  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  String roomId = "";
  @override
  void initState() {
    roomId = generateRandomString(8);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Room55",
          // style: AppTextStyles.medium.copyWith(
          //   fontWeight: FontWeight.w700,
          //   color: const Color(0xFF1A1E78),
          // ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                "Voilà!, We have created a personal room for you",
                // style: AppTextStyles.regular.copyWith(
                //   color: const Color(0xFF1A1E78),
                // ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Room id : $roomId",
                // style: AppTextStyles.medium.copyWith(
                //   color: const Color(0xFF1A1E78),
                //   fontWeight: FontWeight.w500,
                // ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      shareToApps(roomId);
                    },
                    icon:
                        const Icon(Icons.share, color: Colors.white, size: 14),
                    label: Text(
                      "  Share  ",
                      selectionColor: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor: const Color(0xFF1A1E78),
                    ),
                  ),
                  const SizedBox(width: 32),
                  ElevatedButton.icon(
                    onPressed: () async {
                      bool isPermissionGranted =
                          await handlePermissionsForCall(context);
                      if (isPermissionGranted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoCallScreen(
                              channelName: roomId,
                            ),
                          ),
                        );
                      } else {
                        Get.snackbar(
                          "Failed",
                          "Microphone Permission Required for Video Call.",
                          backgroundColor: Colors.white,
                          colorText: const Color(0xFF1A1E78),
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(milliseconds: 1000),
                          animationDuration: const Duration(milliseconds: 750),
                        );
                      }
                    },
                    icon:
                        const Icon(Icons.login, color: Colors.white, size: 18),
                    label: Text(
                      "Join Room",
                      selectionColor: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor: const Color(0xFF1A1E78),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1E78),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JoinRoomPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.open_in_new,
                    color: Colors.white, size: 18),
                label: Text(
                  "Join another room",
                  selectionColor: Colors.white,
                  // style: AppTextStyles.regular,
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: const Color(0xFF1A1E78),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
