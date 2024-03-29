import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../firebase/firestore.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/sizedBox.dart';
import '../../utils/extensions/string.dart';
import '../../utils/widgets/appBar.dart';
import '../../utils/widgets/displayText.dart';
import '../../utils/widgets/inputFields.dart';
import '../../utils/extensions/buildContext.dart';
import '../../utils/functions/common.dart';
import '../../utils/functions/location.dart';
import '../../utils/functions/toShowWidgets.dart';
import '../../utils/widgets/buttons.dart';
import 'home.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            XAppBar(AppBarType.backWithHeading, title: "Setup Preferences"),
            PreferencesWithLocationHandler(),
          ],
        ),
      ),
    );
  }
}

class Preferences extends StatefulWidget {
  bool displayPartnersProfile;
  bool displayLocationRadMatingsCenters;

  Preferences({
    Key? key,
    this.displayLocationRadMatingsCenters = true,
    this.displayPartnersProfile = true,
  }) : super(key: key);

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  String myPosition = "Unable to fetch";
  double radius = 30;
  bool locationLoader = false, saveLoader = false;
  double chargesRangeStart = 0, chargesRangeEnd = 51;

  // the original list or the options that the user has to choose from
  List<String> matingCentersNameList1 = [], breedsList = [], colorsList = [], gendersList = [];

  // initial selected list, extract this from local storage
  List<String> initialMatingCentersNameList1 = [], initialBreedsList = [], initialColorsList = [], initialGendersList = [];

  // final selected list, use this to compare if there is any change or not
  List<String> finalMatingCentersNameList1 = [], finalBreedsList = [], finalColorsList = [], finalGendersList = [];
  late String chargesText;

  @override
  void initState() {
    // todo handle when there is no center available or matingPoints list is empty
    _setupInitialVariables();
    _setChargesText();

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

  void _setupInitialVariables() {
    Map? tempMap = xSharedPrefs.matingFilterMap;
    xPrint("${xProfile!.type} $tempMap", header: "Preferences/_setupInitialVariables");
    if (tempMap == null) return;
    // radius and mating
    updateMatingPointsListWithRadius();
    // breeds
    breedsList = petsData[xProfile!.type].keys.toList();
    initialBreedsList = List<String>.from(tempMap['breeds']??[]);
    // colors
    if (tempMap['breeds'] != null && tempMap['colors'] != null) {
      initialColorsList = List<String>.from(tempMap['colors']);
    }
    updateColorList(initialBreedsList, removeList: initialColorsList);
    // genders
    gendersList = ["Male", "Female"];
    // todo enable this feature once there are multiple pets
    // if (tempMap['genders'] == null || tempMap['genders'].isEmpty) {
    //   if (xProfile!.gender == "Male") initialGendersList = ['Female'];
    //   if (xProfile!.gender == "Female") initialGendersList = ['Male'];
    // } else {
    //   initialGendersList = List<String>.from(tempMap['genders']);
    // }
    initialGendersList = List<String>.from(tempMap['genders']??[]);

    // charges
    List<double> chargesList = List<double>.from(tempMap['amountRange'] ?? []);
    if (chargesList.isNotEmpty) {
      chargesRangeStart = chargesList[0];
      chargesRangeEnd = chargesList[1];
    }
    // assign final variables
    finalBreedsList = [...initialBreedsList];
    finalColorsList = [...initialColorsList];
    finalGendersList = [...initialGendersList];
  }

  /// updates the radius and all the mating points available in that radius. It doesn't call the setState
  void updateMatingPointsListWithRadius({double? rad}) {
    Map tempMap = xSharedPrefs.matingFilterMap!; // need this for position
    if (tempMap['position'] != null) myPosition = '${tempMap['position']['city']},${tempMap['position']['state']},${tempMap['position']['pincode']}';
    radius = rad ?? tempMap['radius'] ?? radius;
    // all available mating points or centers
    matingCentersNameList1 = [];
    for (String code in allMatingPoints.keys) {
      if (getDistanceFromLatLonInKm(tempMap['position']['latitude'], tempMap['position']['longitude'], allMatingPoints[code]['latitude'], allMatingPoints[code]['longitude']) <= radius) {
        matingCentersNameList1.add(allMatingPoints[code]['name']);
      }
    }
    List<String> tempList = [];
    if (tempMap['centerCodes'] != null) {
      for (String code in tempMap['centerCodes']) {
        if (matingCentersNameList1.contains(allMatingPoints[code]['name'])) {
          tempList.add(allMatingPoints[code]['name']);
        }
      }
    }
    initialMatingCentersNameList1 = [...tempList];
    finalMatingCentersNameList1 = [...initialMatingCentersNameList1];
  }

  void updateColorList(List<String> breedList, {List<String>? removeList}) {
    colorsList = [];
    finalColorsList = [];
    for (String i in breedList) {
      colorsList = [...colorsList, ...List<String>.from(petsData["dog"][i]["colors"].toList())].toSet().toList();
    }
    if (removeList != null) {
      for (String i in removeList) {
        if (colorsList.contains(i)) {
          colorsList.remove(i);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Map? tempMap = xSharedPrefs.matingFilterMap;
    xPrint("$finalBreedsList $finalColorsList $finalGendersList $tempMap", header: "Preferences/build");
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(xSize / 2),
      child: Column(
        children: [
          (finalMatingCentersNameList1.isEmpty) ? xInfoText(context, "To proceed further, please choose at least one mating center which you can visit.") : const Center(),
          (finalMatingCentersNameList1.isEmpty) ? const SizedBox().vertical(size: xSize / 2) : const Center(),
          (widget.displayLocationRadMatingsCenters) ? locationDistanceCenters() : const Center(),
          (widget.displayLocationRadMatingsCenters) ? const SizedBox().vertical(size: xSize / 2) : const Center(),
          (widget.displayPartnersProfile) ? partnersProfile() : const Center(),
          (widget.displayPartnersProfile) ? const SizedBox().vertical(size: xSize / 2) : const Center(),
          (!saveLoader) ? saveAndShowResultsButton() : const LinearProgressIndicator(),
        ],
      ),
    );
  }

  Widget locationDistanceCenters() {
    return Container(
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
                  setState(() {
                    locationLoader = true;
                  });
                  // get and assign position
                  await fetchAndAssignPosition();
                  // update the mating Center list and the radius
                  updateMatingPointsListWithRadius();
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
              label: (radius > 100) ? "100+" : radius.round().toString().removeTrailingZeros(),
              value: radius,
              min: 5,
              max: 105,
              // 105 will mean 100+
              divisions: 20,
              onChanged: (value) {
                updateMatingPointsListWithRadius(rad: value);
                setState(() {});
              },
            ),
          ),
          const Divider(
            height: xSize / 2,
          ),
          SizedBox(
            height: xSize / 4,
          ),
          XWrapChipsWithHeadingAndAddFromList(
            heading: "Mating Centers",
            list: matingCentersNameList1,
            initialList: initialMatingCentersNameList1,
            onChanged: (v) {
              finalMatingCentersNameList1 = v;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget partnersProfile() {
    return Container(
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
          matingCharges(),
          const Divider(height: xSize / 2),
          XWrapChipsWithHeadingAndAddFromList(
            heading: "Breed",
            list: breedsList,
            initialList: initialBreedsList,
            onChanged: (v) {
              try {
                xPrint(v.toString());
                finalBreedsList = v;
                updateColorList(finalBreedsList);
                xPrint(colorsList.toString());
                setState(() {});
              } catch (e) {
                xPrint(e.toString());
              }
            },
          ),
          if (initialBreedsList.isNotEmpty && finalBreedsList.isNotEmpty) const Divider(height: xSize / 2),
          if (initialBreedsList.isNotEmpty && finalBreedsList.isNotEmpty)
            XWrapChipsWithHeadingAndAddFromList(
              key: const ValueKey(0),
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
    );
  }

  Widget matingCharges() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Partner's mating charges (₹)",
              style: xTheme.textTheme.labelLarge!.apply(color: xPrimary.withOpacity(0.7)),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              chargesText,
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
      ],
    );
  }

  Widget saveAndShowResultsButton() {
    return XRoundedButton(
      onPressed: () async {
        // check if mating points are selected else alert
        if (finalMatingCentersNameList1.isEmpty) {
          xSnackbar(context, "Please choose at least one mating point", type: MessageType.error);
          return;
        }
        setState(() {
          saveLoader = true;
        });
        // save all the details in shared Prefs to be used by home screen
        // 1) the position is already updated
        // 2) the center codes
        List<String> tempCodes = [];
        for (String i in allMatingPoints.keys) {
          if (finalMatingCentersNameList1.contains(allMatingPoints[i]['name'])) {
            tempCodes.add(i);
          }
        }
        try {
          Map<String, dynamic> filterMap = Map<String, dynamic>.from(xSharedPrefs.matingFilterMap ?? {});
          List<Future> promises = [];
          // update the centerCodes if they are different than previous
          if (!listEquals(tempCodes, List<String>.from(filterMap['centerCodes'] ?? []))) {
            xPrint("flag 1", header: "Preferences/saveAndShowResultsButton");
            bool flag = await FirebaseCloudFirestore().updateCenterCodes(xProfile!.uidPN, tempCodes);
            if (!flag) throw Exception("Error while updating the centerCodes in the profile in firebase");
            promises.add(xSharedPrefs.setCenterCodesInMatingFilters(tempCodes));
          }
          xPrint("flag 2", header: "Preferences/saveAndShowResultsButton");
          // 3) the radius
          promises.add(xSharedPrefs.setRadiusInMatingFilters(radius));
          // 4) the range of amount
          xPrint("flag 3", header: "Preferences/saveAndShowResultsButton");
          promises.add(xSharedPrefs.setAmountInMatingFilters([chargesRangeStart, chargesRangeEnd]));
          // 5) breed
          xPrint("flag 4", header: "Preferences/saveAndShowResultsButton");
          promises.add(xSharedPrefs.setBreedsInMatingFilters(finalBreedsList));
          // 6) color
          xPrint("flag 5", header: "Preferences/saveAndShowResultsButton");
          promises.add(xSharedPrefs.setColorsInMatingFilters(finalColorsList));
          // 7) gender
          xPrint("flag 6", header: "Preferences/saveAndShowResultsButton");
          promises.add(xSharedPrefs.setGendersInMatingFilters(finalGendersList));
          // await
          await Future.wait(promises);
          // redirect to the home feed page, index = 1 is for the feed
          context.push(const Home(index: 1));
        } catch (e) {
          xSnackbar(context, "Sorry, unable to update, please again later.");
          xPrint(e.toString(), header: "Preferences/saveAndShowResultsButton");
        }

        setState(() {
          saveLoader = false;
        });
      },
      text: "Save",
      expand: true,
      backgroundColor: xPrimary.withOpacity(0.7),
      enabled: finalMatingCentersNameList1.isNotEmpty,
    );
  }
}

class PreferencesWithLocationHandler extends StatefulWidget {
  bool displayPartnersProfile;
  bool displayLocationRadMatingsCenters;

  PreferencesWithLocationHandler({
    super.key,
    this.displayPartnersProfile = true,
    this.displayLocationRadMatingsCenters = true,
  });

  @override
  State<PreferencesWithLocationHandler> createState() => _PreferencesWithLocationHandlerState();
}

class _PreferencesWithLocationHandlerState extends State<PreferencesWithLocationHandler> {
  bool gettingLocation = false;

  @override
  Widget build(BuildContext context) {
    xPrint("build called", header: 'PreferencesWithLocationHandler');

    if (xSharedPrefs.matingFilterMap?['position'] == null) {
      return getLocationPermissionWidget();
    } else {
      return Expanded(
        child: Preferences(
          displayPartnersProfile: widget.displayPartnersProfile,
          displayLocationRadMatingsCenters: widget.displayLocationRadMatingsCenters,
        ),
      );
    }
  }

  // get location
  Widget getLocationPermissionWidget() {
    return Container(
      padding: const EdgeInsets.all(xSize / 2),
      margin: const EdgeInsets.all(xSize / 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(xSize / 3),
        color: xSecondary,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Approximate Location",
            style: xTheme.textTheme.headlineMedium,
          ),
          const SizedBox().vertical(size: xSize / 2),
          Text(
            "To access mating feature we require your approximate location inorder to check our availability of our centers in your area.\nOur team ensures a guided mating process at our centers.",
            style: xTheme.textTheme.bodyMedium,
          ),
          const SizedBox().vertical(size: xSize / 2),
          gettingLocation
              ? const LinearProgressIndicator()
              : XRoundedButton(
                  onPressed: () async {
                    setState(() {
                      gettingLocation = true;
                    });
                    await fetchAndAssignPosition();
                    setState(() {
                      gettingLocation = false;
                    });
                  },
                  expand: true,
                  text: "Provide Location",
                  textStyle: xTheme.textTheme.bodyMedium!.apply(fontWeightDelta: 0, color: xSecondary),
                ),
        ],
      ),
    );
  }
}
