import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawrapet/screens/loaderScreen.dart';
import 'package:pawrapet/screens/profile/profileQuick.dart';
import 'package:pawrapet/screens/welcome/welcome.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/functions/common.dart';
import 'package:pawrapet/utils/functions/paths.dart';

class Initialize extends StatefulWidget {
  const Initialize({Key? key}) : super(key: key);

  @override
  State<Initialize> createState() => _InitializeState();
}

class _InitializeState extends State<Initialize> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeVariables(context),
      builder: (context, snapshot) {
        // error handling
        if (snapshot.hasError) {
          return const Center(
            child: Text("Ran into unexpected issue, try re-running the app."),
          );
        }
        // success handling
        else if (snapshot.connectionState == ConnectionState.done || snapshot.hasData == true) {
          if(true){
            return const Welcome();
          }
        }
        // loading handling
        return const LoaderScreen();
      },
    );
  }
}

Future<void> initializeVariables(BuildContext context) async {
  // changing the bottom nav bar
  SystemChrome.setSystemUIOverlayStyle(xMySystemTheme);
  // create variables
  xTheme = Theme.of(context);
  xHeight = MediaQuery.of(context).size.height;
  xWidth = MediaQuery.of(context).size.width;
  // location
  await gettingLocalPath();
  // get databases ready
  petsData = json.decode(await rootBundle.loadString("assets/database/petsData.json"));

  return;
}
