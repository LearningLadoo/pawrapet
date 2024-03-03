import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pawrapet/utils/functions/common.dart';
import 'package:pawrapet/utils/functions/idsChasKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

///  currUser: {email: string, UID: string, username: string, verified: bool, profiles: {pn:{active: true}}, onboardEpoch: int} // jsonEncoded
///  deviceInfo: {platform: string, deviceId: string, notificationID: string}
///  todo add that centercodes to the profile data.
///  matingFilter: {position : {latitude: double, longitude: double, city: string, state: string, country,  pincode: int}, radius: <int in Km>, centerCodes: List of codes, amountRange: [initial, final], breeds: [a list], colors: [a list], genders: [a list] }}
/// }
// create a public variable and initialize and use through out app

class SharedPrefs {
  late SharedPreferences _prefsInstance;
  final String _currUser = "currUser";
  final String _deviceInfo = "deviceInfo";
  final String _activePN = "activePN";
  final String _matingFilter = "matingFilter";
  int? _activeProfileNumber;
  Map? _currUserMap, _deviceInfoMap, _matingFilterMap;

  Future<bool> initialize() async {
    _prefsInstance = await SharedPreferences.getInstance();
    _updateCurrUserMap();
    _updateMatingFilterMap();
    await _updateDeviceInfoMap();
    await setDefaultActiveProfileNumber();
    xPrint("currUserMap = $_currUserMap \n deviceInfoMap = $_deviceInfoMap \n activeProfileNumber = $_activeProfileNumber");
    return true;
  }

  Map? get deviceInfoMap => _deviceInfoMap;

  Map? get currentUserMap => _currUserMap;

  Map? get matingFilterMap => _matingFilterMap;

  int? get activeProfileNumber => _activeProfileNumber;

  String? get activeProfileUidPN {
    if (_activeProfileNumber == 0 || _currUserMap == null || _currUserMap!['UID'] == null) return null;
    return '${_currUserMap!['UID']}_$_activeProfileNumber';
  }

  String? get uid {
    if (_currUserMap == null || _currUserMap!['UID'] == null) return null;
    return _currUserMap!['UID'];
  }

  String? get username {
    if (_currUserMap == null || _currUserMap!['username'] == null) return null;
    return _currUserMap!['username'];
  }

  List<int>? get profile {
    if (_currUserMap == null || _currUserMap!['profile'] == null) return null;
    return _currUserMap!['profile'];
  }

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
    return await _prefsInstance.remove(_currUser);
  }

  void _updateCurrUserMap() {
    _currUserMap = null;
    String? temp = getCurrUser();
    xPrint("temp $temp", header: "_updateCurrUserMap");
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

  Future<void> _updateDeviceInfoMap() async {
    _deviceInfoMap = {};
    String? temp = getDeviceInfo();
    if (temp != null) {
      _deviceInfoMap = jsonDecode(temp);
    }
    // setup if not found
    if (_deviceInfoMap!["deviceId"] == null) {
      _deviceInfoMap!.addAll(await deviceUniqueIdAndPlatform());
    }
    await setDeviceInfo(jsonEncode(_deviceInfoMap));

    return;
  }

  /*
  active profile number
   */
  Future<bool> setDefaultActiveProfileNumber() async {
    try {
      // get it from shared prefs
      _activeProfileNumber = _prefsInstance.getInt(_activePN);
      // do not change anything
      if (_activeProfileNumber != null || _currUserMap == null || _currUserMap!['profiles'] == null) return true;
      xPrint("groo", header: "setDefaultActiveProfileNumber");

      // if null then give the default as first key; this case is when it
      Map temp = _currUserMap!['profiles'];
      if (temp.keys.isNotEmpty) {
        for (String pn in temp.keys) {
          if (temp[pn]['active']) {
            _activeProfileNumber = int.parse(pn);
            await updateActiveProfileNumber(_activeProfileNumber!);
            break;
          }
        }
      }
    } catch (e) {
      xPrint(e.toString(), header: "setDefaultActiveProfileNumber");
    }
    return true;
  }

  Future<bool> updateActiveProfileNumber(int newPN) async {
    _activeProfileNumber = newPN;
    return await _prefsInstance.setInt(_activePN, newPN);
  }

  // return -1 if it fails
  int createNewActiveProfileNumber() {
    if (_currUserMap == null || _currUserMap!['profiles'] == null) return -1;
    int pn = 0;
    Map temp = _currUserMap!['profiles'];
    for (String i in temp.keys) {
      int key = int.parse(i);
      if (key > pn) pn = key;
    }
    return pn + 1;
  }

  Future<bool> setupTheNewProfileNumber(int newPN) async {
    _activeProfileNumber = newPN;
    updateActiveProfileNumber(newPN);
    _currUserMap!['profiles']!.addAll({
      "$newPN": {'active': true}
    });
    return await setCurrUser(jsonEncode(_currUserMap));
  }
  /*
  * Mating Filters
  * */
  String? getMatingFilters(){
    return _prefsInstance.getString(_matingFilter);
  }
  bool _updateMatingFilterMap() {
    String? temp = getMatingFilters();
    if(temp!=null){
      _matingFilterMap = json.decode(temp);
      return true;
    }
    return false;
  }

  Future<bool> setMatingFilters(Map matingFilters) async{
    _matingFilterMap = matingFilters;
    return await _prefsInstance.setString(_matingFilter, json.encode(matingFilters));
  }
  Future<bool> setPositionInMatingFilters(Map positionMap) async{
    Map temp = _matingFilterMap??{};
    temp['position'] = positionMap;
    _matingFilterMap = temp;
    return await _prefsInstance.setString(_matingFilter, json.encode(temp));
  }
  /// in km
  Future<bool> setRadiusInMatingFilters(double radius) async{
    Map temp = _matingFilterMap??{};
    temp['radius'] = radius;
    _matingFilterMap = temp;
    return await _prefsInstance.setString(_matingFilter, json.encode(temp));
  }
  /// just the 5 digit code
  Future<bool> setCenterCodesInMatingFilters(List<String> centerCodes) async{
    Map temp = _matingFilterMap??{};
    temp['centerCodes'] = centerCodes;
    _matingFilterMap = temp;
    return await _prefsInstance.setString(_matingFilter, json.encode(temp));
  }
  /// in thousands, initial to final
  Future<bool> setAmountInMatingFilters(List<double> amount) async{
    Map temp = _matingFilterMap??{};
    temp['amountRange'] = amount;
    _matingFilterMap = temp;
    return await _prefsInstance.setString(_matingFilter, json.encode(temp));
  }
  Future<bool> setBreedsInMatingFilters(List<String> breeds) async{
    Map temp = _matingFilterMap??{};
    temp['breeds'] = breeds;
    _matingFilterMap = temp;
    return await _prefsInstance.setString(_matingFilter, json.encode(temp));
  }
  Future<bool> setColorsInMatingFilters(List<String> colors) async{
    Map temp = _matingFilterMap??{};
    temp['colors'] = colors;
    _matingFilterMap = temp;
    return await _prefsInstance.setString(_matingFilter, json.encode(temp));
  }
  Future<bool> setGendersInMatingFilters(List<String> genders) async{
    Map temp = _matingFilterMap??{};
    temp['genders'] = genders;
    _matingFilterMap = temp;
    return await _prefsInstance.setString(_matingFilter, json.encode(temp));
  }
}
