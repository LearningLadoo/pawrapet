import 'package:flutter/material.dart';
import 'package:pawrapet/utils/extensions/buildContext.dart';
import 'package:pawrapet/utils/extensions/dateTime.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/extensions/string.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/widgets/heart.dart';
import '../../../profile/profileDisplay.dart';

class FindingPartnerWidget extends StatefulWidget {

  Map<String, dynamic> postDetails;

  FindingPartnerWidget({Key? key, required this.postDetails}) : super(key: key);

  @override
  State<FindingPartnerWidget> createState() => _FindingPartnerWidgetState();
}

class _FindingPartnerWidgetState extends State<FindingPartnerWidget> {
  late String _chips;
  late bool _theyLiked, _youLiked;
  late ImageProvider _iconImage, _mainImage;
  late String _name, _type, _breed, _gender, _birthDate, _personality;
  late String _username, _status, _postedDate;
  late double _height, _weight;
  late double? _amount;
  late  List<String> _chipsList;
  int? _days;
  @override
  void initState() {
    // TODO: get the following details from the map;
    _username = "userTemp";
    _name = "tanna";
    _type = "dog";
    _breed = "Rehapta chaap";
    _gender = "female";
    _birthDate = "08/11/1999";
    _personality = "cute, chutiya, ladaku, pyari";
    _height = 110;
    _weight = 55;
    _amount = 150;
    // TODO: add the image from the url from the map
    _iconImage = Image.asset("assets/images/pet1.jpeg").image;
    _mainImage = Image.asset("assets/images/pet1_image.jpeg").image;
    // TODO: check your liked image
    _youLiked = false;
    // Todo: check the users list from the map
    _theyLiked = true;
    // Todo: check the status from the map
    _status = "finding partner";
    _postedDate = "1/10/2023";
    _chips =
    "$_type,$_breed,${DateTime(0).fromddMMyyyy(_birthDate).calculateYears()} yrs,$_gender,${_weight.toString().removeTrailingZeros()} Kg,${_height.toString().removeTrailingZeros()} cm,$_personality";

    _chipsList = _chips.split(",");
    if(_chipsList.length>8){
      _chipsList = _chipsList.sublist(0,8);
    }
    _chipsList.add("Show Full >>");
    _days = DateTime(0).fromddMMyyyy(_postedDate).calculateDays();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(xSize2),
          color: xSecondary,
          image: DecorationImage(image: _mainImage, fit: BoxFit.cover),
        ),
        child: Container(
          padding: EdgeInsets.all(xSize/4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(xSize2),
            gradient: LinearGradient(
              stops: [0, 0.2, 0.6, 1],
              colors: [
                Color(0xff06090B).withOpacity(0.65),
                Color(0xff06090B).withOpacity(0),
                Color(0xff06090B).withOpacity(0),
                Color(0xff06090B).withOpacity(0.65),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: _iconImage,
                    radius: xSize * 0.65,
                  ),
                  SizedBox().horizontal(size: xSize / 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name.capitalizeFirstOfEach,
                        style: xTheme.textTheme.labelLarge!.apply(color: xOnPrimary),
                      ),
                      Text(
                        "@$_username",
                        style: xTheme.textTheme.labelSmall!.apply(color: xOnPrimary),
                      ),
                    ],
                  ),
                  Expanded(child: Center()),
                  if (_amount != 0)
                    Container(
                      decoration: BoxDecoration(
                        color: xSecondary,
                        borderRadius: BorderRadius.circular(xSize2),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: xSize1 / 2, vertical: xSize1 / 3),
                      child: Text(
                        "₹${_amount.toString().removeTrailingZeros()} per mating",
                        style: xTheme.textTheme.labelMedium!.apply(color: xOnSecondary),
                      ),
                    ),
                ],
              ),
              Expanded(child: Center()),
              Text(
                _status.capitalizeFirstOfEach,
                style: xTheme.textTheme.headlineLarge!.apply(color: xOnPrimary),
              ),
              SizedBox().vertical(size: xSize / 4),
              // chips and the heart
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // chips
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          maxHeight: xSize*3
                      ),
                      child: Wrap(
                        runSpacing: xSize / 4,
                        spacing: xSize / 4,
                        clipBehavior: Clip.hardEdge,
                        children: _chipsList.map((chip) {
                          return GestureDetector(
                            onTap: (){
                              // todo pass the map of user
                              context.push(ProfileDisplay());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: xOnPrimary,
                                borderRadius: BorderRadius.circular(xSize2),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: xSize1 / 2, vertical: xSize1 / 3),
                              child: Text(
                                chip.trim(),
                                style: xTheme.textTheme.labelMedium,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: xSize * 2.5 * (1 + 1 / 5),
                    width: xSize * 2.5 * (1 + 1 / 5),
                    child: Center(
                      child: XHeartWithImageButton(
                        height: xSize * 2.5,
                        iconR: _theyLiked ? _iconImage : null,
                        iconL: _youLiked ? _iconImage : null,
                        onTap: () {
                          setState(() {
                            _youLiked = !_youLiked;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
              // posted date
              if(_days!=null)Text(
                "posted ${(_days==0)?"today":("$_days ${_days==1?"day":"days"} ago")}",
                style: xTheme.textTheme.labelSmall!.apply(color: xOnPrimary.withOpacity(0.8), fontSizeDelta: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
