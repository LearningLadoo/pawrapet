
import 'package:flutter/material.dart';
import 'package:pawrapet/utils/extensions/buildContext.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/constants.dart';
import '../../../utils/widgets/heart.dart';
import '../../account/Account.dart';
import '../../mating/mating.dart';
import '../../profile/profile.dart';

Widget getInitialWidget(Map details) {
  switch (details['type']) {
    case 'myself':
      return CircleAvatar(radius: xSize, backgroundImage: xMyIcon.image);
    case 'mating':
      ImageProvider partnerIcon = Image.network(details['iconUrl']).image;
      return XHeartWithImage(
        height: xSize * 2,
        iconL: xMyIcon.image,
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
  String redirectLink = details['redirectTo']; // https: or inapp://
  List separatedLink = redirectLink.split("://");
  String type = separatedLink[0];
  String path = separatedLink[1];
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
          context.push(const Profile());
          break;
        case 'mating':
          // the schema for path is mating/<username>/<step>
          context.push(Mating(username: separatedPath[1]!, flowStep: int.parse(separatedPath[2])));
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
