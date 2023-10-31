import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawrapet/providers/authProvider.dart';
import 'package:pawrapet/providers/otpProvider.dart';
import 'package:pawrapet/screens/login/loginVerify.dart';
import 'package:pawrapet/utils/extensions/buildContext.dart';
import 'package:pawrapet/utils/extensions/string.dart';
import 'package:provider/provider.dart';
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
  String? _error;
  bool sendOtpPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<OtpProvider>(
                builder: (context, otpProvider, child) {
                  // redirect to next page
                  if(otpProvider.otpFlow==OtpFlows.sent) context.push(LoginVerify());
                  // handling error
                  if(otpProvider.otpFlow==OtpFlows.sendingFailed) {
                    _error = "Unable to send OTP, please try again later";
                  }
                  return Padding(
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
                              _error = null;
                            });
                            xPrint(_email);
                          },
                        ),
                        if (_error!=null) const SizedBox().vertical(),
                        if (_error!=null) xErrorText(context, _error!),
                        const SizedBox().vertical(),
                        XRoundedButton(
                          onPressed: () async {
                            if (!(_email != null && emailRegEx.hasMatch(_email!))) {
                              _error = "Please check the email you have entered";
                              setState(() {});
                              return;
                            }
                            if(otpProvider.otpFlow != OtpFlows.ideal){
                              return;
                            }
                            xPrint("pressed", header: "login");
                            // instance
                            AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
                            // assigning the destination email address
                            authProvider.preLoginMap = {'email':_email};
                            // sending the OTP and starting timer
                            authProvider.sendLoginOTPAndStartTimer(context);
                          },
                          text: (otpProvider.otpFlow==OtpFlows.sending)?"Sending OTP...":"Send OTP",
                          expand: true,
                          enabled: (_email != null && emailRegEx.hasMatch(_email!) && otpProvider.otpFlow==OtpFlows.ideal),
                        ),
                        const SizedBox().vertical(),
                        Text("Resend code after ${otpProvider.resendOtpTimer} seconds",style: xTheme.textTheme.bodySmall),
                      ],
                    ),
                  );
                }
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(height: xSize * 2.5, child: Image.asset("assets/images/element2.png")),
            ),
            XAppBar(AppBarType.backWithHeading, title: "Login"),
          ],
        )
      ),
    );
  }
}
