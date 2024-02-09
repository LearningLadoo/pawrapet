import 'package:flutter/material.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/functions/common.dart';
import 'package:pawrapet/utils/widgets/appBar.dart';
import 'package:pawrapet/utils/widgets/buttons.dart';
import 'package:pawrapet/utils/widgets/inputFields.dart';

import '../../firebase/firestore.dart';
import '../../firebase/functions.dart';
import '../../isar/profile/profile.dart';
import '../../utils/extensions/buildContext.dart';
import '../../utils/widgets/common.dart';
import '../../utils/widgets/displayText.dart';
import '../home/home.dart';
import 'utils/functions.dart';

class ProfileQuick extends StatefulWidget {
  ProfileQuick({Key? key}) : super(key: key);

  @override
  State<ProfileQuick> createState() => _ProfileQuickState();
}

class _ProfileQuickState extends State<ProfileQuick> {
  String? _error;
  late Map<String, dynamic> profileMap;
  bool showLoader = false;

  @override
  void initState() {
    profileMap = getDefaultProfileMap();
    super.initState();
  }

  void handleSaving() async {
    showLoader = true;
    setState(() {});
    // the pn
    int pn = xSharedPrefs.createNewActiveProfileNumber();
    String uid = xSharedPrefs.uid!;
    String uidPN = '${uid}_$pn';
    String username = xSharedPrefs.username!;
    xPrint("pn $pn, username $username, uid $uid, uidPN $uidPN", header: "handleSaving/profileQuick");
    // do the setup in cloud
    await FirebaseCloudFunctions().setupNewProfile(username, uid, pn);
    List<Future> futures = [];
    // update the profile details in firestore
    futures.add(FirebaseCloudFirestore().updateProfile(uidPN, profileMap));
    // add profile in isar as well
    futures.add(xProfileIsarManager.setProfile(Profile(
      profileNumber: pn,
      uidPN: uidPN,
      username: username,
      name: profileMap["name"],
    )));
    // setup the profile
    futures.add(xSharedPrefs.setupTheNewProfileNumber(pn));
    // await
    await Future.wait(futures);
    // navigate to home
    context.push(const Home());
  }

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
              showLoader
                  ? Center(child: dogWaitLoader("Checking your profiles."))
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        height: xHeight + MediaQuery.of(context).viewInsets.bottom - xSize,
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
                            XDropDownField(
                              hintText: "Breed",
                              textInputAction: TextInputAction.next,
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
                            XDropDownField(
                              hintText: "Gender",
                              textInputAction: TextInputAction.next,
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
                            XDropDownField(
                              hintText: "Colour",
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              list: (profileMap['type'] == null || profileMap['breed'] == null) ? [] : List<String>.from(petsData[profileMap['type']][profileMap['breed']]["colors"].toList()),
                              onTap: () {
                                if (profileMap['type'] == null || profileMap['breed'] == null) {
                                  _error = "Please choose the type and breed first";
                                  setState(() {});
                                }
                              },
                              onSelected: (String? value) {
                                profileMap['colour'] = value;
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
                                if (profileMap['name'] == null || profileMap['type'] == null || profileMap['breed'] == null || profileMap['colour'] == null || profileMap['gender'] == null) {
                                  _error = "Please fill all the details";
                                  setState(() {});
                                  return;
                                }
                                handleSaving();
                              },
                              text: "Continue",
                              expand: true,
                              enabled: !(profileMap['name'] == null || profileMap['type'] == null || profileMap['breed'] == null || profileMap['colour'] == null || profileMap['gender'] == null),
                            ),
                          ],
                        ),
                      ),
                    ),
              XAppBar(AppBarType.heading, title: "Quick Info"),
            ],
          ),
        ),
      ),
    );
  }
}
