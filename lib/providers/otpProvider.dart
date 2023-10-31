import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawrapet/firebase/functions.dart';
import '../utils/functions/common.dart';

enum OtpFlows { ideal, sending, sendingFailed, sent, verifying, verifyingFailed, verified }

class OtpProvider with ChangeNotifier {
  OtpFlows otpFlow = OtpFlows.ideal;
  // String? email;
  // String? _uid;
  // String? _authToken;
  // int? _otpID;
  // int? otp;
  int _resendOtpTimer = 0;
  // bool _isNewUser = false;
  // Map? _loginOtpSendMap;
  // Map? _loginOtpVerifyMap;

  // OtpFlows get otpFlowChanges => _otpFlow;
  // String? get uid => _uid;
  // String? get authToken => _authToken;
  // int? get otpID => _otpID;
  int? get resendOtpTimer => _resendOtpTimer;
  // bool get isNewUser => _isNewUser;
  // Map? get loginOtpSendMap => _loginOtpSendMap;
  // Map? get loginOtpVerifyMap => _loginOtpVerifyMap;

  void setOtpFlow(OtpFlows flow, {bool notify = false}) {
    otpFlow = flow;
    if(notify)notifyListeners();
  }
  // start the otp timer
  void startOtpTimer(int maxSeconds, {bool notify = false}) async {
    for (int i = 0; i <= maxSeconds; i++) {
      await Future.delayed(const Duration(seconds: 1));
      _resendOtpTimer = maxSeconds - i;
      if (notify) notifyListeners();
    }
  }

  // send Login OTP
  // Future<Map?> sendLoginOTP(String? email) async {
  //   // null check for email and if timer is already running
  //   if (_resendOtpTimer != 0 || email==null) return null;
  //   // failed flag; will be marked false when everything completed without error
  //   bool failed = true;
  //   // map
  //   Map? loginOtpSendMap;
  //   // mark the OTP Flow Stage
  //   otpFlow = OtpFlows.sendingLoginOTP;
  //   // call the http request to send the OTP
  //   http.Response? response = await FirebaseCloudFunctions().sendLoginOTP(email!);
  //   // get the data from res
  //   if(response!=null) {
  //     xPrint('Response status: ${response.statusCode} body: ${response.body}', header: "OtpProvider/sendLoginOTP");
  //     // creating map
  //      loginOtpSendMap = jsonDecode(response.body);
  //     // status check
  //     if (response.statusCode == 200 && loginOtpSendMap!=null && loginOtpSendMap["status"] == "success") {
  //       // assign variables
  //       otpFlow = OtpFlows.sentLoginOTP;
  //       // _uid = _loginOtpSendMap!["UID"];
  //       // _otpID = _loginOtpSendMap!["OTPid"];
  //       // _isNewUser = _loginOtpSendMap!["isNewUser"];
  //       failed = false;
  //       // start timer for 2 minutes
  //       _startOtpTimer(2*60, notify: true);
  //     }
  //   }
  //   // handle failure
  //   if(failed)otpFlow = OtpFlows.sendingLoginOTPFailed;
  //   // notify everyone
  //   notifyListeners();
  //   return loginOtpSendMap;
  // }
}
