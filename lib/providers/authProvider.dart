import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../firebase/firestore.dart';
import '../firebase/functions.dart';
import 'otpProvider.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../utils/constants.dart';
import '../utils/functions/common.dart';

enum AuthState { loggedOut, loggedIn }

class AuthProvider with ChangeNotifier {
  AuthState _authState = AuthState.loggedOut;
  User? _firebaseUser;
  String? _email;
  String? _uid;
  bool? _verified;
  Map preLoginMap = {}; // {email,UID,OTPid,OTP}
  bool _isNewUser = false;

  AuthState get authState => _authState;

  User? get firebaseUser => _firebaseUser;

  bool? get verified => _verified;

  String? get uid => _uid;

  String? get email => _email;

  bool get isNewUser => _isNewUser;

  // initialise the auth
  Future<bool> initializeAuth(BuildContext context) async {
    xPrint("called", header: "authProvider/initializeAuth");
    // try to get the current user
    _firebaseUser = FirebaseAuth.instance.currentUser;
    if (_firebaseUser == null) {
      // offload app data
      resetAuthDetails();
    } else {
      // setup user sharedPrefs
      _authState = AuthState.loggedIn;
      _uid = _firebaseUser!.uid;
      Map? currUserMap = xSharedPrefs.currentUserMap;
      // handle if the user is not same
      if (currUserMap != null && currUserMap["UID"] != _uid) {
        currUserMap = null; // inorder to fetch from cloud
        await xSharedPrefs.removeCurrUser();
      }
      // get from cloud if map is null
      if (currUserMap == null) {
        Map? tempMap = await FirebaseCloudFirestore().getUserDetailsFromUID(_uid!);
        if (tempMap != null && tempMap["email"] != null) {
          currUserMap = {
            "email": tempMap["email"],
            "UID": _uid,
            "username": tempMap["username"],
            "verified": tempMap["verified"],
            "profiles": tempMap["profiles"],
            "onboardEpoch": tempMap["onboardEpoch"],
          };
          await xSharedPrefs.setCurrUser(jsonEncode(currUserMap));
        }
      }
      // handle null
      if (currUserMap == null) {
        xPrint("unable to get user details, unknown error. logging out.", header: "AuthProvider/initializeAuth");
        await logout(context);
        return false;
      }
      // assign values
      _email = currUserMap['email'];
      _verified = currUserMap['verified'];
      // once both the user is logged in and sharedPrefs are initialized, generate the FCM token
      await xFirebaseMessaging.manageToken();
    }
    return true;
  }

  // make sure the email is not null
  void sendLoginOTPAndStartTimer(BuildContext context) async {
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
      if (res.statusCode == 200 && resMap != null && resMap["status"] == "success") {
        // start the timer
        otpProvider.startOtpTimer(1 * 60, notify: true);
        // assign all the variable
        preLoginMap['UID'] = resMap['UID'];
        preLoginMap['OTPid'] = resMap['OTPid'];
        _isNewUser = resMap['isNewUser'];
        failed = false;
        // change the OTP Flow to otp sent
        otpProvider.setOtpFlow(OtpFlows.sent, notify: true);
      }
    }
    // if some error then change the OTP Flow to failed
    if (failed) otpProvider.setOtpFlow(OtpFlows.sendingFailed, notify: true);
    // notify everyone about the new preLogin map and isNewUser
    notifyListeners();
  }

  // make sure email, UID, OTP, OTPid are not null
  void verifyLoginOTPAndSignIn(BuildContext context) async {
    // otp provider, it handles timer and handling different flows for otp
    OtpProvider otpProvider = Provider.of<OtpProvider>(context, listen: false);
    // null check for email, UID, OTP, OTPid
    if (preLoginMap["email"] == null || preLoginMap["UID"] == null || preLoginMap["OTP"] == null || preLoginMap["OTPid"] == null) return;
    // failed flag; will be marked false when everything completed without error
    bool failed = true;
    // mark the OTP Flow Stage to sending LOGIN OTP
    otpProvider.setOtpFlow(OtpFlows.verifying, notify: true);
    // get the response
    Response? res = await FirebaseCloudFunctions().verifyLoginOTP(preLoginMap["email"], preLoginMap["UID"], preLoginMap["OTP"], preLoginMap["OTPid"]);

    // res null check
    if (res != null) {
      // creating map
      Map? resMap = jsonDecode(res.body);
      // status check
      if (res.statusCode == 200 && resMap != null && resMap["status"] == "success") {
        // assign the variables
        preLoginMap['authToken'] = resMap['authToken'];
        failed = false;
        // sign in the user with auth token
        await FirebaseAuth.instance.signInWithCustomToken(
          preLoginMap['authToken'],
        );
        // initialize
        await initializeAuth(context);
        // change the OTP Flow to otp sent
        otpProvider.setOtpFlow(OtpFlows.verified, notify: true);
      } else {
        xPrint("error ${resMap!['error']}");
      }
    }
    // if some error then change the OTP Flow to failed
    if (failed) otpProvider.setOtpFlow(OtpFlows.verifyingFailed, notify: true);
    // notify everyone
    notifyListeners();
  }

  // log out
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await Future.delayed(Duration(seconds: 1));
    await offloadAppData();
    RestartWidget.restartApp(context);
  }

  // reset auth provider details
  void resetAuthDetails() {
    _authState = AuthState.loggedOut;
    _uid = null;
    _email = null;
    _verified = false;
  }
  Future<bool> offloadAppData() async{
    resetAuthDetails();
    await xSharedPrefs.clear();
    await xIsarManager.clearAll();
    return true;
  }
}
