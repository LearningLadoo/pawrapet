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
import '../../utils/widgets/displayText.dart';
import '../../utils/widgets/datePicker.dart';
import 'utils/functions.dart';

///
/// Profile structure {
///   username: <String>,
///   name: <String>,
///   type: <String>,
///   colour: <String>,
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

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _chargeAmount = false;
  String? _error;
  late Map profileMap;
  late Map assetsMapWithImageProvider; // with image provider
  @override
  void initState() {
    // todo fetch the details jo pehle se hai
    profileMap = getDefaultProfileMap();
    initializeAssetsMap();
    super.initState();
  }

  void initializeAssetsMap() {
    assetsMapWithImageProvider = profileMap['assets'];
    assetsMapWithImageProvider.keys.map((i) {
      // todo create image provider if url is not null and handle other things if its already present
      String type = i.split('_')[0];
      String index = i.split('_')[1];
      assetsMapWithImageProvider[i]["path"] = getProfileImagesPath(
        profileNo: 1,
        type: type,
        index: int.parse(index),
        ext: assetsMapWithImageProvider[i]["ext"],
      );
      assetsMapWithImageProvider[i]["image"] = null;
      assetsMapWithImageProvider[i]["isNew"] = true;
    });
  }

  void handleAddImages(String key, ImageProvider? image) {
    if (image != null) {
      assetsMapWithImageProvider[key]["image"] = image;
      assetsMapWithImageProvider[key]["isNew"] = true;
      profileMap["assets"][key]["url"] = "add"; // command to add details to cloud
      xPrint("asset with image map - ${assetsMapWithImageProvider} and profile asset map - ${profileMap["assets"]}", header: "Profile/handleAddImages");
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            XAppBar(AppBarType.backWithHeading, title: "Edit Profile"),
            Expanded(
              child: FutureBuilder(
                  future: Future.delayed(Duration(seconds: 3)),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.done && snap.hasData) {
                      return SingleChildScrollView(
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
                              initialValue: profileMap['name'],
                              keyboardType: TextInputType.text,
                              onChangedFn: (String? value) {
                                setState(() {
                                  profileMap['name'] = value;
                                  _error = null;
                                });
                                xPrint("name - $profileMap['name']");
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
                                profileMap['birthDate'] = value;
                                _error = null;
                              },
                              initialValue: profileMap['birthDate'],
                            ),
                            const SizedBox().vertical(),
                            // type
                            XDropDownField(
                              hintText: "Type",
                              textInputAction: TextInputAction.next,
                              initialValue: profileMap['type'],
                              keyboardType: TextInputType.text,
                              list: petsData.keys.toList(),
                              onTap: () {
                                _error = null;
                                setState(() {});
                              },
                              onSelected: (String? value) {
                                profileMap['type'] = value;
                                // resetting the values
                                profileMap['breed'] = null;
                                profileMap['colour'] = null;
                                profileMap['gender'] = null;
                                setState(() {});
                                xPrint("selected type - $value");
                              },
                            ),
                            const SizedBox().vertical(),
                            // breed
                            XDropDownField(
                              hintText: "Breed",
                              textInputAction: TextInputAction.next,
                              initialValue: profileMap['breed'],
                              keyboardType: TextInputType.text,
                              list: (profileMap['type'] == null) ? [] : petsData[profileMap['type']].keys.toList(),
                              onTap: () {
                                if (profileMap['type'] == null) {
                                  _error = "Please choose the type first";
                                  setState(() {});
                                }
                              },
                              onSelected: (String? value) {
                                profileMap['breed'] = value;
                                setState(() {});
                                xPrint("selected breed - $value");
                              },
                            ),
                            const SizedBox().vertical(),
                            // gender
                            XDropDownField(
                              hintText: "Gender",
                              textInputAction: TextInputAction.next,
                              initialValue: profileMap['gender'],
                              keyboardType: TextInputType.text,
                              list: (profileMap['type'] == null || profileMap['breed'] == null) ? [] : List<String>.from(petsData[profileMap['type']][profileMap['breed']]["genders"].toList()),
                              onTap: () {
                                if (profileMap['type'] == null || profileMap['breed'] == null) {
                                  _error = "Please choose the type and breed first";
                                  setState(() {});
                                }
                              },
                              onSelected: (String? value) {
                                profileMap['gender'] = value;
                                setState(() {});
                                xPrint("selected breed - $value");
                              },
                            ),
                            const SizedBox().vertical(),
                            // color
                            XDropDownField(
                              hintText: "Colour",
                              textInputAction: TextInputAction.next,
                              initialValue: profileMap['colour'],
                              keyboardType: TextInputType.text,
                              list: (profileMap['type'] == null || profileMap['breed'] == null) ? [] : List<String>.from(petsData[profileMap['type']][profileMap['breed']]["colors"].toList()),
                              onTap: () {
                                if (profileMap['type'] == null || profileMap['breed'] == null) {
                                  _error = "Please choose the type and breed first";
                                }
                                setState(() {});
                              },
                              onSelected: (String? value) {
                                profileMap['colour'] = value;
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
                                    initialValue: profileMap['height'] != null ? profileMap['height'].toString() : null,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                                    onChangedFn: (String? value) {
                                      setState(() {
                                        profileMap['height'] = (value != null) ? double.parse(value) : null;
                                        _error = null;
                                      });
                                      xPrint("height - $profileMap['height']");
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
                                    initialValue: profileMap['weight'] != null ? profileMap['weight'].toString() : null,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                                    onChangedFn: (String? value) {
                                      setState(() {
                                        profileMap['weight'] = (value != null) ? double.parse(value) : null;
                                        _error = null;
                                      });
                                      xPrint("weight - $profileMap['weight']");
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
                              initialValue: profileMap['personality'],
                              keyboardType: TextInputType.text,
                              autofillHints:
                                  (profileMap['type'] == null || profileMap['breed'] == null) ? null : List<String>.from(petsData[profileMap['type']][profileMap['breed']]["characteristics"].toList()),
                              onChangedFn: (String? value) {
                                setState(() {
                                  profileMap['personality'] = value;
                                  _error = null;
                                });
                                xPrint("personality - $profileMap['personality']");
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
                              initialValue: profileMap['description'],
                              keyboardType: TextInputType.multiline,
                              onChangedFn: (String? value) {
                                setState(() {
                                  profileMap['description'] = value;
                                  _error = null;
                                });
                                xPrint("description - $profileMap['description']");
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
                                        image:
                                            (assetsMapWithImageProvider["main_0"]["image"] != null) ? DecorationImage(image: assetsMapWithImageProvider["main_0"]["image"]!, fit: BoxFit.cover) : null,
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
                                      initialValue: profileMap['amount'] == null ? null : profileMap['amount'].toString(),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      onChangedFn: (String? value) {
                                        setState(() {
                                          profileMap['amount'] = (value != null) ? double.parse(value) : null;
                                          _error = null;
                                        });
                                        xPrint("amount - $profileMap['amount']");
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
                                          profileMap['amount'] = null;
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
                                // todo : Add the continue logic here
                              },
                              text: "Preview",
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
                                await saveProfileDetails(profileMap);
                              },
                              text: "Save",
                              expand: true,
                              enabled: !fieldsNotFilled(),
                            ),
                          ],
                        ),
                      );
                    }
                    return waitingDogLottie();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  bool fieldsNotFilled() =>
      profileMap['name'] == null ||
      profileMap['type'] == null ||
      profileMap['breed'] == null ||
      profileMap['colour'] == null ||
      profileMap['gender'] == null ||
      profileMap['birthDate'] == null ||
      profileMap['height'] == null ||
      profileMap['weight'] == null ||
      profileMap['personality'] == null ||
      assetsMapWithImageProvider["icon_0"]["image"] == null ||
      assetsMapWithImageProvider["main_0"]["image"] == null;
}
