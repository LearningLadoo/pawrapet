import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pawrapet/providers/firebaseMessagingProvider.dart';
import 'package:pawrapet/sharedPrefs/sharedPrefs.dart';
import 'package:provider/provider.dart';
import 'firebase/firestore.dart';
import 'firebase_options.dart';
import 'isar/isarManager.dart';
import 'isar/profile/profile.dart';
import 'providers/authProvider.dart';
import 'screens/home/home.dart';
import 'screens/loaderScreen.dart';
import 'screens/profile/profileQuick.dart';
import 'screens/welcome/welcome.dart';
import 'utils/constants.dart';
import 'utils/functions/common.dart';
import 'utils/functions/paths.dart';
import 'utils/functions/uploadFiles.dart';

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
          xPrint("auth = ${Provider.of<AuthProvider>(context, listen: false).firebaseUser} $authState}", header: 'intialize');
          if (authState == AuthState.loggedOut) {
            return const Welcome();
          } else {
            return handleLoggedIn();
          }
        }
        // loading handling
        return const LoaderScreen();
      },
    );
  }
}

FutureBuilder handleLoggedIn() {
  // manages if its logged in for the first time or not
  return FutureBuilder(
      future: initialProfileFetch(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done || snap.hasData == true) {
          // the data is there or has been fetched
          if (snap.data == 0) {
            return const Home();
          }
          // complete new user
          return ProfileQuick();
        }
        return const LoaderScreen();
      });
}

/// returns 0 when the data of the active profile number is fetched else returns the profile number
Future<int> initialProfileFetch() async {
  // get the active profile number
  try {
    if(xSharedPrefs.activeProfileNumber==null) await xSharedPrefs.initialize();
    int? pn = xSharedPrefs.activeProfileNumber;
    String? uidPN = xSharedPrefs.activeProfileUidPN!;// as at this point, when its logged in, the UID cannot be null
    xPrint("pn n uidPN $pn $uidPN",header: "initialProfileFetch" );

    // now check the isar if it has data for this pn
    xProfile = await xProfileIsarManager.getProfileFromProfileNumber(pn!);
    // if there is data in isar then return 0
    xPrint("profile in isar = ${xProfile!=null}",header: "initialProfileFetch" );

    if (xProfile != null) return 0;
    // else fetch the data of that profile
    Map? map = await FirebaseCloudFirestore().getProfileDetails(uidPN);
    // if the name is null then return the profile no to set it up
    xPrint("checking the fetched map or map name ${map} ${map??{}['name']}",header: "initialProfileFetch" );

    if (map == null || map['name'] == null) return pn;
    // else add it in isar and return 0
    xProfile = await xProfileIsarManager.getProfileFromMap(map: map!, profileNumber: pn, uidPN:uidPN!);
    await xProfileIsarManager.setProfile(xProfile!);
    xPrint("success",header: "initialProfileFetch" );

    return 0;
  } catch (e) {
    xPrint(e.toString(),header: "initialProfileFetch" );
    return -1;
  }
}

Future<bool> initializeApp(BuildContext context) async {
  // returning bool instead of void somehow is not showing the loader then the home screen when keyboard appears
  if (xInitializationAlreadyRan) return false;
  xInitializationAlreadyRan = true;
  xPrint("called", header: 'intializeApp');
  // so in order to create a different isolate for background messaging we need to use ensure binding as RunApp cannot be called yet
  WidgetsFlutterBinding.ensureInitialized();
  // Use a Builder widget to get the context and wait for the first frame
  await Future.delayed(Duration.zero);
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
Future<void> backgroundNotificationInitializer() async {
  // initialize the isar
  xIsarManager = IsarManager();
  await xIsarManager.initialize();
  return;
}
