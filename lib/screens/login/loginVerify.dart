
import 'package:flutter/material.dart';
import '../../main.dart';
import '../../providers/otpProvider.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/buildContext.dart';
import '../../utils/extensions/sizedBox.dart';
import '../../utils/functions/common.dart';
import '../../utils/widgets/appBar.dart';
import '../../utils/widgets/buttons.dart';
import '../../utils/widgets/inputFields.dart';
import 'package:provider/provider.dart';

import '../../providers/authProvider.dart';
import '../../utils/widgets/common.dart';
import '../../utils/widgets/displayText.dart';

class LoginVerify extends StatefulWidget {
  LoginVerify({Key? key}) : super(key: key);

  @override
  State<LoginVerify> createState() => _LoginVerifyState();
}

class _LoginVerifyState extends State<LoginVerify> {
  int? code1, code2, code3, code4;
  String? _error;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OtpProvider otpProvider = Provider.of<OtpProvider>(context, listen: true);
    // // so that it can go back
    // if(otpProvider.otpFlow==OtpFlows.sent) otpProvider.setOtpFlow(OtpFlows.ideal);
    // starting the app from start if verified
    if (otpProvider.otpFlow == OtpFlows.verified) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        RestartWidget.restartApp(context);
      });
    }
    // showing error if the verification failed
    if (otpProvider.otpFlow == OtpFlows.verifyingFailed) {
      _error = "sorry unable to verify OTP";
      setState(() {});
    }
    return WillPopScope(
      onWillPop: () async {
        // make the sendOTP ideal
        otpProvider.setOtpFlow(OtpFlows.ideal);
        context.pop();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(height: xSize * 2.5, child: Image.asset("assets/images/element2.png")),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: xSize / 2),
              child: Column(
                children: [
                  const SizedBox().vertical(),
                  const SizedBox().vertical(),
                  xHeaderBanner("Enter OTP to Verify"),
                  // enter number
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      XOtpTextField(
                        height: xSize * 2,
                        width: xSize * 2,
                        onChanged: (v) {
                          if (v.length == 1) {
                            setState(() {
                              code1 = int.parse(v);
                              _error = null;
                            });
                            FocusScope.of(context).nextFocus();
                          } else {
                            setState(() {
                              code1 = null;
                            });
                          }
                        },
                      ),
                      SizedBox().horizontal(),
                      XOtpTextField(
                        height: xSize * 2,
                        width: xSize * 2,
                        onChanged: (v) {
                          if (v.length == 1) {
                            setState(() {
                              code2 = int.parse(v);
                              _error = null;
                            });
                            FocusScope.of(context).nextFocus();
                          } else {
                            setState(() {
                              code2 = null;
                            });
                          }
                        },
                      ),
                      SizedBox().horizontal(),
                      XOtpTextField(
                        height: xSize * 2,
                        width: xSize * 2,
                        onChanged: (v) {
                          if (v.length == 1) {
                            setState(() {
                              code3 = int.parse(v);
                              _error = null;
                            });
                            FocusScope.of(context).nextFocus();
                          } else {
                            setState(() {
                              code3 = null;
                            });
                          }
                        },
                      ),
                      SizedBox().horizontal(),
                      XOtpTextField(
                        height: xSize * 2,
                        width: xSize * 2,
                        onChanged: (v) {
                          if (v.length == 1) {
                            setState(() {
                              code4 = int.parse(v);
                              _error = null;
                            });
                          } else {
                            setState(() {
                              code4 = null;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox().vertical(),
                  InkWell(
                    onTap: () {
                      if (otpProvider.resendOtpTimer == 0) {
                        // make the sendOTP ideal
                        otpProvider.setOtpFlow(OtpFlows.ideal, notify: true);
                        context.pop();
                      }
                    },
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: xSize1,
                      children: [
                        Text("Haven't received?", style: xTheme.textTheme.bodySmall!.apply(color: xPrimary.withOpacity(0.8), fontSizeDelta: -1)),
                        (otpProvider.resendOtpTimer != 0)
                            ? Text("Resend code after ${otpProvider.resendOtpTimer} seconds", style: xTheme.textTheme.bodySmall!.apply(color: xPrimary.withOpacity(0.6), fontSizeDelta: -1))
                            : Text("Resend code", style: xTheme.textTheme.bodySmall!.apply(color: xPrimary.withOpacity(0.8), fontSizeDelta: -1)),
                      ],
                    ),
                  ),
                  const SizedBox().vertical(),
                  XRoundedButton(
                    onPressed: () async {
                      if (code1 == null || code2 == null || code3 == null || code4 == null) {
                        _error = "Please fill all the fields";
                        setState(() {});
                        return;
                      }
                      if (otpProvider.otpFlow == OtpFlows.verifying) {
                        return;
                      }
                      xPrint("pressed", header: "login");
                      // instance
                      AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
                      // add the OTP
                      authProvider.preLoginMap["OTP"] = int.parse('$code1$code2$code3$code4');
                      // verifying the OTP and signing in
                      authProvider.verifyLoginOTPAndSignIn(context);
                    },
                    text: (otpProvider.otpFlow == OtpFlows.verifying) ? "Verifying . . ." : "Verify",
                    expand: true,
                    enabled: !(code1 == null || code2 == null || code3 == null || code4 == null) && otpProvider.otpFlow != OtpFlows.verifying,
                  ),
                  if (_error != null) const SizedBox().vertical(),
                  if (_error != null) xErrorText(context, _error!),
                ],
              ),
            ),
            XAppBar(
              AppBarType.backWithHeading,
              title: "Verification",
              onTapBack: () {
                // make the sendOTP ideal
                otpProvider.setOtpFlow(OtpFlows.ideal);
                context.pop();
              },
            ),
          ],
        )),
      ),
    );
  }

// void startVerificationTimer(int maxSeconds) async {
//   xPrint("timer started $maxSeconds");
//   for (int i = 0; i <= maxSeconds; i++) {
//     await Future.delayed(Duration(seconds: 1));
//     xPrint("timer started - $i");
//     timerCount = maxSeconds - i;
//     try {
//       setState(() {});
//     } catch (e) {
//       xPrint(e.toString());
//     }
//   }
// }
}
