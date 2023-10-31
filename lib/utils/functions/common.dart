import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import '../constants.dart';

void xPrint(String? str, {String? header}){
  log("${header??""}: $str");
}
bool xContainsDate(List<DateTime> list, DateTime date){
  for (DateTime d in list){
    if(d.day == date.day && d.month == date.month && d.year == date.year) return true;
  }
  return false;
}

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
            bottomWidget??const Center()
          ]),
        ),
      );
    },
  );
}
