import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawrapet/providers/authProvider.dart';
import 'package:pawrapet/screens/home/home.dart';
import 'package:pawrapet/screens/loaderScreen.dart';
import 'package:pawrapet/screens/welcome/welcome.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/functions/common.dart';
import 'package:pawrapet/utils/functions/paths.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

class Initialize extends StatefulWidget {
  const Initialize({Key? key}) : super(key: key);

  @override
  State<Initialize> createState() => _InitializeState();
}

class _InitializeState extends State<Initialize> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeApp(context),
      builder: (context, snapshot) {
        // error handling
        if (snapshot.hasError) {
          return const Center(
            child: Text("Ran into unexpected issue, try re-running the app."),
          );
        }
        // success handling
        else if (snapshot.connectionState == ConnectionState.done || snapshot.hasData == true) {
          AuthState authState = Provider.of<AuthProvider>(context, listen: false).authState;
          xPrint("auth = $authState", header: 'intialize');
          if(authState==AuthState.loggedOut){
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

Future<void> initializeApp(BuildContext context) async {
  // create variables
  xTheme = Theme.of(context);
  xHeight = MediaQuery.of(context).size.height;
  xWidth = MediaQuery.of(context).size.width;
  // firebase core
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   // get the user auth
  // AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
  // changing the bottom nav bar
  SystemChrome.setSystemUIOverlayStyle(xMySystemTheme);
  // location
  await gettingLocalPath();
  // get databases ready
  petsData = json.decode(await rootBundle.loadString("assets/database/petsData.json"));

  return;
}
