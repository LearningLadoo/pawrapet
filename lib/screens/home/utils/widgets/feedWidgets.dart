import 'package:flutter/material.dart';
import 'package:pawrapet/utils/extensions/buildContext.dart';
import 'package:pawrapet/utils/extensions/dateTime.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/extensions/string.dart';
import '../../../../firebase/firestore.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/functions/common.dart';
import '../../../../utils/widgets/heart.dart';
import '../../../profile/profileDisplay.dart';

class FindingPartnerWidget extends StatefulWidget {
  final Map<String, dynamic> feedMap;

  const FindingPartnerWidget({Key? key, required this.feedMap}) : super(key: key);

  @override
  State<FindingPartnerWidget> createState() => _FindingPartnerWidgetState();
}

class _FindingPartnerWidgetState extends State<FindingPartnerWidget> {
  late bool _theyLiked, _youLiked;
  late ImageProvider _iconImage, _mainImage;
  late String _status;
  late double? _amount;
  late List<String> _chipsList;
  int? _days, _age;

  @override
  void initState() {
    _amount = (widget.feedMap['amount'] ?? 0) * 1.0;
    _iconImage = Image.network(widget.feedMap['assets']['icon_0']['url']).image;
    _mainImage = Image.network(widget.feedMap['assets']['main_0']['url']).image;
    _theyLiked = widget.feedMap['requestedUsersForMatch']?[xProfile!.uidPN] == true;
    _youLiked = xProfile!.requestedUsersMapForMatch?[widget.feedMap['uidPN']] == true;
    // Todo: change this if you have make it social media
    _status = "finding partner";
    _age = DateTime(0).fromddMMyyyy(widget.feedMap['birthDate']).calculateYears();
    // set up the chips that will be displayed
    String chips = "${widget.feedMap['type']},"
        "${widget.feedMap['breed']},"
        "${(_age == 0 ? "<1" : _age)} yrs,"
        "${widget.feedMap['gender']},${widget.feedMap['weight'].toString().removeTrailingZeros()} Kg,"
        "${widget.feedMap['height'].toString().removeTrailingZeros()} cm,"
        "${widget.feedMap['personality']}";
    _chipsList = chips.split(",");
    if (_chipsList.length > 7) {
      _chipsList = _chipsList.sublist(0, 7);
    }
    _chipsList.add("Show Full »");
    _days = DateTime.fromMillisecondsSinceEpoch(widget.feedMap['lastProfileUpdated']).calculateDays();
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
          padding: EdgeInsets.all(xSize / 4),
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
                        widget.feedMap['name'].toString().capitalizeFirstOfEach,
                        style: xTheme.textTheme.labelLarge!.apply(color: xOnPrimary),
                      ),
                      Text(
                        "@${widget.feedMap['username']}",
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
                      constraints: const BoxConstraints(maxHeight: xSize * 3),
                      child: Wrap(
                        runSpacing: xSize / 4,
                        spacing: xSize / 4,
                        clipBehavior: Clip.hardEdge,
                        children: _chipsList.map((chip) {
                          return GestureDetector(
                            onTap: () {
                              context.push(ProfileDisplay(feedMap: widget.feedMap));
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
                        iconL: _youLiked ? xMyIcon().image : null,
                        onTap: () async {
                          setState(() {
                            _youLiked = !_youLiked;
                          });
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
                  )
                ],
              ),
              // posted date
              if (_days != null)
                Text(
                  "updated ${(_days == 0) ? "today" : ("$_days ${_days == 1 ? "day" : "days"} ago")}",
                  style: xTheme.textTheme.labelSmall!.apply(color: xOnPrimary.withOpacity(0.8), fontSizeDelta: 1),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
