import 'package:flutter/material.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/extensions/colors.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/extensions/string.dart';
import 'package:pawrapet/utils/widgets/appBar.dart';
import 'package:pawrapet/utils/widgets/inputFields.dart';

import '../../utils/functions/common.dart';
import '../../utils/widgets/buttons.dart';

class Filters extends StatefulWidget {
  const Filters({Key? key}) : super(key: key);

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  String currLocation = "Faridabad, Haryana, 121001";
  double maxDistance = 10;
  double chargesRangeStart = 0, chargesRangeEnd = 51;
  late String chargesText;
  List<String> matingPointsList = [], breedsList = [], colorsList = [], gendersList = [];
  List<String> initialMatingPointsList = [], initialBreedsList = [], initialColorsList = [], initialGendersList = [];
  List<String> finalMatingPointsList = [], finalBreedsList = [], finalColorsList = [], finalGendersList = [];

  @override
  void initState() {
    _setChargesText();
    matingPointsList = ["Center 1211 faridabad, Haryana"];
    // todo get the dog and gender and color before hand to show the default;
    breedsList = petsData["dog"].keys.toList();
    gendersList = ["male", "female"];
    super.initState();
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
                                      currLocation,
                                      style: xTheme.textTheme.headlineMedium!.apply(color: xPrimary.withOpacity(0.9)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox().horizontal(size: xSize / 4),
                              InkWell(
                                onTap: () {
                                  // todo get the users current location
                                },
                                child: Icon(
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
                                "${(maxDistance > 100) ? "100+" : maxDistance.round().toString().removeTrailingZeros()} km",
                                style: xTheme.textTheme.labelLarge!.apply(fontWeightDelta: 1, color: xPrimary.withOpacity(0.9)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Opacity(
                            opacity: 0.9,
                            child: Slider(
                              label: "${(maxDistance > 100) ? "100+" : maxDistance.round().toString().removeTrailingZeros()}",
                              value: maxDistance,
                              min: 5,
                              max: 105,
                              // 105 will mean 100+
                              divisions: 20,
                              onChanged: (value) {
                                setState(() {
                                  maxDistance = value;
                                });
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
                              key: ValueKey(0),
                              heading: "Color",
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
                        // todo : Save in a map and return to the previous widget
                      },
                      text: "Save",
                      expand: true,
                      backgroundColor: xPrimary.withOpacity(0.7),
                      enabled: true,
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
