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


  // fetch the order ID and its status
  Future<http.Response?> getSecurityPayOrderIdAndDetails(String uidPN, String frndsUidPN, String sessionID) async {
    try {
      var url = Uri.parse('$mumbaiFnPath/getOrderIdForSecurityPay');
      String bodyString = jsonEncode({'uidPN': uidPN, 'frndsUidPN': frndsUidPN, 'sessionID': sessionID, 'cha': getChas()});
      return await http.post(url, body: bodyString, headers: {'Content-Type': 'application/json'});
    } catch (e) {
      xPrint(e.toString(), header: "getSecurityPayOrderIdAndDetails");
      return null;
    }
  }

  // verify the payment
  Future<http.Response?> verifySecurityPayAndUpdateCloud(String uidPN, String orderId, String sessionID, bool isNew) async {
    try {
      var url = Uri.parse('$mumbaiFnPath/verifyUpdateSecurityPay');
      String bodyString = jsonEncode({'uidPN': uidPN, 'orderId': orderId, 'sessionID': sessionID,'isNew':isNew, 'cha': getChas()});
      return await http.post(url, body: bodyString, headers: {'Content-Type': 'application/json'});
    } catch (e) {
      xPrint(e.toString());
      return null;
    }
  }
}
