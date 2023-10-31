import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pawrapet/firebase/functions.dart';
import 'package:pawrapet/providers/otpProvider.dart';
import 'package:provider/provider.dart';

import '../utils/functions/common.dart';

enum AuthState { loggedOut, loggedIn }

class AuthProvider with ChangeNotifier {
  AuthState _authState = AuthState.loggedOut;
  User? _firebaseUser;

  // String? email;
  // String? _uid;
  // String? _loginOtpId;
  // String? otp;
  Map preLoginMap = {}; // {email,UID,OTPid,OTP}
  bool _isNewUser = false;

  AuthState get authState => _authState;

  User? get firebaseUser => _firebaseUser;

  // String? get uid => _uid;
  bool get isNewUser => _isNewUser;

  AuthProvider() {
    // todo get firebase user here and assign the auth state
  }

  // make sure the email is not null
  void sendLoginOTP(BuildContext context) async {
    // otp provider, it handles timer and handling different flows for otp
    OtpProvider otpProvider = Provider.of<OtpProvider>(context, listen: false);
    // null check for email and if timer is already running
    if (preLoginMap["email"] == null || otpProvider.otpFlow != OtpFlows.ideal) return;
    // failed flag; will be marked false when everything completed without error
    bool failed = true;
    // mark the OTP Flow Stage to sending LOGIN OTP
    otpProvider.setOtpFlow(OtpFlows.sending, notify: true);
    // get the response
    Response? res = await FirebaseCloudFunctions().sendLoginOTP(preLoginMap["email"]);
    // res null check
    if (res != null) {
      xPrint('Response status: ${res.statusCode} body: ${res.body}', header: "AuthProvider/sendLoginOTP");
      // creating map
      Map? resMap = jsonDecode(res.body);
      // status check
      if (resMap != null && resMap["status"] == "success") {
        // change the OTP Flow to otp sent
        otpProvider.setOtpFlow(OtpFlows.sent, notify: true);
        // assign all the variable
        preLoginMap['UID'] = resMap['UID'];
        preLoginMap['OTPid'] = resMap['OTPid'];
        _isNewUser = resMap['isNewUser'];
        failed = false;
        // start the timer
        otpProvider.startOtpTimer(2 * 60, notify: true);
      }
    }
    // if some error then change the OTP Flow to failed
    if (failed) otpProvider.setOtpFlow(OtpFlows.sendingFailed, notify: true);
    // notify everyone about the new preLogin map and isNewUser
    notifyListeners();
  }
}
