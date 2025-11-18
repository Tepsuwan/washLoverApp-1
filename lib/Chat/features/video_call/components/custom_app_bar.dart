// import 'package:chat_app/design_system/text_styles.dart';
import 'package:my_flutter_mapwash/Chat/features/video_call/controller/video_call_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:my_flutter_mapwash/Chat/features/video_call/controller/video_call_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key, required this.agoraController})
      : super(key: key);
  final AgoraController agoraController;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Obx(
        () {
          final duration = agoraController.meetingDurationTxt.value;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'โทรออก...',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${duration}',
                style: TextStyle(fontSize: 14 , color: Colors.red),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kMinInteractiveDimension);
}
