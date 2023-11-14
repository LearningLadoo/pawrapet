import 'dart:convert';

import 'package:isar/isar.dart';

import '../utils/constants.dart';
import 'notificationMessage.dart';

class NotificationsIsarManager {

  // get stream of notifications that need to be displayed
  Stream<List<NotificationMessage>> getStreamOfDisplayedNotifications({required int profileId}){
    Query<NotificationMessage> query = xIsarManager.db.notificationMessages.where(sort: Sort.desc).filter().profileIDEqualTo(profileId).or().profileIDIsNull().and().removedEqualTo(false).build();
    return query.watch(fireImmediately: true);
  }

  // get batch Notifications
  Future<List<NotificationMessage>> getBatchNotificationsToDisplay({required int profileId, required int offset, required int batchSize}) async {
    return await xIsarManager.db.notificationMessages.where(sort: Sort.desc).filter().profileIDEqualTo(profileId).or().profileIDIsNull().and().removedEqualTo(false).offset(offset).limit(batchSize).findAll();
  }

  // get unread Notifications count
  Future<int> getUnreadNotificationsCount() async {
    return await xIsarManager.db.notificationMessages.filter().seenEqualTo(false).count();
  }

  // add notification
  Future<NotificationMessage> addNotification(Map data) async {
    NotificationMessage notification = NotificationMessage(
      id: data["epoch"],
      data: jsonEncode(data),
      seen: false,
    );
    await xIsarManager.db.writeTxn(() async => await xIsarManager.db.notificationMessages.put(notification));
    return notification;
  }

  // update seen
  Future<void> markSeen(NotificationMessage notification) async {
    notification.seen = true;
    await xIsarManager.db.writeTxn(() async => await xIsarManager.db.notificationMessages.put(notification));
  }
  // handle removed
  Future<void> handleRemoved(NotificationMessage notification) async {
    notification.seen = true;
    notification.removed = true;
    await xIsarManager.db.writeTxn(() async => await xIsarManager.db.notificationMessages.put(notification));
  }
  // todo create a listener

}
