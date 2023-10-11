import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';

import '../../../../utils/constants.dart';

Widget matingTile({required List<Widget> children, Color? backgroundColor}) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(xSize / 2).copyWith(bottom: 0, top: 0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: backgroundColor??xOnSurface.withOpacity(0.9),
                borderRadius: BorderRadius.circular(xSize2),
              ),
              padding: const EdgeInsets.all(xSize / 2),
              child: Column(
                children: children,
              ),
            )
          ],
        ),
      ),
    ),
  );
}


Widget lockWithHeading(String heading, String subHeading){
  return Opacity(
    opacity: 0.9,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox().vertical(),
        Text(
          heading,
          style: xTheme.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox().vertical(),
        Icon(Icons.lock, color: xPrimary.withOpacity(0.8),size: xSize*2,),
        const SizedBox().vertical(),
        Text(
          subHeading,
          style: xTheme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox().vertical(),
      ],
    ),
  );
}