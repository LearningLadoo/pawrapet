import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pawrapet/providers/firebaseMessagingProvider.dart';
import 'package:pawrapet/sharedPrefs/sharedPrefs.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'isar/isarManager.dart';
import 'providers/authProvider.dart';
import 'screens/home/home.dart';
import 'screens/loaderScreen.dart';
import 'screens/welcome/welcome.dart';
import 'utils/constants.dart';
import 'utils/functions/common.dart';
import 'utils/functions/paths.dart';

class Initialize extends StatelessWidget {
  const Initialize({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeApp(context),
      builder: (context, snapshot) {
        xPrint("$xInitializationAlreadyRan", header: 'intialize');
        xPrint("called", header: 'intialize'); // error handling
        if (snapshot.hasError) {
          xPrint("error ${snapshot.error}", header: 'intialize');
          return const Center(
            child: Text("Ran into unexpected issue, try re-running the app."),
          );
        }
        // success handling
        else if (snapshot.connectionState == ConnectionState.done || snapshot.hasData == true) {
          AuthState authState = Provider.of<AuthProvider>(context, listen: false).authState;
          xPrint("auth = ${Provider.of<AuthProvider>(context, listen: false).firebaseUser} $authState ${FirebaseAuth.instance.currentUser}", header: 'intialize');
          if (authState == AuthState.loggedOut) {
            return const Welcome();
          } else {
            return const Home();
          }
        }
        // loading handling
        return const LoaderScreen();
      },
    );
  }
}

Future<bool> initializeApp(BuildContext context) async {
  // returning bool instead of void somehow is not showing the loader then the home screen when keyboard appears
  if (xInitializationAlreadyRan) return false;
  xInitializationAlreadyRan = true;

  xPrint("called", header: 'intializeApp');
  // so in order to create a different isolate for background messaging we need to use ensure binding as RunApp cannot be called yet
  WidgetsFlutterBinding.ensureInitialized();
  // create variables
  xTheme = Theme.of(context);
  xHeight = MediaQuery.of(context).size.height;
  xWidth = MediaQuery.of(context).size.width;
  // firebase core
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // initialize sharedPrefs
  await xSharedPrefs.initialize();
  // initialize the isar
  await xIsarManager.initialize();
  // initialize xFirebaseMessaging
  await xFirebaseMessaging.initialize();
  // activating the listener
  Provider.of<MessagingProvider>(context, listen: false).initialize();
  // set the user auth and manage tokens for FCM
  await Provider.of<AuthProvider>(context, listen: false).initializeAuth(context);
  // changing the bottom nav bar
  SystemChrome.setSystemUIOverlayStyle(xMySystemTheme);
  // location
  await gettingLocalPath();
  // get databases ready
  petsData = json.decode(await rootBundle.loadString("assets/database/petsData.json"));

  return true;
}
// background notification
Future<void> backgroundNotificationInitializer()async{
  // initialize the isar
  xIsarManager = IsarManager();
  await xIsarManager.initialize();
  return;
}
