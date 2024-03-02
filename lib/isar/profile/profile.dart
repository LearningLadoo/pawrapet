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
  String? _requestedUsersForMatch; // json string
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
      Map<String, dynamic>? requestedUsersForMatch}) {
    _requestedUsersForMatch = json.encode(requestedUsersForMatch ?? {});
  }

  @ignore
  Map<String, dynamic> get requestedUsersForMatch => json.decode(_requestedUsersForMatch.toString());
}
