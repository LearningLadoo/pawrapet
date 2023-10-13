import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pawrapet/screens/account/Account.dart';
import 'package:pawrapet/screens/profile/profile.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/extensions/buildContext.dart';
import 'package:pawrapet/utils/extensions/dateTime.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/widgets/heart.dart';

import '../../utils/widgets/appBar.dart';
import '../mating/mating.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<String> notifications = [
    "Notification 1",
    "Notification 2",
    "Notification 3",
  ];

  void _removeNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const XAppBar(
          AppBarType.heading,
          title: "Notifications",
        ),
        Expanded(
          child: ListView.builder(
            itemCount: notifications.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return NotificationTile(
                details: {
                  'text': 'Hurray! you matched with Romie. Now schedule the meeting time and place with her.',
                  'type': 'default',
                  'userName': 'oyeUserName',
                  'redirectPage': 'mating_1',
                  'time': '${DateTime.now().millisecondsSinceEpoch ~/ 1000}'
                },
                index: index,
                removeFn: _removeNotification,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// NotificationTypes {
///   myself, // my icon
///   mating, // the heart icon of myself and partner
/// na friend, // icon of friend
///   default // shows the pawrapet logo
/// }

/// redirectPages {
/// na  profile, // profile of friend
///   editProfile, // edit own profile
///   mating, // mating page with the friend and the step index
///   account, // account page for schedule
/// }

class NotificationTile extends StatelessWidget {
  final Map<String, dynamic> details; // this contains the version, text, time, type, iconsUrl of friend, username, redirectPage, index
  final Function removeFn;
  final int index;

  NotificationTile({super.key, required this.removeFn, required this.index, required this.details});

  late Widget initialWidget;
  late DateTime dt = DateTime.fromMillisecondsSinceEpoch(int.parse(details['time']) * 1000);

  void assignWidget() {
    switch (details['type']) {
      case 'myself':
        // todo get the user icon
        initialWidget = CircleAvatar(radius: xSize, backgroundImage: Image.asset('assets/images/pet1.jpeg').image);
        break;
      case 'mating':
        // todo
        ImageProvider _temp = Image.asset('assets/images/pet1.jpeg').image;
        initialWidget = XHeartWithImage(
          height: xSize * 2,
          iconL: _temp,
          iconR: _temp,
        );
        break;
      default:
        initialWidget = Padding(
          padding: const EdgeInsets.all(xSize / 4),
          child: SizedBox(
            height: xSize * 1.5,
            child: Image.asset('assets/icons/logo_mascot.png'),
          ),
        );
        break;
    }
  }

  void navigate(BuildContext context) {
    String name = details['redirectPage'].split('_')[0];
    String? index = details['redirectPage'].split('_')[1];
    switch (name) {
      case 'editProfile':
        context.push(const Profile());
        break;
      case 'mating':
        context.push(const Mating());
        break;
      case 'account':
        context.push(const Account());
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    assignWidget();
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
                removeFn(index);
              },
              backgroundColor: xOnPrimary,
              foregroundColor: xOnError,
              icon: Icons.delete_rounded,
            )
          ],
        ),
        child: InkWell(
          onTap: () {
            navigate(context);
          },
          child: Row(
            crossAxisAlignment:CrossAxisAlignment.center,
            children: [
              initialWidget,
              const SizedBox().horizontal(size: xSize / 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      details["text"],
                      style: xTheme.textTheme.bodySmall!.apply(fontSizeDelta: -1),
                    ),
                    Text(
                      "${dt.ordinalSuffix()} ${DateFormat('MMM').format(dt)} ${DateFormat('hh:mm a').format(dt)}",
                      textAlign: TextAlign.right,
                      style: xTheme.textTheme.labelSmall,
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
