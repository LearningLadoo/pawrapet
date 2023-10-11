import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawrapet/screens/login/utils/functions.dart';
import 'package:pawrapet/screens/login/utils/widgets.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import '../../utils/widgets/displayText.dart';
import 'package:pawrapet/utils/functions/common.dart';
import 'package:pawrapet/utils/widgets/appBar.dart';
import 'package:pawrapet/utils/widgets/buttons.dart';
import 'package:pawrapet/utils/widgets/inputFields.dart';

import '../../utils/widgets/common.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? _phone;
  bool _error = false;

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
                xHeaderBanner("Enter Phone Number"),
                // enter number
                Row(
                  children: [
                    SizedBox(
                      width: xSize * 2,
                      child: XTextField(
                        hintText: "Code",
                        initialValue: "+91",
                        enabled: false,
                        onChangedFn: (v){},
                      ),
                    ),
                    const SizedBox().horizontal(),
                    Expanded(
                      child: XTextField(
                        hintText: "10 digit Number",
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        onChangedFn: (String? value) {
                          setState(() {
                            _phone = value;
                            _error = false;
                          });
                          xPrint(_phone);
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    )
                  ],
                ),
                if (_error) const SizedBox().vertical(),
                if (_error) xErrorText(context, "Please check the number you have entered"),
                const SizedBox().vertical(),
                XRoundedButton(
                  onPressed: () {
                    if (!(_phone!=null&&_phone!.length==10)) {
                      _error = true;
                      setState(() {});
                      return;
                    }
                    // todo : Add the login logic here
                  },
                  text: "Send OTP",
                  expand: true,
                  enabled: (_phone!=null&&_phone!.length==10),
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
      )),
    );
  }
}
