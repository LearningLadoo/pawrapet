/// this profile data contains the data that is only necessary for offline usage
/*
 profile {
  requestedUserForMatch {
   uid: true
  }. toString(),
  username
  profileNumber
  name
  uidPN // uid + profile number
  icon // profile icon as string
  amount
  isFindingMate
  v: 1
 }
 */

import 'dart:convert';

import 'package:isar/isar.dart';

part 'profile.g.dart';

@collection
class Profile {
  Id profileNumber;
  String? requestedUsersForMatch; // json string
  late String uidPN;
  late String username;
  String? name;
  String? iconBase64; // base64 string
  String? iconUrl; // url
  String? type;
  String? breed;
  String? gender;
  String? color;
  double? height;
  double? weight;
  double? amount;
  bool isFindingMate;

  Profile(
      {this.type,
      this.breed,
      this.gender,
      this.color,
      this.height,
      this.weight,
      required this.profileNumber,
      required this.uidPN,
      required this.username,
      this.name,
      this.iconBase64,
      this.amount,
      this.isFindingMate = false,
      this.requestedUsersForMatch});

  @ignore
  Map<String, dynamic>? get requestedUsersMapForMatch => json.decode(requestedUsersForMatch.toString());

  void updateRequestedUsersForMatch(Map<String, dynamic> map) {
    requestedUsersForMatch = json.encode(map);
  }
}
