
import 'package:flutter/material.dart';
import '../../isar/notificationMessage.dart';
import '../../isar/notificationsManager.dart';
import '../../providers/firebaseMessagingProvider.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/appBar.dart';
import 'utis/widgets/notificationTile.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationMessage> notifications = [];
  int offset = 0;
  int batchSize = 20;

  Future<void> getNotificationList({bool fromStart = false}) async {
    notifications.addAll(await xNotificationsIsarManager.getBatchNotificationsToDisplay(profileId: 1, offset: offset, batchSize: batchSize));
    offset = (fromStart)?0:batchSize;
    setState(() {});
  }

  @override
  void initState() {
    getNotificationList(fromStart: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<MessagingProvider>(context).message != null) {
      getNotificationList();
    }
    return Column(
      children: [
        XAppBar(
          AppBarType.heading,
          title: "Notifications",
        ),
        Expanded(
          child: ListView.builder(
            itemCount: notifications.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return NotificationTile(notificationMessage: notifications[index]);
            },
          ),
        ),
      ],
    );
  }
}


