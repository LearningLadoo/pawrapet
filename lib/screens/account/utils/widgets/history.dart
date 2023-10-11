import 'package:flutter/material.dart';
import '/../utils/constants.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';

Widget history() {
  return Container(
    height: xSize * 3,
    padding: const EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 4),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFFd4d1cc), Color(0xFFe8e2db), Color(0xFFd4d1cc)], stops: [0, 0.5, 1], begin: Alignment.bottomLeft),
      borderRadius: BorderRadius.circular(xSize2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "History",
          style: xTheme.textTheme.headlineMedium!.apply(color: xPrimary.withOpacity(0.8)),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox().vertical(size: xSize / 16),
        Text(
          "Mating, Payments and more",
          overflow: TextOverflow.ellipsis,
          style: xTheme.textTheme.bodySmall!.apply(color: xPrimary.withOpacity(0.8), fontSizeDelta: -1),
        ),
      ],
    ),
  );
}