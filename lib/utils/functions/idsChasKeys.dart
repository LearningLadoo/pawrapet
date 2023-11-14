import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pawrapet/utils/functions/common.dart';

/*
* ids, char or keys
* */

List<int> _processString = [2,7,1,5,6,3,9,4,7,3,5,2,1,7,3];

// get the chas (key) before sending a request
String getChas(){
  DateTime dt = DateTime.now().toUtc();
  String cha = "ganda${intl.DateFormat('EMMMddyyyy').format(dt)}bacha";
  cha = processStringWrtId(cha, dt.minute);
  return cha;
}
// get a unique deviceId and platform
Future<Map> deviceUniqueIdAndPlatform() async {
  var deviceInfo = DeviceInfoPlugin();
  String? temp;
  String? platform;
  if (Platform.isIOS) { // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    temp = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    platform = "ios";
  } else if (Platform.isAndroid){
    var androidDeviceInfo = await deviceInfo.androidInfo;
    temp = androidDeviceInfo.id; // unique ID on Android
    platform = "android";
  }
  // have to do this because "." is not letting me update the token directly
  if(temp!=null){
    temp = temp.replaceAll(".", "_@_");
  }
  xPrint("the unique id is : $temp", header: "idsKeysChas/deviceUniqueIdAndPlatform");
  return {"deviceId":temp,"platform":platform};
}

// process any string with an id
String processStringWrtId(String string,int number , {int type = 1}){
  List<String> characters = ['0','1','2','3','4','5','6','7','8','9','A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];
  //converting to ascii
  //48-57(10) and 97-102(26) and 65-90(26)
  List<String> tempList =[];
  for(int i = 0 ; i< string.length ;i++){
    int incrementValue = ((i<_processString.length)?_processString[i]:_processString.last)*number;
    incrementValue = incrementValue.remainder(10+26+26); // filtering to only one loop
    int index = characters.indexOf(string.substring(i,i+1));
    int newValue = index+incrementValue*type;
    index = ((newValue>(10+26+26-1)||newValue<0)?(-(10+26+26)*type+newValue):newValue);
    tempList.add(characters[index]);
  }
  return tempList.join();
}