import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pawrapet/utils/widgets/inputFields.dart';
import '../../firebase/firestore.dart';
import '../../screens/home/preferences.dart';
import '../../screens/mating/mating.dart';
import '../extensions/buildContext.dart';
import '../extensions/sizedBox.dart';

import '../constants.dart';
import '../extensions/string.dart';
import '../functions/common.dart';
import 'buttons.dart';
import 'displayText.dart';
import 'heart.dart';

enum AppBarType { backWithHeading, heading, home, search, profile, account, back }

class XAppBar extends StatelessWidget {
  final AppBarType type;
  final String? title;
  final String? username;
  Function? onTapBack;

  XAppBar(this.type, {Key? key, this.title, this.username, this.onTapBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: xSize / 8, horizontal: xSize / 2),
      color: xSurface,
      width: xWidth,
      child: getAppBar(),
    );
  }

  Widget getAppBar() {
    switch (type) {
      case AppBarType.home:
        return const FeedAppBar();
      case AppBarType.search:
        return const SearchAppBar();
      case AppBarType.account:
        return const AccountAppBar();
      default:
        return DefaultAppBar(
          type: type,
          title: title,
          username: username,
          onTapBack: onTapBack,
        );
    }
  }
}

class FeedAppBar extends StatefulWidget {
  const FeedAppBar({Key? key}) : super(key: key);

  @override
  State<FeedAppBar> createState() => _FeedAppBarState();
}

class _FeedAppBarState extends State<FeedAppBar> {
  bool _matingsPressed = false;
  final ImageProvider _myIcon = xMyIcon().image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: xSurface,
          width: xWidth,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _matingsPressed ? "Matches & Mating" : "PAWRAPETS",
                  style: xTheme.textTheme.titleLarge!.apply(fontWeightDelta: -1, color: xPrimary.withOpacity(0.9)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push(PreferencesPage());
                },
                child: Icon(
                  Icons.filter_alt_rounded,
                  size: xSize,
                  color: xPrimary.withOpacity(0.89),
                ),
              ),
              const SizedBox().horizontal(),
              Opacity(
                opacity: 0.9,
                child: InkWell(
                  onTap: () {
                    _matingsPressed = !_matingsPressed;
                    setState(() {});
                  },
                  child: (_matingsPressed)
                      ? const Icon(
                          CupertinoIcons.chevron_up_circle_fill,
                          size: xSize,
                          color: xPrimary,
                        )
                      : Container(
                          height: xSize,
                          width: xSize,
                          child: SvgPicture.asset("assets/icons/love_pets.svg"),
                        ),
                ),
              ),
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _matingsPressed ? xSize * 3.7 : 0,
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              xSurface,
              xSurface.withOpacity(0.9),
              xSurface.withOpacity(0.1),
              xSurface.withOpacity(0),
              xSurface.withOpacity(0),
              xSurface.withOpacity(0.05),
              xSurface.withOpacity(0.9),
              xSurface
            ], stops: const [
              0,
              0,
              0.06,
              0.1,
              0.9,
              0.94,
              1,
              1
            ]),
          ),
          // todo get the session mating requests
          child: FutureBuilder(
            future: FirebaseCloudFirestore().getMatingSessionProfiles(xProfile!.uidPN),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.done && snap.hasData) {
                List<Map<String, dynamic>?>? matingSessionProfiles = snap.data;
                if (matingSessionProfiles != null && matingSessionProfiles.isNotEmpty) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: matingSessionProfiles.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      Map<String, dynamic> map = matingSessionProfiles[index]!;
                     return matingSessionWidget(profileMap: map, uidPN: map['uidPN']);
                    },
                  );
                } else {
                  return FittedBox(child: xInfoText(context, "All your mating sessions will appear here. "));
                }
              } else {
                return LinearProgressIndicator(
                  color: xOnSurface.withOpacity(0.5),
                );
              }
            },
          ),
        )
      ],
    );
  }

  Widget matingSessionWidget({required String uidPN, required Map<String, dynamic> profileMap}) {
    ImageProvider iconImage = Image.network(profileMap['assets']['icon_0']['url']).image;
    bool theyLike = profileMap['requestedUsersForMatch']?[xProfile!.uidPN] == true;
    bool youLike = xProfile!.requestedUsersMapForMatch?[profileMap['uidPN']] == true;
    String name = profileMap['name'];
    return InkWell(
      onTap: (){
        context.push(Mating(flowStep: -1, uidPN: uidPN, profileMap: profileMap));
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: xSize / 2, top: xSize / 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundImage: iconImage,
                  radius: xSize,
                ),
                const SizedBox().vertical(size: xSize / 8),
                Text(
                  "$name",
                  style: xTheme.textTheme.labelLarge,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            top: xSize * 3.5 / 2,
            right: 0,
            child: XHeartWithImage(
              gap: xSize1 / 2,
              height: xSize7,
              iconR: (theyLike) ? iconImage : null,
              iconL: (youLike) ? _myIcon : null,
            ),
          )
        ],
      ),
    );
  }
}

class AccountAppBar extends StatefulWidget {
  const AccountAppBar({Key? key}) : super(key: key);

  @override
  State<AccountAppBar> createState() => _AccountAppBarState();
}

class _AccountAppBarState extends State<AccountAppBar> {
  bool isChecked = xProfile!.isFindingMate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Hi ${xProfile!.name!.inCaps}",
            style: xTheme.textTheme.titleLarge!.apply(fontWeightDelta: -1, color: xPrimary.withOpacity(0.9)),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              isChecked = !isChecked;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: xSize / 8).copyWith(left: xSize / 4, right: xSize / 8),
            decoration: BoxDecoration(
              color: const Color(0xFFcec3c6).withOpacity(1),
              borderRadius: BorderRadius.circular(xSize),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isChecked ? "Finding Partner" : "Find Partner", style: xTheme.textTheme.labelLarge!.apply(color: xPrimary.withOpacity(0.8), fontSizeDelta: -1)),
                const SizedBox().horizontal(size: xSize / 12),
                Opacity(
                  opacity: 0.8,
                  child: Icon((isChecked) ? Icons.check_circle : Icons.radio_button_unchecked_outlined),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SearchAppBar extends StatefulWidget {
  const SearchAppBar({Key? key}) : super(key: key);

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  @override
  Widget build(BuildContext context) {
    return XSearchFieldWithFilter(
      onChanged: () {},
    );
  }
}

class DefaultAppBar extends StatelessWidget {
  final String? title, username;
  final AppBarType type;
  Function? onTapBack;

  DefaultAppBar({Key? key, required this.type, this.title, this.username, this.onTapBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // back button
        if (type == AppBarType.backWithHeading || type == AppBarType.profile || type == AppBarType.back)
          XBackButton(
            onTap: onTapBack,
          ),
        // heading
        if (type == AppBarType.backWithHeading || type == AppBarType.profile || type == AppBarType.heading)
          Expanded(
            child: Text(
              title ?? "",
              style: xTheme.textTheme.titleLarge!.apply(fontWeightDelta: -1, color: xPrimary.withOpacity(0.9)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        // profile
        if (type == AppBarType.profile)
          Padding(
            padding: const EdgeInsets.only(left: xSize / 2),
            child: Text(
              "@$username",
              style: xTheme.textTheme.labelMedium!.apply(fontWeightDelta: 2, color: xPrimary.withOpacity(0.4)),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
      ],
    );
  }
}
