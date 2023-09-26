import 'package:flutter/material.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/functions/common.dart';
import 'package:pawrapet/utils/widgets/appBar.dart';
import 'package:pawrapet/utils/widgets/buttons.dart';
import 'package:pawrapet/utils/widgets/inputFields.dart';

class ProfileQuick extends StatefulWidget {
  const ProfileQuick({Key? key}) : super(key: key);

  @override
  State<ProfileQuick> createState() => _ProfileQuickState();
}

class _ProfileQuickState extends State<ProfileQuick> {
  String? _name, _type, _colour, _breed, _gender;

  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          // height: xHeight,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                child: SizedBox(height: xSize * 2.5, child: Image.asset("assets/images/element2.png")),
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  height: xHeight+ MediaQuery.of(context).viewInsets.bottom-xSize,
                  padding: const EdgeInsets.symmetric(horizontal: xSize / 2),
                  child: Column(
                    children: [
                      const SizedBox().vertical(),
                      const SizedBox().vertical(),
                      SizedBox(
                        width: xWidth,
                        child: Stack(
                          children: [
                            Positioned(
                                right: -xSize / 4,
                                bottom: xSize / 2,
                                child: Image.asset(
                                  "assets/images/element4.png",
                                  height: xSize * 4,
                                )),
                            SizedBox(
                                width: xWidth * 0.8,
                                height: xSize * 6,
                                child: Center(
                                    child: Text(
                                  "Tell us more about your furry friend",
                                  style: xTheme.textTheme.headlineLarge,
                                ))),
                          ],
                        ),
                      ),
                      XTextField(
                        hintText: "Name",
                        textInputAction: TextInputAction.next,
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
                      XDropDownField(
                        hintText: "Type",
                        textInputAction: TextInputAction.next,
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
                      XDropDownField(
                        hintText: "Breed",
                        textInputAction: TextInputAction.next,
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
                      XDropDownField(
                        hintText: "Gender",
                        textInputAction: TextInputAction.next,
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
                      XDropDownField(
                        hintText: "Colour",
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        list: (_type == null || _breed == null) ? [] : List<String>.from(petsData[_type][_breed]["colors"].toList()),
                        onTap: () {
                          if (_type == null || _breed == null) {
                            _error = "Please choose the type and breed first";
                            setState(() {});
                          }
                        },
                        onSelected: (String? value) {
                          _colour = value;
                          setState(() {});
                          xPrint("selected breed - $value");
                        },
                      ),
                      if (_error != null) const SizedBox().vertical(),
                      if (_error != null) xErrorText(context, _error ?? ""),
                      const SizedBox().vertical(),
                      const SizedBox().vertical(),
                      XRoundedButton(
                        onPressed: () {
                          if (_name == null || _type == null || _breed == null || _colour == null || _gender == null) {
                            _error = "Please fill all the details";
                            setState(() {});
                            return;
                          }
                          // todo : Add the continue logic here
                        },
                        text: "Continue",
                        expand: true,
                        enabled: !(_name == null || _type == null || _breed == null || _colour == null || _gender == null),
                      ),
                    ],
                  ),
                ),
              ),
              xAppBar(AppBarType.backWithHeading, context, text: "Quick Info"),
            ],
          ),
        ),
      ),
    );
  }
}
