import 'package:flutter/material.dart';
import 'package:pawrapet/screens/mating/utils/0Result.dart';
import 'package:pawrapet/screens/mating/utils/1Preview.dart';
import 'package:pawrapet/screens/mating/utils/2Schedule.dart';
import 'package:pawrapet/screens/mating/utils/3AdvancePay.dart';
import 'package:pawrapet/screens/mating/utils/4Welcome.dart';
import 'package:pawrapet/screens/mating/utils/5FinalPay.dart';
import 'package:pawrapet/screens/mating/utils/6Feedback.dart';
import 'package:pawrapet/screens/mating/utils/widgets/bottomNavigator.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/widgets/appBar.dart';

class Mating extends StatefulWidget {
  final String username;
  final int flowStep;// 0 to 6 and -1 to fetch the latest flow step
  const Mating({Key? key, required this.flowStep, required this.username}) : super(key: key);

  @override
  State<Mating> createState() => _MatingState();
}

class _MatingState extends State<Mating> {
  late String name ;
  late String userName;
  // managing flows
  late int flowIndex;
  List<String> disabledFlowMessage = [
    'Sorry, no previous mating found. Once you completer the mating process you can see it here.',
    '',
    'It will be unlocked once both you request to mate with each other.',
    'Waiting for you and your partner to finalize the date.',
    'Please pay the advance before proceeding to next step, as it helps us filter out fake or scam profiles.',
    'Scan the QR code to unlock this.',
    'It will be unlocked on its own once the mating session completes.',
  ];
  List<bool> flowEnabled = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  @override
  void initState() {
    flowIndex = widget.flowStep;
    userName = widget.username;
    // todo fetch the details of the user and build the following via future builder
    if(flowIndex ==-1){
      // todo fetch the current flow index
    }
    name = "kkk";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            XAppBar(AppBarType.backWithHeading, title: "Mating with $name"),
            if (flowIndex == 0) Result0Final(flowEnabled[0]),
            if (flowIndex == 1) Preview1Final(),
            if (flowIndex == 2) Schedule2Final(flowEnabled[2]),
            if (flowIndex == 3) AdvancePay3Final(flowEnabled[3]),
            if (flowIndex == 4) Welcome4Final(flowEnabled[4]),
            if (flowIndex == 5) FinalPay5Final(flowEnabled[5]),
            if (flowIndex == 6) Feedback6Final(flowEnabled[6]),
            // bottom next back
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: xSize / 2, vertical: xSize / 2),
              child: XBottomNavForSlide(
                endInt: 6,
                initialInt: 1,
                onSlideChange: (i) {
                  setState(() {
                    flowIndex = i;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
