import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import '../../../../utils/constants.dart';

Widget stickyDateHeader(DateTime dt) {
  return Row(
    children: [
      CircleAvatar(
        backgroundColor: xSecondary,
        radius: xSize * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('dd').format(dt),
              style: xTheme.textTheme.labelLarge!.apply(color: xPrimary.withOpacity(0.6), heightFactor: 0.8),
            ),
            Text(
              DateFormat('MMM').format(dt),
              style: xTheme.textTheme.labelSmall!.apply(color: xPrimary.withOpacity(0.8)),
            ),
          ],
        ),
      ),
      const Expanded(child: Center()),
    ],
  );
}

Widget sliverContentChild({Widget? previewImage, required DateTime dt, String? text}) {
  return Container(
    padding: const EdgeInsets.all(xSize / 4).copyWith(bottom: xSize / 8),
    margin: const EdgeInsets.only(bottom: xSize / 4, left: xSize * 0.6 * 2 + xSize / 4),
    decoration: BoxDecoration(
      color: const Color(0xffEEDEC2).withOpacity(0.7),
      borderRadius: BorderRadius.circular(xSize2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // todo ### come back here again to yaha par preview dalna hai, for image and pdf
        if(previewImage!=null)ConstrainedBox(
          constraints: const BoxConstraints(minHeight: xSize * 3),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(xSize / 4), bottom: Radius.circular(xSize / 10)),
            child: previewImage
          ),
        ),
        const SizedBox().vertical(size: xSize / 8),
        if (text != null)
          Text(
            text,
            style: xTheme.textTheme.bodySmall!.apply(fontSizeDelta: -2, color: xPrimary.withOpacity(0.95)),
          ),
        Text(
          "${DateFormat('hh:mm a').format(dt)}",
          textAlign: TextAlign.right,
          style: xTheme.textTheme.labelSmall!.apply(
            color: xPrimary.withOpacity(0.5),
          ),
        )
      ],
    ),
  );
}
