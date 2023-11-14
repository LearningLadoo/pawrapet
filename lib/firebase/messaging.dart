import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pawrapet/firebase/firestore.dart';
import 'package:pawrapet/isar/notificationMessage.dart';
import 'package:pawrapet/isar/notificationsManager.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/functions/common.dart';

import '../initialize.dart';

// IMP make sure to initialize SharedPrefs before this.
// listener will be in provider; FirebaseMessaging.onMessage.listen
class FirebaseCouldMessaging {
  late FirebaseMessaging _messaging;

  Future<bool> initialize() async {
    // instance
    _messaging = FirebaseMessaging.instance;
    // background messaging handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    return true;
  }

  // todo unimplemented: ask for permission
  Future<bool> requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    xPrint("permission state - ${settings.authorizationStatus}", header: "FirebaseCouldMessaging/requestPermissions");
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  // generated and updated token if needed in both sharedPrefs and cloud
  Future<bool> manageToken() async {
    xPrint("called", header: "FirebaseCloudMessaging/manageToken");

    // get Token
    String? token = await _messaging.getToken();
    // get oldToken from SharedPrefs
    Map deviceInfoMap = xSharedPrefs.deviceInfoMap!;
    String? oldToken = deviceInfoMap["notificationId"];
    xPrint("tokens old $oldToken \n new $token", header: "FirebaseCloudMessaging/manageToken");
    xPrint("${deviceInfoMap}", header: "FirebaseCloudMessaging/manageToken");
    if (oldToken != token && token != null) {
      // update the shared prefs and update the firebase database
      deviceInfoMap.addAll(Map<String, dynamic>.from({"notificationId": token}));
      await Future.wait([
        FirebaseCloudFirestore().updateNotificationId(xSharedPrefs.currentUserMap!["UID"], deviceInfoMap["deviceId"], token),
        xSharedPrefs.setDeviceInfo(jsonEncode(deviceInfoMap)),
      ]);
    }
    xPrint("2 ${token == oldToken} ${deviceInfoMap}", header: "FirebaseCloudMessaging/manageToken");

    return token != null;
  }
}

// call this in the normal initialization to run in bg  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  xPrint("Handling a background message: ${message.messageId}", header: "backgroundMessage");
  xPrint('Message data: ${message.data}', header: "backgroundMessage");
  xPrint('Message notification: ${message.notification?.title}', header: "backgroundMessage");
  xPrint('Message notification: ${message.notification?.body}', header: "backgroundMessage");
  // initialize
  await backgroundNotificationInitializer();
  // get message n show notification via local notification plugin
  await messageHandler(message);
}

Future<NotificationMessage> messageHandler(RemoteMessage message) async {
  Map data = message.data;
  // todo do you really need to do following
  //  json string of channelDetails to map
  // Map channelDetails = jsonDecode(data['channelDetails']);
  // data.addAll({'channelDetails': channelDetails});
  // if contains a variable of notify as true then only show notification
  if (data['notify'] == "true") {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      data['channelDetails']['id'],
      data['channelDetails']['name'],
      channelDescription: data['channelDetails']['description'],
      importance: Importance.max,
      priority: Priority.high,
    );
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // initialize localNotifications
    await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(android: AndroidInitializationSettings('@mipmap/launcher_icon')));

    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await Future.wait([
      //  show the notification
      flutterLocalNotificationsPlugin.show(2, data['title'], data['body'], notificationDetails),
    ]);
  }
  return await xNotificationsIsarManager.addNotification(data);
}