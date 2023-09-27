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

class ProfileDisplay extends StatefulWidget {
  const ProfileDisplay({Key? key}) : super(key: key);

  @override
  State<ProfileDisplay> createState() => _ProfileDisplayState();
}

class _ProfileDisplayState extends State<ProfileDisplay> {
  late String _name, _type, _colour, _breed, _gender, _birthDate, _personality;
  String? _description;
  late String _username;
  late double _height, _weight;
  double? _amount;
  late ImageProvider _iconImage, _mainImage;
  ImageProvider? _iconI, _iconThey;
  late bool _iLiked, _theyLiked;
  @override
  void initState() {
    _username = "userTemp";
    _name = "tanna";
    _type = "dog";
    _colour = "cream";
    _breed = "Rehapta chaap";
    _gender = "female";
    _birthDate = "08/11/1999";
    _personality = "cute, chutiya, ladaku, pyari";
    _description = "Woof! I'm Scooby, a friendly Labrador with a wagging tail and a heart full of love. Ready to fetch some fun and spread pawsitive vibes wherever I go! 🐾";
    _height = 110;
    _weight = 55;
    _amount = 150;
    _iconImage = Image.asset("assets/images/pet1.jpeg").image;
    _mainImage = Image.asset("assets/images/pet1_image.jpeg").image;
    _iLiked  = false;
    _theyLiked = false;
    _iconThey = _iconImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: xHeight,
              child: Column(
                children: [
                  xAppBar(AppBarType.profile, context, text: _name, username: _username),
                  XHeartWithImageButton(height: 80,iconL: _iconI,iconR: _iconThey, onTap: (){
                    setState(() {
                      if(_iconI==null){
                        _iconI = _iconImage;
                      } else {
                        _iconI = null;
                      }
                    });
                  },),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: xSize / 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox().vertical(),
                          // icon, colour, breed, gender, age, amount
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
                                      "${_colour.capitalizeFirstOfEach}, $_breed",
                                      style: xTheme.textTheme.bodyMedium!.apply(fontSizeDelta: 1, fontWeightDelta: 1),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Opacity(
                                      opacity: 0.8,
                                      child: Text(
                                        "${_gender.capitalizeFirstOfEach}, ${calculateAge(DateTime(0).fromddMMyyyy(_birthDate))} years${(_amount != null || _amount! != 0) ? "\n₹${_amount.toString().removeTrailingZeros()} per mating" : ""}",
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
                            "$_description",
                            style: xTheme.textTheme.bodySmall,
                          ),
                          const SizedBox().vertical(),
                          // main Image
                          ClipRRect(borderRadius: BorderRadius.circular(xSize2), child: Image(image: _mainImage)),
                          const SizedBox().vertical(),
                          // height and weight
                          Text(
                            "I have a proud height of ${_height.toString().removeTrailingZeros()} cm and I weigh a healthy ${_weight.toString().removeTrailingZeros()} kgs. I'm $_personality.",
                            style: xTheme.textTheme.bodySmall,
                          ),
                          const SizedBox().vertical(size: xSize / 4),
                          // height and weight
                          Text(
                            "I’m looking for a partner, are you interested ?",
                            style: xTheme.textTheme.bodySmall!.apply(fontWeightDelta: 1),
                          ),
                          const SizedBox().vertical(size: xSize*0.9),
                          SizedBox(
                            height: xSize*3.5,
                            width: xWidth,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                    bottom:0,
                                    left: -xSize/2,
                                    child: Image.asset("assets/images/element2.png", alignment: Alignment.bottomLeft,height: xSize*2,)),
                                Positioned(
                                  bottom: 0,
                                  right: -xSize/2,
                                  child: Transform.flip(
                                    flipX: true,
                                    child: Image.asset("assets/images/element2.png", alignment: Alignment.bottomLeft, height: xSize*2,))),
                                // animation
                                Positioned(
                                  top: -xSize*2,
                                  child: Container(
                                      alignment: Alignment.center,
                                      width: xWidth-xSize,
                                      height: xSize*6,
                                      child: Lottie.asset("assets/lotties/love_success.json", )),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                    child: GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          _iLiked = !_iLiked;
                                        });
                                      },
                                      child: XHeartWithImage(
                                        height: xSize*2,
                                        iconL: (_iLiked)?_iconImage:null,
                                        iconR: (_theyLiked)?_iconImage:null,
                                      ),
                                    )),
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
