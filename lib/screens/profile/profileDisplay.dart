import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;

import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/extensions/dateTime.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/extensions/string.dart';
import 'package:pawrapet/utils/functions/common.dart';
import 'package:pawrapet/utils/widgets/appBar.dart';
import 'package:pawrapet/utils/widgets/heart.dart';

import '../../firebase/firestore.dart';

class ProfileDisplay extends StatefulWidget {
  Map<String, dynamic> feedMap;

  /// refer [feed.dart]
  Map<String, dynamic>? assetsMapWithImageProvider; // with image provider, this is passed when seeing a preview
  ProfileDisplay({Key? key, required this.feedMap, this.assetsMapWithImageProvider}) : super(key: key);

  @override
  State<ProfileDisplay> createState() => _ProfileDisplayState();
}

class _ProfileDisplayState extends State<ProfileDisplay> {
  late bool _theyLiked, _youLiked;
  late ImageProvider _iconImage, _mainImage;
  String _desc = "";
  late double? _amount;
  int? _days, _age;

  @override
  void initState() {
    // for self preview
    if (widget.assetsMapWithImageProvider != null) {
      _youLiked = true;
      _theyLiked = false;
      _iconImage = widget.assetsMapWithImageProvider!["icon_0"]["image"];
      _mainImage = widget.assetsMapWithImageProvider!["main_0"]["image"];
    }
    // for real
    else {
      _theyLiked = widget.feedMap['requestedUsersForMatch']?[xProfile!.uidPN] == true;
      _youLiked = xProfile!.requestedUsersMapForMatch?[widget.feedMap['uidPN']] == true;
      _iconImage = Image.network(widget.feedMap['assets']['icon_0']['url']).image;
      _mainImage = Image.network(widget.feedMap['assets']['main_0']['url']).image;
    }
    _amount = (widget.feedMap['amount'] ?? 0) * 1.0;
    _age = DateTime(0).fromddMMyyyy(widget.feedMap['birthDate']).calculateYears();
    _days = DateTime.fromMillisecondsSinceEpoch(widget.feedMap['lastProfileUpdated']).calculateDays();
    _desc = widget.feedMap['description'] ?? "";
    // todo create the support for all other types of animals
    if (_desc == "") {
      switch (widget.feedMap['type']) {
        case 'dog':
          _desc =
              "Woof! I'm ${widget.feedMap['name']}, a/an ${widget.feedMap['breed']} with a wagging tail and a heart full of love. Ready to fetch some fun and spread pawsitive vibes wherever I go! 🐾";
          break;
        case 'cat':
          _desc =
              "Meow! I'm ${widget.feedMap['name']}, a/an ${widget.feedMap['breed']} with a purrfectly playful spirit and a heart full of love. Ready to chase some toys and spread purrs of joy wherever I roam! 🐾";
          break;
        default:
          _desc = "";
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: xHeight,
              child: Column(
                children: [
                  XAppBar(AppBarType.profile, title: widget.feedMap['name'], username: widget.feedMap['username']),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: xSize / 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox().vertical(),
                          // icon, color, breed, gender, age, amount
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: _iconImage,
                                radius: xSize * 1.2,
                              ),
                              const SizedBox().horizontal(size: xSize / 4),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.feedMap['color'].toString().capitalizeFirstOfEach}, ${widget.feedMap['breed']}",
                                      style: xTheme.textTheme.bodyMedium!.apply(fontSizeDelta: 1, fontWeightDelta: 1),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Opacity(
                                      opacity: 0.8,
                                      child: Text(
                                        "${widget.feedMap['gender'].toString().capitalizeFirstOfEach}, ${(_age == 0 ? "<1" : _age)} years${(_amount != 0) ? "\n₹${widget.feedMap['amount'].toString().removeTrailingZeros()} per mating" : ""}",
                                        style: xTheme.textTheme.bodyMedium!.apply(fontSizeDelta: -4, fontWeightDelta: 1),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox().vertical(),
                          // description
                          (_desc != "")
                              ? Text(
                                  _desc,
                                  style: xTheme.textTheme.bodySmall,
                                )
                              : const Center(),
                          (_desc != "") ? const SizedBox().vertical() : const Center(),
                          // main Image
                          AspectRatio(
                            aspectRatio: 2 / 3,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(xSize2),
                                color: xSecondary,
                                image: DecorationImage(image: _mainImage, fit: BoxFit.cover),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(xSize / 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(xSize2),
                                  gradient: LinearGradient(
                                    stops: [0.9, 1],
                                    colors: [
                                      Color(0xff06090B).withOpacity(0),
                                      Color(0xff06090B).withOpacity(0.55),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: // posted date
                                    (_days != null)
                                        ? Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              "updated ${(_days == 0) ? "today" : ("$_days ${_days == 1 ? "day" : "days"} ago")}",
                                              style: xTheme.textTheme.labelSmall!.apply(color: xOnPrimary.withOpacity(0.8), fontSizeDelta: 1),
                                            ),
                                          )
                                        : const Center(),
                              ),
                            ),
                          ),
                          const SizedBox().vertical(),
                          // height and weight
                          Text(
                            "I have a proud height of ${widget.feedMap['height'].toString().removeTrailingZeros()} cm and I weigh a healthy ${widget.feedMap['weight'].toString().removeTrailingZeros()} kgs. I'm ${widget.feedMap['personality']}.",
                            style: xTheme.textTheme.bodySmall,
                          ),
                          const SizedBox().vertical(size: xSize / 4),
                          // height and weight
                          Text(
                            "I’m looking for a partner, are you interested ?",
                            style: xTheme.textTheme.bodySmall!.apply(fontWeightDelta: 1),
                          ),
                          const SizedBox().vertical(size: xSize * 0.9),
                          SizedBox(
                            height: xSize * 3.5,
                            width: xWidth,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                    bottom: 0,
                                    left: -xSize / 2,
                                    child: Image.asset(
                                      "assets/images/element2.png",
                                      alignment: Alignment.bottomLeft,
                                      height: xSize * 2,
                                    )),
                                Positioned(
                                  bottom: 0,
                                  right: -xSize / 2,
                                  child: Transform.flip(
                                    flipX: true,
                                    child: Image.asset(
                                      "assets/images/element2.png",
                                      alignment: Alignment.bottomLeft,
                                      height: xSize * 2,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: XHeartWithImageButton(
                                    height: 80,
                                    iconR: _theyLiked ? _iconImage : null,
                                    iconL: _youLiked ? xMyIcon().image : null,
                                    bgColor: xSecondary,
                                    onTap: () async {
                                      setState(() {
                                        _youLiked = !_youLiked;
                                      });
                                      if (widget.assetsMapWithImageProvider != null) return;
                                      //  update the variables and isar here
                                      await xProfileIsarManager.updateRequestedUserForMatch(
                                        youLiked: _youLiked,
                                        uidPN: widget.feedMap['uidPN'],
                                      );
                                      // update the sub collection of matingRequests in firestore
                                      await FirebaseCloudFirestore().updateMatingReq(
                                        req: _youLiked,
                                        myUidPN: xProfile!.uidPN,
                                        frndsUidPN: widget.feedMap['uidPN'],
                                        myName: xProfile!.name!,
                                        frndsName: widget.feedMap['name'],
                                        myIcon: xProfile!.iconUrl!,
                                        frndsIcon: widget.feedMap['assets']['icon_0']['url'],
                                        myUsername: xProfile!.username,
                                        frndsUsername: widget.feedMap['username'],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
