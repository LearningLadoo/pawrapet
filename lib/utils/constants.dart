import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pawrapet/firebase/messaging.dart';
import 'package:pawrapet/sharedPrefs/sharedPrefs.dart';
import 'package:pawrapet/utils/extensions/colors.dart';

import '../isar/isarManager.dart';
import '../isar/notificationMessage/notificationsManager.dart';
import '../isar/profile/profile.dart';
import '../isar/profile/profileManager.dart';

late Map<String, dynamic> petsData;
// to generate sizes
const double smallestSize = 10, gapSize = 2;
const double xSize1 = smallestSize + gapSize * 0;
const double xSize2 = smallestSize + gapSize * 2;
const double xSize3 = smallestSize + gapSize * 3;
const double xSize4 = smallestSize + gapSize * 4;
const double xSize5 = smallestSize + gapSize * 5;
const double xSize6 = smallestSize + gapSize * 6;
const double xSize7 = smallestSize + gapSize * 10;
const double xSize8 = smallestSize + gapSize * 12;
const double xSize = xSize8;
late double xHeight, xWidth;
// strings
late String xLocalPath;
// to stop app from intitializing again n again
bool xInitializationAlreadyRan = false;
//firebase messaging
FirebaseCouldMessaging xFirebaseMessaging = FirebaseCouldMessaging();
// sharedPrefsInstance
SharedPrefs xSharedPrefs = SharedPrefs();// colors
// isar manager
IsarManager xIsarManager = IsarManager();
// NotificationsIsarManager
NotificationsIsarManager xNotificationsIsarManager = NotificationsIsarManager();
// ProfileIsarManager
ProfileIsarManager xProfileIsarManager = ProfileIsarManager();
// profile
Profile? xProfile;
// logo image
Image xAppLogo = Image.asset('assets/icons/logo_mascot.png');
//
const Color xPrimary = Color(0xFF152F41);
const Color xOnPrimary = Color(0xFFf8f0e5);
const Color xSecondary = Color(0xFFd7dfd0);
const Color xOnSecondary = Color(0xFF425d4b);
const Color xSurface = Color(0xFFf8f0e5);
const Color xOnSurface = Color(0xfff8e7c5);
const Color xError = Color(0xFFf8ccc3);
const Color xOnError = Color(0xFFd7585b);
const Color xInfoColor = Color(0xFFf2dfbd);
const Color xOnInfoColor = Color(0xFF8f9087);

// theme
late ThemeData xTheme;
ThemeData lightTheme = ThemeData.light(useMaterial3: true).copyWith(
  scaffoldBackgroundColor: xSurface,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: xPrimary,
    onPrimary: xOnPrimary,
    secondary: xSecondary,
    onSecondary: xOnPrimary,
    error: xError,
    onError: xOnError,
    background: xSurface,
    onBackground: xOnSurface,
    surface: xSurface,
    onSurface: xPrimary!.withOpacity(0.6),
  ),
  textTheme: const TextTheme(
    // logo
    headlineLarge: TextStyle(
      fontSize: xSize8,
      fontWeight: FontWeight.w700,
    ),
    // subheadings
    headlineMedium: TextStyle(
      fontSize: xSize6,
      fontWeight: FontWeight.w500,
    ),
    // next back chip, buttons equal to the text
    headlineSmall: TextStyle(
      fontSize: xSize4,
      fontWeight: FontWeight.w600,
    ),
    // page heading or the title
    titleLarge: TextStyle(
      fontSize: xSize7,
      fontWeight: FontWeight.w700,
    ),
    // title of sections in account page
    titleMedium: TextStyle(
      fontSize: xSize6,
      fontWeight: FontWeight.w400,
    ),
    // text input
    bodyLarge: TextStyle(
      fontSize: xSize5,
      fontWeight: FontWeight.w500,
    ),
    // paragraph
    bodyMedium: TextStyle(
      fontSize: xSize4,
      fontWeight: FontWeight.w500,
    ),
    // extra info
    bodySmall: TextStyle(
      fontSize: xSize3,
      fontWeight: FontWeight.w400,
    ),
    // labels
    labelLarge: TextStyle(
      fontSize: xSize3,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      fontSize: xSize2,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      fontSize: xSize1,
      fontWeight: FontWeight.w500,
    ),
  ).apply(
    fontFamily: "Roboto",
    displayColor: xPrimary,
    bodyColor: xPrimary,
  ),
  dialogBackgroundColor: xSecondary,
  dividerTheme: DividerThemeData(
    color: xPrimary.withOpacity(0.1),
  ),
);
ColorScheme xDatePickerColorScheme = ColorScheme(
  brightness: Brightness.light,
  surface: xSecondary,
  onSurface: xOnSecondary.withOpacity(0.8),
  background: xSecondary,
  onBackground: xOnSecondary.withOpacity(0.8),
  primary: xOnSecondary.withOpacity(1),
  onPrimary: xSecondary,
  secondary: xOnSecondary.withOpacity(0.8),
  onSecondary: xSecondary,
  secondaryContainer: xOnSecondary.withOpacity(0.5),
  error: xError,
  onError: xOnError,
);
// system theme
SystemUiOverlayStyle xMySystemTheme = SystemUiOverlayStyle.dark.copyWith(systemNavigationBarColor: xOnPrimary, statusBarColor: xOnPrimary, systemNavigationBarIconBrightness: Brightness.dark);
// todo fetch this list from firebase
Map allMatingPoints = {
  "12101": {
    'code': '12101',
    'name': 'Center 12101, Faridabad, Haryana',
    'latitude': 28.41337361131685,
    'longitude': 77.30588547288345,
  }
};