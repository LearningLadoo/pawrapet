import 'package:flutter/material.dart';
import '/../utils/constants.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';

Widget askAnything() {
  return Container(
    height: xSize * 3,
    padding: const EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 4),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFFdcdfd7), Color(0xFFd1d7d2), Color(0xFFe0ded5), Color(0xFFf6e3d2)], stops: [0, 0.5, 0.7, 1], begin: Alignment.bottomLeft),
      borderRadius: BorderRadius.circular(xSize2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Ask anything !",
          style: xTheme.textTheme.headlineMedium!.apply(color: xPrimary.withOpacity(0.8)),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox().vertical(size: xSize / 16),
        Text(
          "Can I give him banana?  How to remove ticks?",
          overflow: TextOverflow.ellipsis,
          style: xTheme.textTheme.bodySmall!.apply(color: xPrimary.withOpacity(0.8), fontSizeDelta: -1),
        ),
      ],
    ),
  );
}