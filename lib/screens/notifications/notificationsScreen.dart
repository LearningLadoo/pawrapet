import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../isar/notificationMessage/notificationMessage.dart';
import '../../utils/constants.dart';
import '../../utils/functions/common.dart';
import '../../utils/widgets/appBar.dart';
import 'utis/widgets/notificationTile.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        XAppBar(
          AppBarType.heading,
          title: "Notifications",
        ),
        Expanded(
          child: StreamBuilder<List<NotificationMessage>>(
            // todo give the profile id
            stream: xNotificationsIsarManager.getStreamOfDisplayedNotifications(profileId: 1),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return waitingDogLottie();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<NotificationMessage> data = snapshot.data ?? [];
                // Use the data from the stream
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return NotificationTile(notificationMessage: data[index], key: Key(data[index].id.toString()),);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
