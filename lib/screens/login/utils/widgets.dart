import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

Widget headerBanner(String text){
  return SizedBox(
    width: xWidth,
    child: Stack(
      children: [
        Positioned(
            right:-xSize/4,
            bottom: xSize/2,
            child: Image.asset("assets/images/element4.png", height: xSize*5,)),
        SizedBox(
            width: xWidth*0.7,
            height: xSize*6,
            child: Center(
                child: Text(text, style: xTheme.textTheme.headlineLarge!.apply(fontSizeDelta: gapSize*2),))),
      ],
    ),
  );
}