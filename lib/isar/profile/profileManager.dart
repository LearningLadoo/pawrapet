import 'dart:convert';

import '../../utils/constants.dart';
import '../../utils/functions/uploadFiles.dart';
import 'profile.dart';

class ProfileIsarManager  {
  Future<Profile?> getProfileFromProfileNumber(int profileNumber) async {
    return await xIsarManager.db.profiles.get(profileNumber);
  }
  Future<bool> setProfile(Profile profile) async{
    await xIsarManager.db.writeTxn(() async => await xIsarManager.db.profiles.put(profile));
    return true;
  }
  Future<Profile> getProfileFromMap({required Map<dynamic, dynamic> map,required int profileNumber, required String uidPN}) async{
    return Profile(
        type: map['type'],
        breed: map['breed'],
        gender: map['gender'],
        colour: map['colour'],
        height: map['height']?.toDouble(),
        weight: map['weight']?.toDouble(),
        profileNumber: profileNumber,
        uidPN: uidPN,
        username: map["username"],
        name: map["name"],
        requestedUsersForMatch:json.encode(map['requestedUsersForMatch']),
        amount: map["amount"]?.toDouble(),
        isFindingMate: map["isFindingMate"],
        icon: (map['assets']?['icon_0']?['url']!=null)?base64Encode(await getImageBytesFromUrl(map['assets']['icon_0']['url'])):null,
    );
  }
}