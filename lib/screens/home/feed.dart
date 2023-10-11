import 'package:flutter/material.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/appBar.dart';

import 'utils/widgets/feedWidgets.dart';

///
/// the feed or the post input
/// {
///   profile: {the profile details} // check [profile.dart] page for more details
///   status: finding_partner, or something else
///   date: the date of posting
///   users: [<user1>,<user2>] // list of all the active users that this user has liked and not confirmed the date for mating or removed. its more like current active likes.
///   v:1 // first version
/// }
class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        XAppBar(AppBarType.home,),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(xSize / 2).copyWith(top: xSize/4),
            physics: const BouncingScrollPhysics(),
            children: [
              FindingPartnerWidget(postDetails: {}),
              SizedBox().vertical(),
              FindingPartnerWidget(postDetails: {}),
            ],
          ),
        ),
      ],
    );
  }
}


