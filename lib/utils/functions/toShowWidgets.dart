import 'dart:ui';

import 'package:flutter/material.dart';
import '../extensions/sizedBox.dart';

import '../constants.dart';

Future<void> xShowDialog({required BuildContext context, required String heading, required String content, Widget? bottomWidget}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(xSize2),
        ),
        backgroundColor: xSecondary,
        child: Padding(
          padding: const EdgeInsets.all(xSize / 2),
          child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              heading,
              style: xTheme.textTheme.headlineMedium!.apply(fontWeightDelta: 0, color: xPrimary.withOpacity(0.9)),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox().vertical(size: xSize / 3),
            Text(
              content,
              style: xTheme.textTheme.bodyMedium!.apply(fontWeightDelta: -1, color: xPrimary.withOpacity(0.9)),
              textAlign: TextAlign.left,
            ),
            bottomWidget ?? const Center()
          ]),
        ),
      );
    },
  );
}
