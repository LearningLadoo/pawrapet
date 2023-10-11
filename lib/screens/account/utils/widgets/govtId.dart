import 'package:flutter/material.dart';
import '/../utils/constants.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';

Widget govtId() {
  return Container(
      height: xSize * 3,
      padding: const EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFF2EADD), Color(0xFFF9E2BB), Color(0xFFEEE3D1)], stops: [0, 0.7, 1], begin: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(xSize2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Image.asset("assets/images/indiaEmblem.png")),
          Text(
            "Govt ID",
            style: xTheme.textTheme.headlineMedium!.apply(color: xPrimary.withOpacity(0.8)),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ));
}