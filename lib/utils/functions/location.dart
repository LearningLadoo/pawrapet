import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';
import '../constants.dart';
import '../extensions/sizedBox.dart';
import '../widgets/buttons.dart';
import 'common.dart';
import 'toShowWidgets.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);
}

// todo getting the set state is a bad practice
Widget getLocationPermissionWidget(VoidCallback setState) {
  return Container(
    padding: const EdgeInsets.all(xSize / 2),
    margin: const EdgeInsets.all(xSize / 2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(xSize / 3),
      color: xSecondary,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Approximate Location",
          style: xTheme.textTheme.headlineMedium,
        ),
        const SizedBox().vertical(size: xSize / 2),
        Text(
          "To access mating feature we require your approximate location inorder to check our availability of our centers in your area.\nOur team ensures a guided mating process at our centers.",
          style: xTheme.textTheme.bodyMedium,
        ),
        const SizedBox().vertical(size: xSize / 2),
        XRoundedButton(
          onPressed: () async {
            await fetchAndAssignPosition(setState);
          },
          expand: true,
          text: "Provide Location",
          textStyle: xTheme.textTheme.bodyMedium!.apply(fontWeightDelta: 0, color: xSecondary),
        ),
      ],
    ),
  );
}

Future<void> fetchAndAssignPosition(VoidCallback setState) async {
  try {
    Position position = await determinePosition();
    // todo remove this, its for testing
    Map tempMap = position.toJson();
    tempMap["latitude"] = 28.543271;
    tempMap["longitude"] = 77.273530;
    position = Position.fromMap(tempMap);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Map positionMap = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'country': placemarks[0].country,
      'city': placemarks[0].locality,
      'state': placemarks[0].administrativeArea,
      'pincode': placemarks[0].postalCode
    };
    xPrint("placemarks and position $placemarks ${position.isMocked} ${position.latitude} ${position.longitude}", header: 'getCurrPositionForMatingFeed');
    await xSharedPrefs.setPositionInMatingFilters(positionMap);
    setState();
  } catch (e) {
    if (e.toString().contains("permanently denied")) {
      // redirect to the settings
      openAppSettings();
    }
    xPrint("$e", header: "getLocationPermissionWidget");
  }
}

double getDistanceFromLatLonInKm(double lat1, double lon1, double lat2, double lon2) {
  var R = 6371; // Radius of the earth in km
  var dLat = deg2rad(lat2 - lat1); // deg2rad below
  var dLon = deg2rad(lon2 - lon1);
  var a = sin(dLat / 2) * sin(dLat / 2) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  var c = 2 * atan2(sqrt(a), sqrt(1 - a));
  var d = R * c; // Distance in km
  xPrint("the distance is $d", header: "getDistanceFromLatLonInKm");
  return d;
}

double deg2rad(double deg) {
  return deg * (pi / 180);
}
