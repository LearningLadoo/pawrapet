import 'package:flutter/material.dart';
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
  late ImageProvider _iconImage, _mainImage;

  ImageProvider? _iconYou, _iconThey;

  late bool _youLiked, _theyLiked;

  @override
  void initState() {
    _iconImage = widget.assetsMapWithImageProvider != null ? widget.assetsMapWithImageProvider!["icon_0"]["image"] : Image.network(widget.feedMap['profile']['assets']['icon_0']['url']).image;
    _mainImage = widget.assetsMapWithImageProvider != null ? widget.assetsMapWithImageProvider!["main_0"]["image"] : Image.network(widget.feedMap['profile']['assets']['main_0']['url']).image;

    // for self preview
    if (widget.assetsMapWithImageProvider != null) {
      _iconThey = _iconImage;
      _iconYou = _iconImage;
      _youLiked = false;
      _theyLiked = true;
    }
    // for real
    else {
      _iconThey = _iconImage;
      _iconYou = xMyIcon().image;
      _theyLiked = widget.feedMap['requestedUsersForMatch'][xProfile!.uidPN] == true;
      _youLiked = xProfile!.requestedUsersMapForMatch?[widget.feedMap['uidPN']] == true;
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
                  XAppBar(AppBarType.profile, title: widget.feedMap['profile']['name'], username: widget.feedMap['profile']['username']),
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
                                      "${widget.feedMap['profile']['color'].capitalizeFirstOfEach}, ${widget.feedMap['profile']['breed']}",
                                      style: xTheme.textTheme.bodyMedium!.apply(fontSizeDelta: 1, fontWeightDelta: 1),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Opacity(
                                      opacity: 0.8,
                                      child: Text(
                                        "${widget.feedMap['profile']['gender'].capitalizeFirstOfEach}, ${DateTime(0).fromddMMyyyy(widget.feedMap['profile']['birthDate'].toString()).calculateYears()} years${(widget.feedMap['profile']['amount'] != null || widget.feedMap['profile']['amount']! != 0) ? "\n₹${widget.feedMap['profile']['amount'].toString().removeTrailingZeros()} per mating" : ""}",
                                        style: xTheme.textTheme.bodyMedium!.apply(fontSizeDelta: -4, fontWeightDelta: 1),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox().vertical(size: xSize * 3 / 4),
                          // description
                          Text(
                            widget.feedMap['profile']['description'],
                            style: xTheme.textTheme.bodySmall,
                          ),
                          const SizedBox().vertical(),
                          // main Image
                          ClipRRect(
                              borderRadius: BorderRadius.circular(xSize2),
                              child: Image(
                                image: _mainImage,
                              )),
                          const SizedBox().vertical(),
                          // height and weight
                          Text(
                            "I have a proud height of ${widget.feedMap['profile']['height'].toString().removeTrailingZeros()} cm and I weigh a healthy ${widget.feedMap['profile']['weight'].toString().removeTrailingZeros()} kgs. I'm ${widget.feedMap['profile']['personality']}.",
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
                                    iconR: _theyLiked ? _iconThey : null,
                                    iconL: _youLiked ? _iconYou : null,
                                    onTap: () async {
                                      setState(() {
                                        _youLiked = !_youLiked;
                                      });
                                      // for the preview
                                      if (widget.assetsMapWithImageProvider == null) return;
                                      //  update the variables and isar here
                                      if (_youLiked) {
                                        xProfile!.requestedUsersMapForMatch?.addAll({widget.feedMap['uidPN']: true});
                                        await xProfileIsarManager.setProfile(xProfile!);
                                      } else {
                                        xProfile!.requestedUsersMapForMatch?.remove(widget.feedMap['uidPN']);
                                        await xProfileIsarManager.setProfile(xProfile!);
                                      }
                                      // update the sub collection of matingRequests in firestore
                                      await FirebaseCloudFirestore().updateMatingReq(
                                        req: _youLiked,
                                        myUidPN: xProfile!.uidPN,
                                        frndsUidPN: widget.feedMap['uidPN'],
                                        myName: xProfile!.name!,
                                        frndsName: widget.feedMap['name'],
                                        myIcon: xProfile!.iconUrl!,
                                        frndsIcon: widget.feedMap['profile']['assets']['icon_0']['url'],
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
