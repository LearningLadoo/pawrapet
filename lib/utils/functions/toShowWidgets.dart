import 'dart:ui';

import 'package:flutter/material.dart';
import '../extensions/sizedBox.dart';

import '../constants.dart';
import '../widgets/common.dart';

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

/// Helper method to show a SnackBar

enum MessageType { error, success, info }

void xSnackbar(BuildContext context, String message, {MessageType type = MessageType.info, Duration? duration}) {
  late Color fontColor;
  late Color bgColor;
  bgColor = Colors.grey;
  fontColor = Colors.white70;
  switch (type) {
    case MessageType.error:
      fontColor = xTheme.colorScheme.onError;
      bgColor = xTheme.colorScheme.error;
      break;
    case MessageType.success:
      break;
    default:
      break;
  }
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        padding: const EdgeInsets.all(xSize / 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(xSize1 / 2),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: xGlassBgEffect(
          bgColor: bgColor,
          borderRadius: xSize1,
          child: Padding(
            padding: const EdgeInsets.all(xSize1 / 2),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: xTheme.textTheme.labelMedium!.copyWith(color: fontColor),
            ),
          ),
        ),
        duration: duration ?? const Duration(milliseconds: 3000),
      ),
    );
}
