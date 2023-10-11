import 'package:flutter/material.dart';
import '/../utils/constants.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';

Widget deleteAccount() {
  return GestureDetector(
    onTap: () {
      // todo show reconfirmation dialog
    },
    child: Container(
      height: xSize * 1.5,
      padding: const EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 4),
      decoration: BoxDecoration(
        color: xError.withOpacity(0.5),
        borderRadius: BorderRadius.circular(xSize2),
      ),
      child: Center(
          child: Text(
            "Delete the Account",
            style: TextStyle(
              color: xOnError.withOpacity(0.95),
            ),
          )),
    ),
  );
}