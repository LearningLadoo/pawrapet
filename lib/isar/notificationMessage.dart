import 'dart:convert';

import 'package:isar/isar.dart';

part 'notificationMessage.g.dart';

@collection
class NotificationMessage {
  late Id id; // epoch of arrival
  late bool seen; // if the notification is seen or interacted with
  late String data; // Json data
  int? profileID;
  late bool removed; // if the notification is removed
  NotificationMessage({required this.id, required this.data, this.seen = false, this.profileID, this.removed = false});

  Map getDataMap(){
    return jsonDecode(data);
  }
}
