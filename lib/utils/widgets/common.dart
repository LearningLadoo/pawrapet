import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';

Widget xHeaderBanner(String text) {
  return SizedBox(
    width: xWidth,
    child: Stack(
      children: [
        Positioned(
            right: -xSize / 4,
            bottom: xSize / 2,
            child: Image.asset(
              "assets/images/element4.png",
              height: xSize * 5,
            )),
        Container(
            width: xWidth * 0.6,
            height: xSize * 6,
            child: Align(alignment: Alignment.centerLeft, child: Text(text, style: xTheme.textTheme.headlineLarge!.apply(fontSizeDelta: gapSize * 2, color: xPrimary.withOpacity(0.9))))),
      ],
    ),
  );
}

// glass bg effect
Widget xGlassBgEffect({double? height, double? width, required Widget child, Color? bgColor, double? borderRadius}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius ?? 0),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(color: bgColor ?? xOnSurface.withOpacity(0.2), width: width, height: height, child: child),
    ),
  );
}

class Rating extends StatefulWidget {
  ValueChanged<int?> onChanged;
  int? initialRating;

  Rating({Key? key, required this.onChanged, required this.initialRating}) : super(key: key);

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  int? rating;

  @override
  void initState() {
    rating = widget.initialRating;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            rating = 1;
            setState(() {});
            widget.onChanged(rating);
          },
          child: Icon(
            CupertinoIcons.star_fill,
            size: xSize * 1.5,
            color: ((rating ?? 0) >= 1) ? Colors.yellow[800] : xPrimary.withOpacity(0.15),
          ),
        ),
        GestureDetector(
          onTap: () {
            rating = 2;
            setState(() {});
            widget.onChanged(rating);
          },
          child: Icon(
            CupertinoIcons.star_fill,
            size: xSize * 1.5,
            color: ((rating ?? 0) >= 2) ? Colors.yellow[800] : xPrimary.withOpacity(0.15),
          ),
        ),
        GestureDetector(
          onTap: () {
            rating = 3;
            setState(() {});
            widget.onChanged(rating);
          },
          child: Icon(
            CupertinoIcons.star_fill,
            size: xSize * 1.5,
            color: ((rating ?? 0) >= 3) ? Colors.yellow[800] : xPrimary.withOpacity(0.15),
          ),
        ),
        GestureDetector(
          onTap: () {
            rating = 4;
            setState(() {});
            widget.onChanged(rating);
          },
          child: Icon(
            CupertinoIcons.star_fill,
            size: xSize * 1.5,
            color: ((rating ?? 0) >= 4) ? Colors.yellow[800] : xPrimary.withOpacity(0.15),
          ),
        ),
        GestureDetector(
          onTap: () {
            rating = 5;
            setState(() {});
            widget.onChanged(rating);
          },
          child: Icon(
            CupertinoIcons.star_fill,
            size: xSize * 1.5,
            color: ((rating ?? 0) >= 5) ? Colors.yellow[800] : xPrimary.withOpacity(0.15),
          ),
        ),
      ],
    );
  }
}

// loader
Widget dogWaitLoader(String? loaderText) {
  return Stack(
    // mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset("assets/lotties/dog_happy_walk.json", width: xSize * 10),
      Positioned(
        bottom: xSize*1,
        child: SizedBox(
          width: xSize * 10,
          child: Text(
            loaderText ?? "",
            style: xTheme.textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ],
  );
}

/// disables the child widget by reducing opacity and absorbing pointers and also throws snackbar as alert message
Widget xDisableWithAlert({required Widget child, required BuildContext context, required String alertMessage, required bool isDisabled}) {
  return Opacity(
    opacity: isDisabled?0.5:1,
    child: AbsorbPointer(
      absorbing: isDisabled,
      child: child,
    ),
  );
}
