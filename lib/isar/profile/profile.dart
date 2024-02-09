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

import 'package:isar/isar.dart';

part 'profile.g.dart';

@collection
class Profile {
  Id profileNumber;
  String? requestedUsersForMatch; // json string
  late String uidPN;
  late String username;
  String? name;
  String? icon;
  String? type;
  String? breed;
  String? gender;
  String? colour;
  double? height;
  double? weight;
  double? amount;
  bool isFindingMate;

  Profile(
      {this.type,
      this.breed,
      this.gender,
      this.colour,
      this.height,
      this.weight,
      required this.profileNumber,
      this.requestedUsersForMatch,
      required this.uidPN,
      required this.username,
      this.name,
      this.icon,
      this.amount,
      this.isFindingMate = false});
}
