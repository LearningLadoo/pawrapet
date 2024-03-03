import 'dart:convert';

import '../../utils/constants.dart';
import '../../utils/functions/common.dart';
import '../../utils/functions/uploadFiles.dart';
import 'profile.dart';

class ProfileIsarManager  {
  Future<Profile?> getProfileFromProfileNumber(int profileNumber) async {
    return await xIsarManager.db.profiles.get(profileNumber);
  }
  Future<bool> setProfile(Profile profile) async{
    try {
      await xIsarManager.db.writeTxn(() async => await xIsarManager.db.profiles.put(profile));
      return true;
    } catch (e) {
      xPrint(e.toString(), header: "setProfile/ProfileIsarManager");
      return false;
    }
  }
  Future<Profile> getProfileFromMap({required Map<dynamic, dynamic> map,required int profileNumber, required String uidPN}) async{
    return Profile(
        type: map['type'],
        breed: map['breed'],
        gender: map['gender'],
        color: map['color'],
        height: map['height']?.toDouble(),
        weight: map['weight']?.toDouble(),
        profileNumber: profileNumber,
        uidPN: uidPN,
        username: map["username"],
        name: map["name"],
        requestedUsersForMatch:json.encode(map['requestedUsersForMatch']),
        amount: map["amount"]?.toDouble(),
        isFindingMate: map["isFindingMate"],
        iconBase64: (map['assets']?['icon_0']?['url']!=null)?base64Encode(await getImageBytesFromUrl(map['assets']['icon_0']['url'])):null,
    );
  }
}