import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawrapet/screens/mating/utils/widgets/widgets.dart';
import 'package:pawrapet/utils/extensions/colors.dart';
import 'package:pawrapet/utils/extensions/dateTime.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/functions/common.dart';
import 'package:pawrapet/utils/widgets/buttons.dart';
import 'package:pawrapet/utils/widgets/datePicker.dart';
import 'package:pawrapet/utils/widgets/inputFields.dart';

import '../../../utils/constants.dart';
import '../../../utils/widgets/common.dart';

// so that the init or future builders are not called again for schedule 2
class Result0Final extends StatelessWidget {
  bool enabled;

  Result0Final(this.enabled, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return matingTile(children: [(enabled) ? Result0() : result0Dummy()]);
  }
}

///
///
class Result0 extends StatefulWidget {
  Result0({Key? key}) : super(key: key);

  @override
  State<Result0> createState() => _Result0State();
}

class _Result0State extends State<Result0> {
  /// status
  /// [matingStatuses] is 0 for mating completed
  /// [matingStatuses] is 1 for mating successful
  /// [matingStatuses] is 2 for mating failed
  List<int> matingStatuses = [0, 2, 1];
  bool matingUnderProcess = true;

  @override
  void initState() {
    // todo get the map of matting statuses
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...matingStatuses.map((e) => Padding(padding: EdgeInsets.only(bottom: xSize / 2), child: pastMatingTile(e, DateTime.now()))).toList(),
        XRoundedButton(
          onPressed: () {},
          text: matingUnderProcess ? "Waiting..." : "Request Again",
          textStyle: xTheme.textTheme.bodyMedium!.apply(color: xOnPrimary),
          expand: true,
          enabled: !matingUnderProcess,
          backgroundColor: xPrimary.withOpacity(0.8),
        ),
      ],
    );
  }
}

Widget pastMatingTile(int status, DateTime date) {
  late String heading, info;
  switch (status) {
    case 0:
      heading = "Mating Completed!";
      info = "Waiting for pregnancy results...";
      break;
    case 1:
      heading = "Mating Successful!";
      info = "Congratulations, successful pregnancy!";
      break;
    case 2:
      heading = "Mating Completed!";
      info = "Pregnancy failed";
      break;
  }
  return Container(
    padding: EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 2),
    decoration: BoxDecoration(
      color: xSecondary.withOpacity(0.5),
      borderRadius: BorderRadius.circular(xSize2),
    ),
    child: Column(
      children: [
        Text(
          heading,
          style: xTheme.textTheme.headlineMedium,
        ),
        const SizedBox().vertical(size: xSize / 4),
        Container(
          width: xWidth,
          padding: EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 4),
          decoration: BoxDecoration(
            color: xOnPrimary.withOpacity(0.6),
            borderRadius: BorderRadius.circular(xSize2),
          ),
          child: Text(
            info,
            style: xTheme.textTheme.labelMedium!.apply(color: xPrimary.withOpacity(0.6)),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox().vertical(size: xSize / 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            date.fullWithOrdinal(),
            style: xTheme.textTheme.labelMedium!.apply(color: xPrimary.withOpacity(0.6)),
          ),
        ),
      ],
    ),
  );
}

Widget result0Dummy() {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.all(xSize/2),
        child: Column(
          children: [
            ...[0,1].map((e) => Padding(padding: EdgeInsets.only(bottom: xSize / 2), child: pastMatingTile(e, DateTime.now()))).toList(),
            XRoundedButton(
              onPressed: () {},
              text: "Request Again",
              textStyle: xTheme.textTheme.bodyMedium!.apply(color: xOnPrimary),
              expand: true,
              enabled: true,
              backgroundColor: xPrimary.withOpacity(0.8),
            ),
          ],
        ),
      ),
      Positioned.fill(child: xGlassBgEffect(child: lockWithHeading("Past Matings", "No past matings found with Scooby, come back here once you have completed the mating process"))),
    ],
  );
}
