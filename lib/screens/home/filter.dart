import 'package:flutter/material.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/extensions/colors.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/extensions/string.dart';
import 'package:pawrapet/utils/widgets/appBar.dart';
import 'package:pawrapet/utils/widgets/inputFields.dart';

import '../../utils/extensions/buildContext.dart';
import '../../utils/functions/common.dart';
import '../../utils/functions/location.dart';
import '../../utils/functions/toShowWidgets.dart';
import '../../utils/widgets/buttons.dart';
import 'home.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({Key? key}) : super(key: key);

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  // todo fetch this list from firebase
  Map allMatingPoints = {
    "12101": {
      'code': '12101',
      'name': 'Center 12101, Faridabad, Haryana',
      'latitude': 28.41337361131685,
      'longitude': 77.30588547288345,
    }
  };
  String myPosition = "Unable to fetch";
  double radius = 30;
  double chargesRangeStart = 0, chargesRangeEnd = 51;
  bool locationLoader = false;
  late String chargesText;

  // the original list or the options that the user has to choose from
  List<String> matingPointsList = [], breedsList = [], colorsList = [], gendersList = [];

  // initial selected list, extract this from local storage
  List<String> initialMatingPointsList = [], initialBreedsList = [], initialColorsList = [], initialGendersList = [];

  // final selected list, use this to compare if there is any change or not
  List<String> finalMatingPointsList = [], finalBreedsList = [], finalColorsList = [], finalGendersList = [];

  @override
  void initState() {
    // todo handle when there is no center available or matingPoints list is empty
    _setupInitialVariables();
    _setChargesText();
    super.initState();
  }

  void _setupInitialVariables() {
    Map? tempMap = xSharedPrefs.matingFilterMap;
    if (tempMap == null) return;
    if (tempMap['position'] != null) myPosition = '${tempMap['position']['city']},${tempMap['position']['state']},${tempMap['position']['pincode']}';
    radius = tempMap['radius'] ?? radius;
    // mating points or centers
    matingPointsList = [];
    for (String code in allMatingPoints.keys) {
      if (getDistanceFromLatLonInKm(tempMap['position']['latitude'], tempMap['position']['longitude'], allMatingPoints[code]['latitude'], allMatingPoints[code]['longitude']) <= radius) {
        matingPointsList.add(allMatingPoints[code]['name']);
      }
    }
    initialMatingPointsList = tempMap['centerCodes'] ?? matingPointsList;
    finalMatingPointsList = [...initialMatingPointsList];

    // breeds
    breedsList = petsData[xProfile!.type].keys.toList();
    initialBreedsList = tempMap['breeds'] ?? [xProfile!.breed!];
    // colours
    if (tempMap['breeds'] != null && tempMap['colours'] != null) {
      initialColorsList = tempMap['colours'];
    }
    // genders
    gendersList = ["male", "female"];
    if (tempMap['genders'] == null) {
      if (xProfile!.gender == "male") initialGendersList = ['female'];
      if (xProfile!.gender == "female") initialGendersList = ['male'];
    } else {
      initialGendersList = tempMap['genders'];
    } // charges
    List<int> chargesList = tempMap['amountRange'] ?? [];
    if (chargesList.isNotEmpty) {
      chargesRangeStart = tempMap['amountRange'][0];
      chargesRangeEnd = tempMap['amountRange'][1];
    }
  }

  void _setChargesText() {
    // limiters
    if (chargesRangeEnd == 0) {
      chargesRangeEnd = 1;
    }
    if (chargesRangeStart == 51) {
      chargesRangeStart = 50;
    }
    if (chargesRangeStart == 0 && chargesRangeEnd == 51) {
      setState(() {
        chargesText = "Any";
      });
      return;
    }
    final startText = (chargesRangeStart == 0) ? 'Less than ' : '${chargesRangeStart.round()}k-';
    final endText = (chargesRangeEnd == 51) ? '50k+' : '${chargesRangeEnd.round()}k';

    setState(() {
      chargesText = "$startText$endText";
    });
    return;
  }

  void _updateMatingPointsList() {
    Map tempMap = xSharedPrefs.matingFilterMap!; // need this for position
    myPosition = '${tempMap['position']['city']},${tempMap['position']['state']},${tempMap['position']['pincode']}';
    // all available mating points or centers
    matingPointsList = [];
    for (String code in allMatingPoints.keys) {
      if (getDistanceFromLatLonInKm(tempMap['position']['latitude'], tempMap['position']['longitude'], allMatingPoints[code]['latitude'], allMatingPoints[code]['longitude']) <= radius) {
        matingPointsList.add(allMatingPoints[code]['name']);
      }
    }
    List<String> tempList = [];
    if (tempMap['centerCodes'] != null) {
      for (String i in tempMap['centerCodes']) {
        if (matingPointsList.contains(i.toString())) {
          tempList.add(i.toString());
        }
      }
    }
    initialMatingPointsList = tempList.isNotEmpty ? tempList : matingPointsList;
    finalMatingPointsList = [...initialMatingPointsList];
    xPrint("$tempList $initialMatingPointsList", header: "_updateMatingPointsList");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            XAppBar(AppBarType.backWithHeading, title: "Filter"),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(xSize / 2),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(xSize / 2),
                      decoration: BoxDecoration(
                        color: xSecondary,
                        borderRadius: BorderRadius.circular(xSize2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox().vertical(size: xSize / 4),
                                    Text(
                                      "Your location",
                                      style: xTheme.textTheme.labelLarge!.apply(color: xPrimary.withOpacity(0.7)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      myPosition,
                                      style: xTheme.textTheme.headlineMedium!.apply(color: xPrimary.withOpacity(0.9)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox().horizontal(size: xSize / 4),
                              InkWell(
                                onTap: () async {
                                  // todo get the users current location and save in the position in shared prefs and open the feed without everything else set as default, this will save yoiu the pain of state manamgement
                                  setState(() {
                                    locationLoader = true;
                                  });
                                  await fetchAndAssignPosition(() {});
                                  _updateMatingPointsList();
                                  setState(() {
                                    locationLoader = false;
                                  });
                                },
                                child: (locationLoader)
                                    ? Container(
                                        height: xSize * 0.6,
                                        width: xSize * 0.6,
                                        margin: const EdgeInsets.only(right: xSize * 0.2),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: xPrimary.withOpacity(0.7),
                                        ),
                                      )
                                    : Icon(
                                        Icons.refresh_rounded,
                                        size: xSize,
                                        color: xPrimary.withOpacity(0.7),
                                      ),
                              )
                            ],
                          ),
                          const Divider(
                            height: xSize / 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Distance you can travel to meet",
                                style: xTheme.textTheme.labelLarge!.apply(color: xPrimary.withOpacity(0.7)),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "${(radius > 100) ? "100+" : radius.round().toString().removeTrailingZeros()} km",
                                style: xTheme.textTheme.labelLarge!.apply(fontWeightDelta: 1, color: xPrimary.withOpacity(0.9)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Opacity(
                            opacity: 0.9,
                            child: Slider(
                              label: "${(radius > 100) ? "100+" : radius.round().toString().removeTrailingZeros()}",
                              value: radius,
                              min: 5,
                              max: 105,
                              // 105 will mean 100+
                              divisions: 20,
                              onChanged: (value) {
                                radius = value;
                                _updateMatingPointsList();
                                setState(() {});
                              },
                            ),
                          ),
                          const Divider(
                            height: xSize / 2,
                          ),
                          XWrapChipsWithHeadingAndAddFromList(
                            heading: "Mating Points",
                            list: matingPointsList,
                            initialList: initialMatingPointsList,
                            onChanged: (v) {
                              finalMatingPointsList = v;
                              setState(() {});
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox().vertical(size: xSize / 2),
                    Container(
                      padding: const EdgeInsets.all(xSize / 4),
                      decoration: BoxDecoration(
                        color: xSecondary,
                        borderRadius: BorderRadius.circular(xSize2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Partner's Profile",
                            style: xTheme.textTheme.headlineMedium!.apply(color: xPrimary.withOpacity(0.9)),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Divider(
                            height: xSize / 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Partner's mating charges (₹)",
                                style: xTheme.textTheme.labelLarge!.apply(color: xPrimary.withOpacity(0.7)),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "$chargesText",
                                style: xTheme.textTheme.labelLarge!.apply(fontWeightDelta: 1, color: xPrimary.withOpacity(0.9)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Opacity(
                            opacity: 0.9,
                            child: SliderTheme(
                              data: SliderThemeData(valueIndicatorColor: xPrimary, valueIndicatorTextStyle: xTheme.textTheme.labelMedium!.apply(color: xOnPrimary)),
                              child: RangeSlider(
                                labels: RangeLabels(
                                  "${(chargesRangeStart == 0) ? "<1" : chargesRangeStart.round()}k",
                                  "${(chargesRangeEnd == 51) ? ">50" : chargesRangeEnd.round()}k",
                                ),
                                values: RangeValues(chargesRangeStart, chargesRangeEnd),
                                min: 0,
                                // less than 1k Rs
                                max: 51,
                                // more than 50k Rs
                                divisions: 51,
                                onChanged: (values) {
                                  chargesRangeStart = values.start;
                                  chargesRangeEnd = values.end;
                                  _setChargesText();
                                },
                              ),
                            ),
                          ),
                          const Divider(height: xSize / 2),
                          XWrapChipsWithHeadingAndAddFromList(
                            heading: "Breed",
                            list: breedsList,
                            initialList: initialBreedsList,
                            onChanged: (v) {
                              try {
                                xPrint(v.toString());
                                finalBreedsList = v;
                                colorsList = [];
                                for (String i in v) {
                                  colorsList = [...colorsList, ...List<String>.from(petsData["dog"][i]["colors"].toList())].toSet().toList();
                                }
                                xPrint(colorsList.toString());
                                setState(() {});
                              } catch (e) {
                                xPrint(e.toString());
                              }
                            },
                          ),
                          if (finalBreedsList.isNotEmpty) const Divider(height: xSize / 2),
                          if (finalBreedsList.isNotEmpty)
                            XWrapChipsWithHeadingAndAddFromList(
                              key: const ValueKey(0),
                              heading: "Colour",
                              list: colorsList,
                              initialList: initialColorsList,
                              onChanged: (v) {
                                finalColorsList = v;
                                setState(() {});
                              },
                            ),
                          const Divider(height: xSize / 2),
                          XWrapChipsWithHeadingAndAddFromList(
                            heading: "Gender",
                            list: gendersList,
                            initialList: initialGendersList,
                            onChanged: (v) {
                              finalGendersList = v;
                              setState(() {});
                            },
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom,
                          )
                        ],
                      ),
                    ),
                    const SizedBox().vertical(size: xSize / 2),
                    XRoundedButton(
                      onPressed: () {
                        // check if mating points are selected else alert
                        xPrint("test - $finalMatingPointsList");
                        if (finalMatingPointsList.isEmpty) {
                          xSnackbar(context, "Please choose at least one mating point", type: MessageType.error);
                          return;
                        }
                        // save all the details in shared Prefs to be used by home screen
                        // 1) the position is already updated
                        // 2) the center codes
                        xSharedPrefs.setCenterCodesInMatingFilters(finalMatingPointsList);
                        // 3) the radius
                        xSharedPrefs.setRadiusInMatingFilters(radius);
                        // 4) the range of amount
                        xSharedPrefs.setAmountInMatingFilters([chargesRangeStart, chargesRangeEnd]);
                        // 5) breed
                        xSharedPrefs.setBreedsInMatingFilters(finalBreedsList);
                        // 6) colour
                        xSharedPrefs.setColorsInMatingFilters(finalColorsList);
                        // 7) gender
                        xSharedPrefs.setGendersInMatingFilters(finalGendersList);
                        // redirect to the home feed page, index = 1 is for the feed
                        context.push(const Home(index: 1));
                      },
                      text: "Show results",
                      expand: true,
                      backgroundColor: xPrimary.withOpacity(0.7),
                      enabled: finalMatingPointsList.isNotEmpty,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
