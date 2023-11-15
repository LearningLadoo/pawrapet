import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../../../../isar/notificationsManager.dart';
import '../../../../utils/extensions/dateTime.dart';
import '../../../../utils/extensions/sizedBox.dart';
import '../../../../isar/notificationMessage.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/functions/common.dart';
import '../functions.dart';

/// NotificationTypes {
///   myself, // my icon
///   mating, // the heart icon of myself and partner
///   default // shows the pawrapet logo
/// }

/// redirectPages {
///   editProfile, // edit own profile
///   mating, // mating page with the friend and the step index
///   account, // account page for schedule
/// }

class NotificationTile extends StatefulWidget {
  final NotificationMessage notificationMessage; // this contains the version, text, time, type, iconsUrl of friend, username, redirectTo, index

  const NotificationTile({super.key, required this.notificationMessage});

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  late Map details;
  late Widget initialWidget;

  @override
  void initState() {
    details = widget.notificationMessage.getDataMap();
    initialWidget = getInitialWidget(details);
    super.initState();
  }

  late DateTime dt = DateTime.fromMillisecondsSinceEpoch(int.parse(details['epoch']));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(xSize / 4),
      width: xWidth,
      constraints: const BoxConstraints(minHeight: xSize * 2),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: xPrimary.withOpacity(0.15), width: 0.5),
        ),
      ),
      child: Slidable(
        key: const ValueKey(0),
        endActionPane: ActionPane(
          extentRatio: 0.2,
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),
          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label
            SlidableAction(
              onPressed: (context) {
                xNotificationsIsarManager.markRemoved(widget.notificationMessage);
              },
              backgroundColor: xOnPrimary,
              foregroundColor: xOnError,
              icon: Icons.delete_rounded,
            )
          ],
        ),
        child: InkWell(
          onTap: () {
            // mark it seen
            xNotificationsIsarManager.markSeen(widget.notificationMessage);
            // navigate
            onTapNotification(context, details);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              initialWidget,
              const SizedBox().horizontal(size: xSize / 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${details["title"]}\n${details["body"]}",
                      style: xTheme.textTheme.bodySmall!.apply(fontSizeDelta: -1),
                    ),
                    Text(
                      "${dt.ordinalSuffix()} ${DateFormat('MMM').format(dt)}, ${DateFormat('hh:mm a').format(dt)}",
                      textAlign: TextAlign.right,
                      style: xTheme.textTheme.labelSmall!.apply(color: xPrimary.withOpacity(0.5)),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
