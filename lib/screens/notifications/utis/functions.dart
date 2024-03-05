import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pawrapet/utils/extensions/buildContext.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../firebase/firestore.dart';
import '../../../utils/constants.dart';
import '../../../utils/functions/common.dart';
import '../../../utils/widgets/heart.dart';
import '../../account/Account.dart';
import '../../mating/mating.dart';
import '../../profile/profileDisplay.dart';
import '../../profile/profileScreen.dart';

Widget getInitialWidget(Map details) {
  switch (details['type']) {
    case 'myself':
      return CircleAvatar(radius: xSize, backgroundImage: xMyIcon().image);
    case 'mating':
      ImageProvider partnerIcon = Image.network(details['iconUrl']).image;
      return XHeartWithImage(
        height: xSize * 2,
        iconL: xMyIcon().image,
        iconR: partnerIcon,
      );
    default:
      return Padding(
        padding: const EdgeInsets.all(xSize / 4),
        child: SizedBox(
          height: xSize * 1.5,
          child: xAppLogo,
        ),
      );
  }
}

void onTapNotification(BuildContext context, Map details) async {
  /// example of redirect link `inapp://mating/${uidPN}/2` `inapp://profile/${uidPN}`,
  String redirectLink = details['redirectTo'];
  List separatedLink = redirectLink.split("://");
  String type = separatedLink[0]; // https or inapp
  String path = separatedLink[1];
  // todo profile mein log in bhi karna padega
  switch (type) {
    case "https":
      if (!await launchUrl(Uri.parse(redirectLink))) {
        throw Exception('Could not launch $redirectLink');
      }
      return;
    case "inapp":
      List separatedPath = path.split("/");
      switch (separatedPath[0]) {
        case 'editProfile':
          // todo not functional
          break;
        case 'profile':
          //  get feed map
          Map<String, dynamic> temp = (await FirebaseCloudFirestore().getProfileDetails(separatedPath[1])) as Map<String, dynamic>;
          // padding uidPN in the map
          temp.addAll({"uidPN": separatedPath[1]});
          context.push(ProfileDisplay(feedMap: temp));
          break;
        case 'mating':
          // the schema for path is mating/<uidPN>/<step>
          context.push(Mating(uidPN: separatedPath[1]!, flowStep: int.parse(separatedPath[2])));
          break;
        case 'account':
          context.push(const Account());
          break;
        default:
          return;
      }
      return;
    default:
      return;
  }
}
