import 'package:flutter/material.dart';
import 'package:pawrapet/screens/login/utils/functions.dart';
import 'package:pawrapet/screens/login/utils/widgets.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/extensions/string.dart';
import 'package:pawrapet/utils/functions/common.dart';
import 'package:pawrapet/utils/widgets/appBar.dart';
import 'package:pawrapet/utils/widgets/buttons.dart';
import 'package:pawrapet/utils/widgets/inputFields.dart';

import '../../utils/widgets/common.dart';
import '../../utils/widgets/displayText.dart';

class LoginVerify extends StatefulWidget {
  const LoginVerify({Key? key}) : super(key: key);

  @override
  State<LoginVerify> createState() => _LoginVerifyState();
}

class _LoginVerifyState extends State<LoginVerify> {
  int? code1, code2, code3, code4;
  String? _error;
  int timerCount = 0;
  @override
  void initState() {
    startVerificationTimer(10);
    super.initState();
  }
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
                if (_error!=null) const SizedBox().vertical(),
                if (_error!=null) xErrorText(context, _error!),
                const SizedBox().vertical(),
                InkWell(
                  onTap: (){
                    if(timerCount==0){
                      // todo resend the verification code
                    }
                  },
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: xSize1,
                    children: [
                      Text("Haven't received?",style: xTheme.textTheme.bodySmall),
                      (timerCount!=0)?
                      Text("Resend code after $timerCount seconds",style: xTheme.textTheme.bodySmall):
                      Text("Resend code",style: xTheme.textTheme.labelLarge),
                    ],
                  ),
                ),
                const SizedBox().vertical(),
                XRoundedButton(
                  onPressed: () {
                    if (code1==null||code2==null||code3==null||code4==null) {
                      _error = "Please fill all the fields";
                      setState(() {});
                      return;
                    }
                    // todo : Add the verify logic here
                  },
                  text: "Verify",
                  expand: true,
                  enabled: !(code1==null||code2==null||code3==null||code4==null),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(height: xSize * 2.5, child: Image.asset("assets/images/element2.png")),
          ),
          XAppBar(AppBarType.backWithHeading,title: "Verification"),
        ],
      )),
    );
  }
  void startVerificationTimer(int maxSeconds)async {
    xPrint("timer started $maxSeconds");
    for(int i = 0; i<=maxSeconds; i++){
      await Future.delayed(Duration(seconds: 1));
      xPrint("timer started - $i");
      timerCount = maxSeconds - i;
      try {
        setState(() {});
      } catch (e) {
        xPrint(e.toString());
      }
    }
  }
}
