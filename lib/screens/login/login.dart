import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../providers/authProvider.dart';
import '../../providers/otpProvider.dart';
import 'loginVerify.dart';
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
  bool redirectedToVerify = false;

  @override
  void initState() {
    xPrint("initState", header: "login");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    OtpProvider otpProvider = Provider.of<OtpProvider>(context, listen: true);
    // resetting after coming back from verifying page
    if (otpProvider.otpFlow == OtpFlows.ideal && redirectedToVerify) {
      redirectedToVerify = false;
    }
      // redirect to next page
    if (otpProvider.otpFlow == OtpFlows.sent && !redirectedToVerify) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginVerify()));
      });
      redirectedToVerify = true;
    }
    // handling error
    if (otpProvider.otpFlow == OtpFlows.sendingFailed) {
      _error = "Unable to send OTP, please try again later";
      setState(() {});
    }
    return Scaffold(
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
                xHeaderBanner("Enter Email Address"),
                // enter email
                XTextField(
                  hintText: "email address",
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  onChangedFn: (String? value) {
                    setState(() {
                      _email = value?.trim().toLowerCase();
                      _error = null;
                    });
                    xPrint(_email);
                  },
                ),
                if (_error != null) const SizedBox().vertical(),
                if (_error != null) xErrorText(context, _error!),
                const SizedBox().vertical(),
                XRoundedButton(
                  onPressed: () async {
                    if (!(_email != null && EmailValidator.validate(_email!) && !_email!.contains("+"))) {
                      _error = "Please check the email you have entered";
                      setState(() {});
                      return;
                    }
                    if (otpProvider.otpFlow != OtpFlows.ideal || otpProvider.resendOtpTimer != 0) {
                      return;
                    }
                    xPrint("pressed", header: "login");
                    // instance
                    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
                    // assigning the destination email address
                    authProvider.preLoginMap = {'email': _email};
                    // sending the OTP and starting timer
                    authProvider.sendLoginOTPAndStartTimer(context);
                  },
                  text: (otpProvider.otpFlow == OtpFlows.sending) ? "Sending OTP . . ." : "Send OTP",
                  expand: true,
                  enabled: (_email != null && EmailValidator.validate(_email!) && !_email!.contains("+") && otpProvider.otpFlow == OtpFlows.ideal && otpProvider.resendOtpTimer == 0),
                ),
                const SizedBox().vertical(),
                // Text("${otpProvider.otpFlow} ${otpProvider.resendOtpTimer}"),
                if(otpProvider.resendOtpTimer!=0)Text("Resend code after ${otpProvider.resendOtpTimer} seconds", style: xTheme.textTheme.bodySmall!.apply(color: xPrimary.withOpacity(0.6), fontSizeDelta: -1)),
              ],
            ),
          ),
          XAppBar(AppBarType.backWithHeading, title: "Login"),
        ],
      )),
    );
  }
}
