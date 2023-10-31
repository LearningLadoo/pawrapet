import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawrapet/screens/login/loginVerify.dart';
import 'package:pawrapet/utils/extensions/buildContext.dart';
import 'package:pawrapet/utils/extensions/string.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/sizedBox.dart';
import '../../utils/widgets/displayText.dart';
import '../../utils/functions/common.dart';
import '../../utils/widgets/appBar.dart';
import '../../utils/widgets/buttons.dart';
import '../../utils/widgets/inputFields.dart';
import '../../utils/widgets/common.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? _email;
  bool _error = false;
  bool sendOtpPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: xSize / 2),
              child: Column(
                children: [
                  const SizedBox().vertical(),
                  const SizedBox().vertical(),
                  xHeaderBanner("Enter Email Address"),
                  // enter email

                  XTextField(
                    hintText: "email address",
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    onChangedFn: (String? value) {
                      setState(() {
                        _email = value!.trim();
                        _error = false;
                      });
                      xPrint(_email);
                    },
                  ),
                  if (_error) const SizedBox().vertical(),
                  if (_error) xErrorText(context, "Please check the email you have entered"),
                  const SizedBox().vertical(),
                  XRoundedButton(
                    onPressed: () async {
                      if (!(_email != null && emailRegEx.hasMatch(_email!))) {
                        _error = true;
                        setState(() {});
                        return;
                      }
                      xPrint("pressed");


                    },
                    text: "Send OTP",
                    expand: true,
                    enabled: (_email != null && emailRegEx.hasMatch(_email!)),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(height: xSize * 2.5, child: Image.asset("assets/images/element2.png")),
            ),
            XAppBar(AppBarType.backWithHeading, title: "Login"),
          ],
        ),
      ),
    );
  }
}
