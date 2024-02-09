import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/functions/idsChasKeys.dart';
import '../utils/functions/common.dart';

class FirebaseCloudFunctions {
  String mumbaiFnPath = 'https://asia-south1-pawrapets.cloudfunctions.net';

  // send login OTP
  Future<http.Response?> sendLoginOTP(String email) async {
    try {
      var url = Uri.parse('$mumbaiFnPath/sendLoginOTP');
      return await http.post(url, body: {'email': email, 'cha': getChas(), ...xSharedPrefs.deviceInfoMap!});
    } catch (e) {
      xPrint(e.toString());
      return null;
    }
  }

  // verify login OTP
  Future<http.Response?> verifyLoginOTP(String email, String uid, int otp, int otpId) async {
    try {
      var url = Uri.parse('$mumbaiFnPath/verifyLoginOTP');
      String bodyString = jsonEncode({'otp': otp, 'otpId': otpId, 'UID': uid, 'email': email, 'cha': getChas(), ...xSharedPrefs.deviceInfoMap!});
      return await http.post(url, body: bodyString, headers: {'Content-Type': 'application/json'});
    } catch (e) {
      xPrint(e.toString());
      return null;
    }
  }

  // verify login OTP
  Future<http.Response?> setupNewProfile(String username, String uid, int pn) async {
    try {
      var url = Uri.parse('$mumbaiFnPath/setupNewProfile');
      String bodyString = jsonEncode({'username': username, 'pn': pn, 'UID': uid, 'cha': getChas()});
      return await http.post(url, body: bodyString, headers: {'Content-Type': 'application/json'});
    } catch (e) {
      xPrint(e.toString());
      return null;
    }
  }
  // test messaging from server
  Future<http.Response?> sendTestNotification() async {
    await Future.delayed(Duration(seconds: 5));
    try {
      var url = Uri.parse('$mumbaiFnPath/testFirebaseMessage');
      return await http.post(url, headers: {'Content-Type': 'application/json'});
    } catch (e) {
      xPrint(e.toString());
      return null;
    }
  }
}
