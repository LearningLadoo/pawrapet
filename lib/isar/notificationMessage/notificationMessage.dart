import 'dart:convert';

import 'package:isar/isar.dart';

part 'notificationMessage.g.dart';

@collection
class NotificationMessage {
  Id? id; // auto-generated
  late bool seen; // if the notification is seen or interacted with
  late String data; // Json data
  int? profileId;
  late bool removed; // if the notification is removed
  late int epoch; // epoch
  NotificationMessage({ required this.data, this.seen = false, this.profileId, this.removed = false, required this.epoch});

  Map getDataMap(){
    return jsonDecode(data);
  }
}
