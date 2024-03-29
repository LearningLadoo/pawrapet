import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
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

import '../../../firebase/firestore.dart';
import '../../../utils/constants.dart';
import '../../../utils/widgets/common.dart';
import '../../../utils/widgets/displayText.dart';

// so that the init or future builders are not called again for schedule 2
class Schedule2Final extends StatelessWidget {
  bool enabled;
  String frndsUidPN;
  String frndsName;
  String? sessionID;
  String matingID;

  Schedule2Final(this.enabled, {super.key, required this.frndsUidPN, required this.frndsName, required this.sessionID, required this.matingID});

  @override
  Widget build(BuildContext context) {
    return matingTile(children: [(enabled && sessionID != null) ? Schedule2(frndsName: frndsName, frndsUidPN: frndsUidPN, sessionID: sessionID!, matingID: matingID) : schedule2Dummy()]);
  }
}

///
/// so at first a date will be chosen for approval automatically from the server
/// if you are not available then you can choose the date and time from the available dates of the center
/// then you send the proposal
/// then samne wala can accept or ask for another date
///
/// {
/// "dd/MM/yyyy":{
///   "time": List<unavailable, onHold, booked, available> DateFormat("hh:mm a") // unavailable means the center is unavailable, the length of the list defines the available slots at that time
///   }
/// }
class Schedule2 extends StatefulWidget {
  String frndsUidPN;
  String frndsName;
  String sessionID;
  String matingID;

  Schedule2({super.key, required this.frndsUidPN, required this.frndsName, required this.sessionID, required this.matingID});

  @override
  State<Schedule2> createState() => _Schedule2State();
}

class _Schedule2State extends State<Schedule2> {
  late Map<String,dynamic> matingPoint;
  late int scheduleCreationId;
  late DateTime chosenDate;
  Map<String, dynamic> availableDatesPlatform = {};
  List<DateTime> availableDates = [];
  Map<String, dynamic> dummyMap = {
    "08:00 AM": ["onHold"],
    "09:30 AM": ["onHold"],
    "11:00 AM": ["booked"],
    "12:30 PM": ["available"],
    "02:00 PM": ["unavailable"],
    "03:30 PM": ["unavailable"],
    "05:00 PM": ["onHold"],
    "06:30 PM": ["available"],
    "08:00 PM": ["available"],
  };
  Map<String, dynamic> dummyMap2 = {
    "08:00 AM": ["booked"],
    "09:30 AM": ["booked"],
    "11:00 AM": ["booked"],
    "12:30 PM": ["booked"],
    "02:00 PM": ["booked"],
    "03:30 PM": ["unavailable"],
    "05:00 PM": ["booked"],
    "06:30 PM": ["booked"],
    "08:00 PM": ["booked"],
  };
  Map<String, dynamic> dummyMap3 = {
    "08:00 AM": ["available"],
    "09:30 AM": ["unavailable"],
    "11:00 AM": ["unavailable"],
    "12:30 PM": ["unavailable"],
    "02:00 PM": ["available"],
    "03:30 PM": ["unavailable"],
    "05:00 PM": ["unavailable"],
    "06:30 PM": ["unavailable"],
    "08:00 PM": ["unavailable"],
  };

  /// status
  /// [currStatus] is 0 for system generated date
  /// [currStatus] is 1 for choosing and proposing own date
  /// [currStatus] is 2 for accepting the proposed date by partner
  /// [currStatus] is 3 for waiting for partners confirmation
  /// [currStatus] is 4 for confirmation successful
  int currStatus = 0;

  @override
  void initState() {
    // todo get the dates from the api and implement in future builder not here, or what about using realtime database ? idk lets ee
    availableDatesPlatform = {
      "04/10/2023": dummyMap,
      "05/10/2023": dummyMap2,
      "06/10/2023": dummyMap,
      "07/10/2023": dummyMap3,
      "08/10/2023": dummyMap,
      "09/10/2023": dummyMap,
      "10/10/2023": dummyMap2,
      "11/10/2023": dummyMap,
      "12/10/2023": dummyMap,
      "03/04/2024": dummyMap,
    };
    // make it onHold and get it from server
    try {
      for (String date in availableDatesPlatform.keys) {
        for (String time in availableDatesPlatform[date].keys) {
          if (availableDatesPlatform[date][time].toList().contains("available")) {
            availableDates.add(DateTime(0).fromddMMyyyyhhmm("$date $time"));
          }
        }
      }
    } catch (e) {
      xPrint(e.toString());
    }
    updateScheduleSessionDetails();
    super.initState();
  }

  Future<void> updateScheduleSessionDetails() async{
    currStatus = -1;
    final map = await FirebaseCloudFirestore().getScheduleSessionDetails(widget.matingID, widget.sessionID);
    if(map!=null){
      updateVariables(map);
      setState(() {});
    }

  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: updateScheduleSessionDetails,
      child: Column(
        children: [
          if (currStatus == -1) const LinearProgressIndicator(),
          if (currStatus == 0) ...autoScheduledWidget(),
          if (currStatus == 1) ...proposeYourSchedule(),
          if (currStatus == 2) ...partnersProposedSchedule(),
          if (currStatus == 3) ...waitingForPartnersConfirmation(),
          if (currStatus == 4) ...confirmationWidget(),
        ],
      ),
    );
  }

  void updateVariables(Map sessionDetails) {
    try {
      xPrint("$sessionDetails", header: "updateVariables");
      Map<String, dynamic> currMap = Map<String, dynamic>.from(sessionDetails['scheduleLog']['current'] ?? {});
      // update the chosen date
      xPrint("1 $currMap", header: "updateVariables");
      chosenDate = DateTime(0).fromddMMyyyyhhmm("${currMap["proposedDate"]} ${currMap["proposedTime"]}");
      // mating point
      xPrint("2 ${chosenDate.toString()} ${chosenDate.toddMMyyyy()}", header: "updateVariables");

      matingPoint = allMatingPoints[currMap['proposedCenter']];
      xPrint("3 $matingPoint", header: "updateVariables");
// id
      scheduleCreationId = currMap['creationID'];
      // update the currState
      if (currMap['proposedBy'] == 'auto') currStatus = 0;
      xPrint("4 $currStatus", header: "updateVariables");

      if (currMap['proposedBy'] == widget.frndsUidPN) currStatus = 2;
      xPrint("5 $currStatus", header: "updateVariables");

      if (currMap[xProfile!.uidPN] == true) currStatus = 3;
      xPrint("6 $currStatus", header: "updateVariables");

      if (currMap[xProfile!.uidPN] == true && currMap[widget.frndsUidPN] == true) currStatus = 4;
      xPrint("7 $currStatus", header: "updateVariables");
    } catch (e) {
      xPrint("$e", header: 'updateVariables');
    }
  }

  List<Widget> autoScheduledWidget() {
    return [
      Text(
        'Schedule The Mating Day',
        style: xTheme.textTheme.headlineMedium,
      ),
      const SizedBox().vertical(),
      xTextWithBold("The meeting is scheduled for **${DateFormat("hh:mm a").format(chosenDate)}** on **${chosenDate.fullWithOrdinal()}** at **${matingPoint['name']}**. Kindly confirm it."),
      const SizedBox().vertical(),
      XRoundedButton(
        onPressed: () async {
          setState(() {
            currStatus = -1;
          });
          if (await FirebaseCloudFirestore().confirmSchedule(widget.matingID, widget.sessionID, xProfile!.uidPN, scheduleCreationId)) {
            setState(() {
              currStatus = 3;
            });
          } else {
            // todo handle error
          }
        },
        text: "Confirm",
        textStyle: xTheme.textTheme.bodyMedium!.apply(color: xOnPrimary),
        expand: true,
        backgroundColor: xPrimary.withOpacity(0.8),
      ),
      InkWell(
        onTap: () {
          setState(() {
            currStatus = 1;
          });

        },
        child: Padding(
          padding: const EdgeInsets.only(top: xSize / 2),
          child: Text("Not available on day?", style: xTheme.textTheme.labelMedium),
        ),
      ),
    ];
  }

  List<Widget> proposeYourSchedule() {
    return [
      Text(
        'Choose The Mating Day',
        style: xTheme.textTheme.headlineMedium,
      ),
      const SizedBox().vertical(),
      Text(
        'Please select the date you are available for mating with ${widget.frndsName}.',
        style: xTheme.textTheme.bodyMedium,
      ),
      const SizedBox().vertical(),
      XDayPicker(
        initialDate: chosenDate,
        availableDates: availableDates,
        onChanged: (d) {
          for (DateTime i in availableDates) {
            if (i.isSameDate(d)) {
              d = i; // this also gives the initial available time
              break;
            }
          }
          setState(() {
            chosenDate = d;
          });
        },
      ),
      const SizedBox().vertical(),
      Wrap(
        runSpacing: xSize / 2,
        spacing: xSize / 2,
        children: availableDatesPlatform[chosenDate.toddMMyyyy()].keys.map<Widget>((time) {
          DateTime tempDateTime = DateFormat('hh:mm a').parse(time);
          tempDateTime = tempDateTime.getWithSameDate(chosenDate);
          bool available = availableDates.contains(tempDateTime);
          xPrint("$chosenDate $tempDateTime $time");
          return Opacity(
            opacity: (available) ? 1 : 0.3,
            child: XColoredButton(
              backgroundColor: xPrimary.withOpacity(0.1),
              text: "$time",
              textStyle: xTheme.textTheme.labelLarge,
              padding: const EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 4),
              invert: tempDateTime == chosenDate,
              invertedTextColor: xOnPrimary.withOpacity(0.8),
              onTap: () {
                if (available) {
                  setState(() {
                    chosenDate = tempDateTime;
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
      const SizedBox().vertical(),
      xTextWithBold(
          "You have chosen the scheduled for **${DateFormat("hh:mm a").format(chosenDate)}** on **${chosenDate.fullWithOrdinal()}** at **${matingPoint['name']}**. Kindly send the proposal for ${widget.frndsName} to confirm it."),
      const SizedBox().vertical(),
      XRoundedButton(
        onPressed: () async {
          setState(() {
            currStatus = -1;
          });
          // wait for it and make the curr state
          if (await FirebaseCloudFirestore().sendScheduleProposal(widget.matingID, widget.sessionID, xProfile!.uidPN, matingPoint['code'],chosenDate.toddMMyyyy(), chosenDate.tohhmma())) {
            setState(() {
              currStatus = 3;
            });
          } else {
            // todo handle error
          }
        },
        text: "Send Proposal",
        textStyle: xTheme.textTheme.bodyMedium!.apply(color: xOnPrimary),
        expand: true,
        backgroundColor: xPrimary.withOpacity(0.8),
      ),
    ];
  }

  List<Widget> partnersProposedSchedule() {
    return [
      Text(
        'Changes in Scheduled Date',
        style: xTheme.textTheme.headlineMedium,
      ),
      const SizedBox().vertical(),
      xTextWithBold(
          "Unfortunately, ${widget.frndsName} won't be available on the scheduled date. ${widget.frndsName} is inquiring if you're free at **${DateFormat("hh:mm a").format(chosenDate)}** on **${chosenDate.fullWithOrdinal()}** at the **${matingPoint['name']}**. Kindly confirm to proceed."),
      const SizedBox().vertical(),
      XRoundedButton(
        onPressed: () async {
          setState(() {
            currStatus = -1;
          });
          // todo wait for the it and make the curr state
          await Future.delayed(Duration(seconds: 5));
          setState(() {
            currStatus = 3;
          });
        },
        text: "Confirm",
        textStyle: xTheme.textTheme.bodyMedium!.apply(color: xOnPrimary),
        expand: true,
        backgroundColor: xPrimary.withOpacity(0.8),
      ),
      InkWell(
        onTap: () {
          currStatus = 1;
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.only(top: xSize / 2),
          child: Text("Not available on day?", style: xTheme.textTheme.labelMedium),
        ),
      ),
    ];
  }

  List<Widget> waitingForPartnersConfirmation() {
    return [
      Text(
        'Waiting for Confirmation',
        style: xTheme.textTheme.headlineMedium,
      ),
      const SizedBox().vertical(),
      xTextWithBold("Waiting for ${widget.frndsName} to confirm the schedule of **${DateFormat("hh:mm a").format(chosenDate)}** on **${chosenDate.fullWithOrdinal()}** at **${matingPoint['name']}**."),
      const SizedBox().vertical(),
      XRoundedButton(
        onPressed: () {},
        text: "Waiting..",
        textStyle: xTheme.textTheme.bodyMedium!.apply(color: xOnPrimary),
        expand: true,
        enabled: false,
        backgroundColor: xPrimary.withOpacity(0.8),
      ),
    ];
  }

  List<Widget> confirmationWidget() {
    return [
      Text(
        'Confirmation Successful',
        style: xTheme.textTheme.headlineMedium,
      ),
      const SizedBox().vertical(),
      xTextWithBold("The schedule for **${DateFormat("hh:mm a").format(chosenDate)}** on **${chosenDate.fullWithOrdinal()}** at **${matingPoint['name']}** has been confirmed."),
    ];
  }
}

Widget schedule2Dummy() {
  return Stack(
    children: [
      Padding(
        padding: EdgeInsets.all(xSize / 2),
        child: Column(children: [
          Text(
            'Schedule The Mating Day',
            style: xTheme.textTheme.headlineMedium,
          ),
          const SizedBox().vertical(),
          xTextWithBold("The meeting is scheduled for on at. Kindly confirm it."),
          const SizedBox().vertical(),
          XRoundedButton(
            onPressed: () {},
            text: "Confirm",
            textStyle: xTheme.textTheme.bodyMedium!.apply(color: xOnPrimary),
            expand: true,
            enabled: false,
            backgroundColor: xPrimary.withOpacity(0.8),
          ),
          Padding(
            padding: const EdgeInsets.only(top: xSize / 2),
            child: Text("Not available on day?", style: xTheme.textTheme.labelMedium),
          ),
        ]),
      ),
      Positioned.fill(child: xGlassBgEffect(child: lockWithHeading("2) Schedule The Mating Day", "It will be unlocked once both you request to mate with each other."))),
    ],
  );
}
