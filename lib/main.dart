
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pawrapet/firebase_options.dart';
import 'package:pawrapet/initialize.dart';
import 'package:pawrapet/providers/authProvider.dart';
import 'package:pawrapet/providers/firebaseMessagingProvider.dart';
import 'package:pawrapet/providers/otpProvider.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:provider/provider.dart';

import 'providers/feedProvider.dart';
import 'utils/functions/common.dart';
// TODO: Add stream controller
// TODO: Define the background message handler

void main() async{
  xPrint("called", header: 'main');
// so in order to create a different isolate for background messaging we need to use ensure binding as RunApp cannot be called yet
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Set up foreground message handler
  // TODO: Set up background message handler
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OtpProvider()),
        ChangeNotifierProvider(create: (_) => MessagingProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
      ],
      child: RestartWidget(child: const MainApp()),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    xPrint("called", header: 'mainApp');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pawrapets',
      theme: lightTheme,
      home: const Initialize(),
    );
  }
}

class RestartWidget extends StatefulWidget {
  RestartWidget({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
