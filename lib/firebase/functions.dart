import 'package:http/http.dart' as http;

import '../utils/functions/common.dart';

class FirebaseCloudFunctions {
  String mumbaiFnPath = 'https://asia-south1-pawrapets.cloudfunctions.net';
  // send login OTP
  Future<http.Response?> sendLoginOTP(String email) async{
    try {
      var url = Uri.parse('$mumbaiFnPath/sendLoginOTP');
      return await http.post(url, body: {'email': email});
    } catch (e) {
      xPrint(e.toString());
      return null;
    }
  }
  // verify login OTP
  Future<http.Response?> verifyLoginOTP(String email) async{
    try {
      var url = Uri.parse('$mumbaiFnPath/sendLoginOTP');
      return await http.post(url, body: {'email': email});
    } catch (e) {
      xPrint(e.toString());
      return null;
    }
  }
}