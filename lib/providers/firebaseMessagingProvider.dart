import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import '../firebase/messaging.dart';
import '../isar/notificationMessage/notificationMessage.dart' as isar_notification;
import '../utils/functions/common.dart';

class MessagingProvider with ChangeNotifier {
  late StreamSubscription<RemoteMessage> _messageStream;
  isar_notification.NotificationMessage? _message; // new foreground messages

  isar_notification.NotificationMessage? get message => _message;

  initialize() async {
    xPrint("started listening messages", header: "FirebaseMessagingProvider");
    // start listening
    _listenToFirebaseMessages();
  }

  @override
  void dispose() {
    _messageStream.cancel();
    super.dispose();
  }

  // foreground listener
  void _listenToFirebaseMessages() {
    _messageStream = FirebaseMessaging.onMessage.listen((message) async {
      try {
        _message = await messageHandler(message);
        notifyListeners();
      } catch (e) {
        xPrint(e.toString(), header: "FirebaseMessagingProvider/listener");
      }
    });
  }
}
