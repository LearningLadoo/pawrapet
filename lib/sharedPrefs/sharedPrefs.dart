import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pawrapet/utils/functions/common.dart';
import 'package:pawrapet/utils/functions/idsChasKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

///  currUser: {email: string, UID: string, verified: bool} // jsonEncoded
///  deviceInfo: {platform: string, deviceId: string, notificationId: string}
/// }
// create a public variable and initialize and use through out app

class SharedPrefs {
  late SharedPreferences _prefsInstance;
  final String _currUser = "currUser";
  final String _deviceInfo = "deviceInfo";
  Map? _currUserMap, _deviceInfoMap;

  Future<bool> initialize() async {
    _prefsInstance = await SharedPreferences.getInstance();
    _updateCurrUserMap();
    await _updateDeviceInfoMap();
    xPrint("currUserMap = $_currUserMap \n deviceInfoMap = $_deviceInfoMap");
    return true;
  }

  Map? get deviceInfoMap => _deviceInfoMap;

  Map? get currentUserMap => _currUserMap;

  // clear
  Future<bool> clear() async {
    return await _prefsInstance.clear();
  }

  /* currUser */
  String? getCurrUser() {
    return _prefsInstance.getString(_currUser);
  }

  Future<bool> setCurrUser(String details) async {
    bool temp = await _prefsInstance.setString(_currUser, details);
    // making sure the map is updated
    if (temp) _updateCurrUserMap();
    return temp;
  }

  Future<bool> removeCurrUser() async {
    _currUserMap = null;
    return _prefsInstance.remove(_currUser);
  }

  void _updateCurrUserMap() {
    _currUserMap = null;
    String? temp = getCurrUser();
    if (temp != null) {
      _currUserMap = jsonDecode(temp);
    }
  }
  /* deviceInfo */
  String? getDeviceInfo() {
    return _prefsInstance.getString(_deviceInfo);
  }

  Future<bool> setDeviceInfo(String details) async {
    bool temp = await _prefsInstance.setString(_deviceInfo, details);
    // making sure the map is updated
    if (temp) _updateDeviceInfoMap();
    return temp;
  }

  Future<void> _updateDeviceInfoMap() async{
    _deviceInfoMap = {};
    String? temp = getDeviceInfo();
    if (temp != null) {
      _deviceInfoMap = jsonDecode(temp);
    }
    // setup if not found
    if(_deviceInfoMap!["deviceId"]== null){
      _deviceInfoMap!.addAll(await deviceUniqueIdAndPlatform());
    }
    await setDeviceInfo(jsonEncode(_deviceInfoMap));

    return;
  }
}
