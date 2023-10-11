import 'package:flutter/material.dart';
import 'package:pawrapet/utils/extensions/colors.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/widgets/buttons.dart';

class XBottomNavForSlide extends StatefulWidget {
  int endInt;
  int? initialInt;
  int? startInt;
  Function(int) onSlideChange;

  XBottomNavForSlide({Key? key, required this.endInt, required this.onSlideChange, this.initialInt, this.startInt}) : super(key: key);

  @override
  State<XBottomNavForSlide> createState() => _XBottomNavForSlideState();
}

class _XBottomNavForSlideState extends State<XBottomNavForSlide> {
  late int currInt, startInt, endInt;
  @override
  void initState() {
    currInt = widget.initialInt??0;
    startInt = widget.startInt??0;
    endInt = widget.endInt;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AbsorbPointer(
          absorbing: currInt==startInt,
          child: Opacity(
            opacity: currInt==startInt?0:1,
            child: XColoredButton(
              backgroundColor: Colors.blueGrey[300]!,
              text: "Back",
              onTap: () {
                setState(() {
                  currInt = --currInt;
                });
                widget.onSlideChange(currInt);
              },
            ),
          ),
        ),
        Expanded(
          child: Text(
            "$currInt/$endInt",
            style: xTheme.textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
        ),

        AbsorbPointer(
          absorbing: currInt==endInt,
          child: Opacity(
            opacity: currInt==endInt?0:1,
            child: XColoredButton(
              backgroundColor: xOnSecondary.getAdjustColor(70),
              text: "Next",
              onTap: () {
                setState(() {
                  currInt = ++currInt;
                });
                widget.onSlideChange(currInt);
              },
            ),
          ),
        ),
      ],
    );
  }
}
