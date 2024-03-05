import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/functions/common.dart';
import 'package:pawrapet/utils/functions/paths.dart';
import 'package:pawrapet/utils/functions/uploadFiles.dart';
import 'package:pawrapet/utils/widgets/appBar.dart';
import 'package:pawrapet/utils/widgets/buttons.dart';
import 'package:pawrapet/utils/widgets/inputFields.dart';
import '../../firebase/firestore.dart';
import '../../firebase/storage.dart';
import '../../utils/extensions/buildContext.dart';
import '../../utils/extensions/map.dart';
import '../../utils/widgets/common.dart';
import '../../utils/widgets/displayText.dart';
import '../../utils/widgets/datePicker.dart';
import '../loaderScreen.dart';
import 'profileDisplay.dart';
import 'utils/functions.dart';

///
/// Profile structure {
///   username: <String>,
///   name: <String>,
///   type: <String>,
///   color: <String>,
///   breed: <String>,
///   birthDate: <String>, // in dd/mm/yyyy format
///   gender: <String>,
///   personality: <String>, // separated with commas
///   description: <String?>,
///   height: <double>, // in cm
///   weight: <double>, // in kgs
///   amount: <double>, // in Rs
///   assets: {  // will be stored as string in isar,
///       icon_0: {
///          ext: "jpg",
///          url: "http://"
///       }
///   }
///   timestamp: <epoch in seconds>
/// }

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _chargeAmount = false;
  String? _error;
  String? loaderText = "Please wait while we process...";
  late Map<String, dynamic> currProfileMap, fetchedProfileMap;

  late Map<String, dynamic> assetsMapWithImageProvider; // with image provider
  late Future<bool> initializeFutureObject;

  Future<bool> initialize() async {
    try {
      fetchedProfileMap = (await FirebaseCloudFirestore().getProfileDetails(xSharedPrefs.activeProfileUidPN!)) ?? getDefaultProfileMap();
      currProfileMap = Map<String, dynamic>.from(fetchedProfileMap.deepClone());
      loaderText = null;
      _chargeAmount = currProfileMap['amount']!=0;
      initializeAssetsMap();
      return true;
    } catch (e) {
      xPrint(e.toString(), header: "profile/initialize");
      return false;
    }
  }

  void initializeAssetsMap() {
    try {
      currProfileMap['assets'] = currProfileMap['assets'] ?? getDefaultProfileMap()['assets'];
      assetsMapWithImageProvider = Map<String, dynamic>.from(Map.from(currProfileMap['assets']).deepClone());

      xPrint('keys - ${assetsMapWithImageProvider.keys}', header: "profile/initializeAssetsMap");
      for (String i in assetsMapWithImageProvider.keys) {
        xPrint('$i is the i', header: "profile/initializeAssetsMap");
        String type = i.split('_')[0];
        String index = i.split('_')[1];
        // casting
        // assetsMapWithImageProvider[i] = Map<String,dynamic>.from(assetsMapWithImageProvider[i]);
        xPrint('data - ${assetsMapWithImageProvider[i]} and type ${assetsMapWithImageProvider[i].runtimeType}', header: "profile/initializeAssetsMap");

        (assetsMapWithImageProvider[i]).addAll({
          "path": getProfileImagesPath(
            profileNo: xSharedPrefs.activeProfileNumber!,
            type: type,
            index: int.parse(index),
            ext: assetsMapWithImageProvider[i]?["ext"] ?? "jpg",
          ),
          "image": ((currProfileMap['assets'][i]['url'] != null) ? Image.network(currProfileMap['assets'][i]['url']).image : null) as dynamic,
          "isNew": false,
        });
      }
    } catch (e) {
      xPrint("error - $e", header: "profile/initializeAssetsMap");
    }
    xPrint("${assetsMapWithImageProvider.toString()} and ${xSharedPrefs.activeProfileNumber}", header: "profile/initializeAssetsMap");
  }

  void handleAddImages(String key, ImageProvider? image) {
    if (image != null) {
      assetsMapWithImageProvider[key]["image"] = image;
      assetsMapWithImageProvider[key]["isNew"] = true;
      currProfileMap["assets"][key]["url"] = "add"; // command to add details to cloud
      xPrint("asset with image map - ${assetsMapWithImageProvider} and profile asset map - ${currProfileMap["assets"]}", header: "Profile/handleAddImages");
      setState(() {});
    }
  }

  Future<bool> saveProfileDetails() async {
    try {
      if (jsonEncode(currProfileMap) == jsonEncode(fetchedProfileMap)) return true;
      xPrint(currProfileMap.toString(), header: "saveProfileDetails");
      currProfileMap['assets'] = await FirebaseCloudStorage().addProfileImages(xSharedPrefs.activeProfileUidPN!, currProfileMap['assets']);
      if (currProfileMap['assets'] == null) throw ("error while saving images");
      bool temp = await FirebaseCloudFirestore().updateProfile(xSharedPrefs.activeProfileUidPN!, currProfileMap);
      if (temp == false) throw ("error while updating profile");
      // save in the local
      xProfile!.name = currProfileMap['name'];
      xProfile!.iconBase64 = base64Encode(await File(assetsMapWithImageProvider['icon_0']['path']).readAsBytes());
      xProfile!.iconUrl = currProfileMap['assets']['icon_0']['url'];
      xProfile!.amount = currProfileMap['amount']*1.0;
      xProfile!.type = currProfileMap['type'] ;
      xProfile!.breed = currProfileMap['breed'] ;
      xProfile!.color = currProfileMap['color'];
      xProfile!.gender = currProfileMap['gender'];
      xProfile!.height = currProfileMap['height']*1.0;
      xProfile!.weight = currProfileMap['weight']*1.0;
      await xProfileIsarManager.setProfile(xProfile!);
      xPrint(currProfileMap.toString(), header: "saveProfileDetails");
      return true;
    } catch (e) {
      xPrint("error ${e.toString()}", header: "saveProfileDetails");
      return false;
    }
  }

  @override
  void initState() {
    initializeFutureObject = initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: initializeFutureObject,
            builder: (context, snap) {
              if (!(snap.connectionState == ConnectionState.done && snap.hasData) || loaderText != null) {
                return Center(child: dogWaitLoader(loaderText));
              }
              return Column(
                children: [
                  XAppBar(AppBarType.backWithHeading, title: "Edit Profile"),
                  Expanded(
                      child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(xSize / 2),
                    child: Column(
                      children: [
                        // icon image
                        GestureDetector(
                          onTap: () async {
                            try {
                              String key = "icon_0";
                              final image = await xPickCropCompressSaveImage(
                                  source: ImageSource.gallery, cropAspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), path: assetsMapWithImageProvider[key]["path"]);
                              handleAddImages(key, image);
                            } catch (e) {
                              xPrint(e.toString());
                            }
                          },
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: xSize5 * 3, // thrice of the font size
                                backgroundColor: xSecondary.withOpacity(0.9),
                                backgroundImage: assetsMapWithImageProvider["icon_0"]["image"],
                                child: (assetsMapWithImageProvider["icon_0"]["image"] == null)
                                    ? Icon(
                                        Icons.add,
                                        color: xOnSecondary.withOpacity(0.5),
                                        size: xSize,
                                      )
                                    : Center(),
                              ),
                              if (assetsMapWithImageProvider["icon_0"]["image"] != null)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                      padding: const EdgeInsets.all(xSize / 4),
                                      decoration: BoxDecoration(
                                        color: xOnSurface,
                                        borderRadius: BorderRadius.circular(xSize),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.7),
                                            blurRadius: 5.0,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.edit_rounded,
                                        color: xOnSecondary.withOpacity(0.8),
                                        size: xSize * 0.7,
                                      )),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox().vertical(),
                        const SizedBox().vertical(),
                        // name
                        XTextField(
                          hintText: "Name",
                          textInputAction: TextInputAction.next,
                          initialValue: currProfileMap['name'],
                          keyboardType: TextInputType.text,
                          onChangedFn: (String? value) {
                            setState(() {
                              currProfileMap['name'] = value;
                              _error = null;
                            });
                            xPrint("name - $currProfileMap['name']");
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                          },
                        ),
                        const SizedBox().vertical(),
                        // dob
                        XDatePickerField(
                          hintText: "Date of Birth",
                          onTap: () {
                            _error = null;
                            setState(() {});
                          },
                          onSelected: (String? value) {
                            currProfileMap['birthDate'] = value;
                            _error = null;
                          },
                          initialValue: currProfileMap['birthDate'],
                        ),
                        const SizedBox().vertical(),
                        // type
                        XDropDownField(
                          hintText: "Type",
                          textInputAction: TextInputAction.next,
                          initialValue: currProfileMap['type'],
                          keyboardType: TextInputType.text,
                          list: petsData.keys.toList(),
                          onTap: () {
                            _error = null;
                            setState(() {});
                          },
                          onSelected: (String? value) {
                            currProfileMap['type'] = value;
                            // resetting the values
                            currProfileMap['breed'] = null;
                            currProfileMap['color'] = null;
                            currProfileMap['gender'] = null;
                            setState(() {});
                            xPrint("selected type - $value");
                          },
                        ),
                        const SizedBox().vertical(),
                        // breed
                        XDropDownField(
                          hintText: "Breed",
                          textInputAction: TextInputAction.next,
                          initialValue: currProfileMap['breed'],
                          keyboardType: TextInputType.text,
                          list: (currProfileMap['type'] == null) ? [] : petsData[currProfileMap['type']].keys.toList(),
                          onTap: () {
                            if (currProfileMap['type'] == null) {
                              _error = "Please choose the type first";
                              setState(() {});
                            }
                          },
                          onSelected: (String? value) {
                            currProfileMap['breed'] = value;
                            setState(() {});
                            xPrint("selected breed - $value");
                          },
                        ),
                        const SizedBox().vertical(),
                        // gender
                        XDropDownField(
                          hintText: "Gender",
                          textInputAction: TextInputAction.next,
                          initialValue: currProfileMap['gender'],
                          keyboardType: TextInputType.text,
                          list: (currProfileMap['type'] == null || currProfileMap['breed'] == null)
                              ? []
                              : List<String>.from(petsData[currProfileMap['type']][currProfileMap['breed']]["genders"].toList()),
                          onTap: () {
                            if (currProfileMap['type'] == null || currProfileMap['breed'] == null) {
                              _error = "Please choose the type and breed first";
                              setState(() {});
                            }
                          },
                          onSelected: (String? value) {
                            currProfileMap['gender'] = value;
                            setState(() {});
                            xPrint("selected breed - $value");
                          },
                        ),
                        const SizedBox().vertical(),
                        // color
                        XDropDownField(
                          hintText: "color",
                          textInputAction: TextInputAction.next,
                          initialValue: currProfileMap['color'],
                          keyboardType: TextInputType.text,
                          list: (currProfileMap['type'] == null || currProfileMap['breed'] == null)
                              ? []
                              : List<String>.from(petsData[currProfileMap['type']][currProfileMap['breed']]["colors"].toList()),
                          onTap: () {
                            if (currProfileMap['type'] == null || currProfileMap['breed'] == null) {
                              _error = "Please choose the type and breed first";
                            }
                            setState(() {});
                          },
                          onSelected: (String? value) {
                            currProfileMap['color'] = value;
                            setState(() {});
                            xPrint("selected breed - $value");
                          },
                        ),
                        const SizedBox().vertical(),
                        // height weight
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: XTextField(
                                hintText: "Height (cm)",
                                textInputAction: TextInputAction.next,
                                initialValue: currProfileMap['height'] != null ? currProfileMap['height'].toString() : null,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                                onChangedFn: (String? value) {
                                  setState(() {
                                    currProfileMap['height'] = (value != null) ? double.parse(value) : null;
                                    _error = null;
                                  });
                                  xPrint("height - $currProfileMap['height']");
                                },
                                onEditingComplete: () {
                                  FocusScope.of(context).nextFocus();
                                },
                              ),
                            ),
                            const SizedBox().horizontal(),
                            Expanded(
                              flex: 1,
                              child: XTextField(
                                hintText: "Weight (kg)",
                                textInputAction: TextInputAction.next,
                                initialValue: currProfileMap['weight'] != null ? currProfileMap['weight'].toString() : null,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                                onChangedFn: (String? value) {
                                  setState(() {
                                    currProfileMap['weight'] = (value != null) ? double.parse(value) : null;
                                    _error = null;
                                  });
                                  xPrint("weight - $currProfileMap['weight']");
                                },
                                onEditingComplete: () {
                                  FocusScope.of(context).nextFocus();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox().vertical(),
                        // personality
                        XTextField(
                          hintText: "Personality (separate with comma)",
                          textInputAction: TextInputAction.next,
                          initialValue: currProfileMap['personality'],
                          keyboardType: TextInputType.text,
                          autofillHints: (currProfileMap['type'] == null || currProfileMap['breed'] == null)
                              ? null
                              : List<String>.from(petsData[currProfileMap['type']][currProfileMap['breed']]["characteristics"].toList()),
                          onChangedFn: (String? value) {
                            setState(() {
                              currProfileMap['personality'] = value;
                              _error = null;
                            });
                            xPrint("personality - $currProfileMap['personality']");
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                          },
                        ),
                        const SizedBox().vertical(),
                        // description
                        XTextField(
                          hintText: "\n\nDescription (optional)",
                          // because there are 5 lines so two new lines lines did the trick
                          lines: 5,
                          textInputAction: TextInputAction.newline,
                          initialValue: currProfileMap['description'],
                          keyboardType: TextInputType.multiline,
                          onChangedFn: (String? value) {
                            setState(() {
                              currProfileMap['description'] = value;
                              _error = null;
                            });
                            xPrint("description - $currProfileMap['description']");
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                          },
                        ),
                        const SizedBox().vertical(),
                        // main_image
                        GestureDetector(
                          onTap: () async {
                            try {
                              String key = "main_0";
                              final image = await xPickCropCompressSaveImage(
                                source: ImageSource.gallery,
                                cropAspectRatio: const CropAspectRatio(ratioX: 2, ratioY: 3),
                                path: assetsMapWithImageProvider[key]["path"],
                              );
                              handleAddImages(key, image);
                            } catch (e) {
                              xPrint(e.toString());
                            }
                          },
                          child: Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 2 / 3,
                                child: Container(
                                  // width: xWidth,
                                  decoration: BoxDecoration(
                                    color: xSecondary.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(xSize2),
                                    image: (assetsMapWithImageProvider["main_0"]["image"] != null) ? DecorationImage(image: assetsMapWithImageProvider["main_0"]["image"]!, fit: BoxFit.cover) : null,
                                  ),
                                  child: (assetsMapWithImageProvider["main_0"]["image"] == null)
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_rounded,
                                              color: xOnSecondary.withOpacity(0.5),
                                              size: xSize * 1.5,
                                            ),
                                            Text(
                                              "Add Image\n(to display to other users)",
                                              style: xTheme.textTheme.bodyLarge!.copyWith(
                                                color: xOnSecondary.withOpacity(0.5),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )
                                      : const Center(),
                                ),
                              ),
                              if (assetsMapWithImageProvider["main_0"]["image"] != null)
                                Positioned(
                                  bottom: xSize / 2,
                                  right: xSize / 2,
                                  child: Container(
                                      padding: const EdgeInsets.all(xSize / 4),
                                      decoration: BoxDecoration(
                                        color: xOnPrimary,
                                        borderRadius: BorderRadius.circular(xSize),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.7),
                                            blurRadius: 5.0,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.edit_rounded,
                                        color: xOnSecondary.withOpacity(0.8),
                                        size: xSize * 0.7,
                                      )),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox().vertical(),
                        // do you want to charge amount
                        Container(
                          padding: const EdgeInsets.all(xSize / 4),
                          decoration: BoxDecoration(
                            color: xOnSurface,
                            borderRadius: BorderRadius.circular(xSize2),
                          ),
                          child: Column(
                            children: [
                              Text("Do you want to charge any amount for mating ?", style: xTheme.textTheme.bodyLarge!.apply(fontWeightDelta: 2)),
                              if (_chargeAmount) const SizedBox().vertical(size: xSize / 4),
                              // infoText
                              if (_chargeAmount) xInfoText(context, "The platform charges will be 10% of the amount you choose"),
                              if (_chargeAmount) const SizedBox().vertical(size: xSize / 4),
                              // amount textField
                              if (_chargeAmount)
                                XTextField(
                                  hintText: "Amount (₹)",
                                  textInputAction: TextInputAction.next,
                                  initialValue: currProfileMap['amount'] == null || currProfileMap['amount']==0? null : currProfileMap['amount'].toString(),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  onChangedFn: (String? value) {
                                    setState(() {
                                      currProfileMap['amount'] = (value != null) ? double.parse(value) : 0;
                                      _error = null;
                                    });
                                    xPrint("amount - $currProfileMap['amount']");
                                  },
                                  onEditingComplete: () {
                                    FocusScope.of(context).nextFocus();
                                  },
                                ),
                              const SizedBox().vertical(size: xSize / 4),
                              // yes
                              Row(
                                children: [
                                  XRoundedButton(
                                    onPressed: () {
                                      _chargeAmount = false;
                                      currProfileMap['amount'] = 0;
                                      setState(() {});
                                    },
                                    text: "No",
                                    backgroundColor: xOnSecondary.withOpacity(_chargeAmount ? 0.5 : 1),
                                    padding: const EdgeInsets.symmetric(vertical: xSize / 6, horizontal: xSize / 2),
                                    textStyle: xTheme.textTheme.labelLarge!.apply(color: xOnPrimary),
                                  ),
                                  SizedBox().horizontal(size: xSize / 4),
                                  XRoundedButton(
                                    onPressed: () {
                                      _chargeAmount = true;
                                      setState(() {});
                                    },
                                    text: "Yes",
                                    backgroundColor: xOnSecondary.withOpacity(_chargeAmount ? 1 : 0.5),
                                    padding: const EdgeInsets.symmetric(vertical: xSize / 6, horizontal: xSize / 2),
                                    textStyle: xTheme.textTheme.labelLarge!.apply(color: xOnPrimary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (_error != null) const SizedBox().vertical(),
                        if (_error != null) xErrorText(context, _error ?? ""),
                        const SizedBox().vertical(),
                        XRoundedButton(
                          onPressed: () {
                            if (fieldsNotFilled()) {
                              _error = "Please fill all the details";
                              setState(() {});
                              return;
                            }
                            context.push(ProfileDisplay(feedMap: currProfileMap,assetsMapWithImageProvider: assetsMapWithImageProvider,));
                          },
                          text: "Preview",
                          outlined: true,
                          expand: true,
                          enabled: !(fieldsNotFilled()),
                        ),
                        const SizedBox().vertical(),
                        XRoundedButton(
                          onPressed: () async {
                            if (fieldsNotFilled()) {
                              _error = "Please fill all the details";
                              setState(() {});
                              return;
                            }
                            setState(() {
                              loaderText = "Please wait while we save your data and do not press back button.";
                            });
                            await saveProfileDetails();
                            context.pop();
                            // setState(() {
                            //   loaderText = null;
                            // });
                          },
                          text: "Save",
                          expand: true,
                          enabled: !fieldsNotFilled(),
                        ),
                      ],
                    ),
                  )),
                ],
              );
            }),
      ),
    );
  }

  bool fieldsNotFilled() =>
      currProfileMap['name'] == null ||
      currProfileMap['type'] == null ||
      currProfileMap['breed'] == null ||
      currProfileMap['color'] == null ||
      currProfileMap['gender'] == null ||
      currProfileMap['birthDate'] == null ||
      currProfileMap['height'] == null ||
      currProfileMap['weight'] == null ||
      currProfileMap['personality'] == null ||
      assetsMapWithImageProvider["icon_0"]["image"] == null ||
      assetsMapWithImageProvider["main_0"]["image"] == null;
}
