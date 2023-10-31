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
///   assetUrls: {  // will be stored as string in isar,
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
  // fields
  String? _name, _type, _colour, _breed, _gender, _birthDate, _personality, _description;
  double? _height, _weight;
  double? _amount;
  bool _chargeAmount = false;
  ImageProvider? _iconImage, _mainImage;
  String? _error;
  Map<String,dynamic> _profileMap = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            XAppBar(AppBarType.backWithHeading,title:"Edit Profile"),
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
                          final image = await xPickCropCompressSaveImage(
                            source: ImageSource.gallery,
                            cropAspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
                            path: getProfileImagesPath(
                              username: "userTemp",
                              type: ProfileImageType.icon,
                            ),
                          );
                          if (image != null) {
                            setState(() {
                              _iconImage = image;
                            });
                          }
                        } catch (e) {
                          xPrint(e.toString());
                        }
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: xSize5 * 3, // thrice of the font size
                            backgroundColor: xSecondary.withOpacity(0.9),
                            backgroundImage: _iconImage,
                            child: (_iconImage == null)
                                ? Icon(
                                    Icons.add,
                                    color: xOnSecondary.withOpacity(0.5),
                                    size: xSize,
                                  )
                                : Center(),
                          ),
                          if (_iconImage != null)
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
                      initialValue: _name,
                      keyboardType: TextInputType.text,
                      onChangedFn: (String? value) {
                        setState(() {
                          _name = value;
                          _error = null;
                        });
                        xPrint("name - $_name");
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
                        _birthDate = value;
                        _error = null;
                      },
                      initialValue: _birthDate,
                    ),
                    const SizedBox().vertical(),
                    // type
                    XDropDownField(
                      hintText: "Type",
                      textInputAction: TextInputAction.next,
                      initialValue: _type,
                      keyboardType: TextInputType.text,
                      list: petsData.keys.toList(),
                      onTap: () {
                        _error = null;
                        setState(() {});
                      },
                      onSelected: (String? value) {
                        _type = value;
                        // resetting the values
                        _breed = null;
                        _colour = null;
                        _gender = null;
                        setState(() {});
                        xPrint("selected type - $value");
                      },
                    ),
                    const SizedBox().vertical(),
                    // breed
                    XDropDownField(
                      hintText: "Breed",
                      textInputAction: TextInputAction.next,
                      initialValue: _breed,
                      keyboardType: TextInputType.text,
                      list: (_type == null) ? [] : petsData[_type].keys.toList(),
                      onTap: () {
                        if (_type == null) {
                          _error = "Please choose the type first";
                          setState(() {});
                        }
                      },
                      onSelected: (String? value) {
                        _breed = value;
                        setState(() {});
                        xPrint("selected breed - $value");
                      },
                    ),
                    const SizedBox().vertical(),
                    // gender
                    XDropDownField(
                      hintText: "Gender",
                      textInputAction: TextInputAction.next,
                      initialValue: _gender,
                      keyboardType: TextInputType.text,
                      list: (_type == null || _breed == null) ? [] : List<String>.from(petsData[_type][_breed]["genders"].toList()),
                      onTap: () {
                        if (_type == null || _breed == null) {
                          _error = "Please choose the type and breed first";
                          setState(() {});
                        }
                      },
                      onSelected: (String? value) {
                        _gender = value;
                        setState(() {});
                        xPrint("selected breed - $value");
                      },
                    ),
                    const SizedBox().vertical(),
                    // color
                    XDropDownField(
                      hintText: "Colour",
                      textInputAction: TextInputAction.next,
                      initialValue: _colour,
                      keyboardType: TextInputType.text,
                      list: (_type == null || _breed == null) ? [] : List<String>.from(petsData[_type][_breed]["colors"].toList()),
                      onTap: () {
                        if (_type == null || _breed == null) {
                          _error = "Please choose the type and breed first";
                        }
                        setState(() {});
                      },
                      onSelected: (String? value) {
                        _colour = value;
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
                            initialValue: _height != null ? _height.toString() : null,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                            onChangedFn: (String? value) {
                              setState(() {
                                _height = (value != null) ? double.parse(value) : null;
                                _error = null;
                              });
                              xPrint("height - $_height");
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
                            initialValue: _weight != null ? _weight.toString() : null,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                            onChangedFn: (String? value) {
                              setState(() {
                                _weight = (value != null) ? double.parse(value) : null;
                                _error = null;
                              });
                              xPrint("weight - $_weight");
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
                      initialValue: _personality,
                      keyboardType: TextInputType.text,
                      autofillHints: (_type == null || _breed == null) ? null : List<String>.from(petsData[_type][_breed]["characteristics"].toList()),
                      onChangedFn: (String? value) {
                        setState(() {
                          _personality = value;
                          _error = null;
                        });
                        xPrint("personality - $_personality");
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
                      initialValue: _description,
                      keyboardType: TextInputType.multiline,
                      onChangedFn: (String? value) {
                        setState(() {
                          _description = value;
                          _error = null;
                        });
                        xPrint("description - $_description");
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
                          final image = await xPickCropCompressSaveImage(
                            source: ImageSource.gallery,
                            cropAspectRatio: const CropAspectRatio(ratioX: 2, ratioY: 3),
                            path: getProfileImagesPath(
                              username: "userTemp",
                              type: ProfileImageType.main,
                            ),
                          );
                          if (image != null) {
                            setState(() {
                              _mainImage = image;
                            });
                          }
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
                                image: (_mainImage != null) ? DecorationImage(image:_mainImage!, fit: BoxFit.cover) : null,
                              ),
                              child: (_mainImage == null)
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
                          if (_mainImage != null)
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
                              initialValue: _amount == null ? null : _amount.toString(),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChangedFn: (String? value) {
                                setState(() {
                                  _amount = (value != null) ? double.parse(value) : null;
                                  _error = null;
                                });
                                xPrint("amount - $_amount");
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
                                  _amount = null;
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
                        if (_name == null ||
                            _type == null ||
                            _breed == null ||
                            _colour == null ||
                            _gender == null ||
                            _birthDate == null ||
                            _height == null ||
                            _weight == null ||
                            _personality == null ||
                            _iconImage == null ||
                            _mainImage == null) {
                          _error = "Please fill all the details";
                          setState(() {});
                          return;
                        }
                        // todo : Add the continue logic here
                      },
                      text: "Preview",
                      expand: true,
                      enabled: !(_name == null ||
                          _type == null ||
                          _breed == null ||
                          _colour == null ||
                          _gender == null ||
                          _birthDate == null ||
                          _height == null ||
                          _weight == null ||
                          _personality == null ||
                          _iconImage == null ||
                          _mainImage == null),
                    ),
                    const SizedBox().vertical(),
                    XRoundedButton(
                      onPressed: () {
                        if (_name == null ||
                            _type == null ||
                            _breed == null ||
                            _colour == null ||
                            _gender == null ||
                            _birthDate == null ||
                            _height == null ||
                            _weight == null ||
                            _personality == null ||
                            _iconImage == null ||
                            _mainImage == null) {
                          _error = "Please fill all the details";
                          setState(() {});
                          return;
                        }
                        // todo : Add the continue logic here
                      },
                      text: "Save",
                      expand: true,
                      enabled: !(_name == null ||
                          _type == null ||
                          _breed == null ||
                          _colour == null ||
                          _gender == null ||
                          _birthDate == null ||
                          _height == null ||
                          _weight == null ||
                          _personality == null ||
                          _iconImage == null ||
                          _mainImage == null),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// MultipleDayPickerScreen(
// onChanged: (list){
// try {
// List<String> tempList = List.from(list.map((e) => e.toddMMyyyy()));
// xPrint("selectedList - $tempList");
// } catch (e) {
// xPrint(e.toString());
// }
// },
// selectedDates: [],
// ),
