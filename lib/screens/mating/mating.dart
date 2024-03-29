import 'package:flutter/material.dart';
import '../../utils/functions/common.dart';
import 'utils/0Result.dart';
import 'utils/1Preview.dart';
import 'utils/2Schedule.dart';
import 'utils/3AdvancePay.dart';
import 'utils/4Welcome.dart';
import 'utils/5FinalPay.dart';
import 'utils/6Feedback.dart';
import 'utils/widgets/bottomNavigator.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/appBar.dart';
import '../../firebase/firestore.dart';
import '../../utils/functions/idsChasKeys.dart';
import '../../utils/widgets/common.dart';

class Mating extends StatefulWidget {
  final String uidPN;
  final int flowStep; // 0 to 6 and -1 to fetch the latest flow step
  final Map<String, dynamic> profileMap;

  const Mating({Key? key, required this.flowStep, required this.uidPN, required this.profileMap}) : super(key: key);

  @override
  State<Mating> createState() => _MatingState();
}

class _MatingState extends State<Mating> {
  // managing flows
  late int flowIndex;
  late String sessionID;
  late String matingID;
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
    true,
    true,
    false,
    false,
    false,
  ];
  int activeFlow = 1;

  @override
  void initState() {
    flowIndex = widget.flowStep;
    // todo fetch the details of the user and build the following via future builder
    if (flowIndex == -1) {
      fetchSessionDetailsAndFlowIndex();
    }
    super.initState();
  }

  // Future<void> fetchFlowIndex() async {
  //   try {
  //     xPrint('${widget.sessionID}', header: "fetchFlowIndex");
  //
  //     Map<String, dynamic> map = (await FirebaseCloudFirestore().getCurrentMatingStage(widget.uidPN, getMatingId(widget.uidPN, xProfile!.uidPN), widget.sessionID!))!;
  //     flowIndex = map['currStage'];
  //     activeFlow = map['currStage'];
  //   } catch (e) {
  //     xPrint('$e', header: "fetchFlowIndex");
  //     flowIndex = 1;
  //   }
  //
  //   setState(() {});
  // }

  Future<void> fetchSessionDetailsAndFlowIndex() async {
    // get session id
    final doc = await FirebaseCloudFirestore().getMatingIDDetails(getMatingId(xProfile!.uidPN, widget.uidPN));
    if (doc != null) {
      sessionID = (doc.data() as Map<String, dynamic>)['activeSessionId'];
      // get the flow index
      try {
        xPrint('${sessionID}', header: "fetchSessionDetailsAndFlowIndex");
        Map<String, dynamic> map = (await FirebaseCloudFirestore().getCurrentMatingStage(widget.uidPN, getMatingId(widget.uidPN, xProfile!.uidPN), sessionID))!;
        flowIndex = map['currStage'];
        activeFlow = map['currStage'];
      } catch (e) {
        xPrint('$e', header: "fetchSessionDetailsAndFlowIndex");
        flowIndex = 1;
      }
    } else {
      // todo unhandled case
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            XAppBar(AppBarType.backWithHeading, title: "Mating with ${widget.profileMap['name']}"),
            if (flowIndex == -1) Expanded(child: dogWaitLoader("Fetching details..")),
            if (flowIndex == 0) Result0Final(false),
            if (flowIndex == 1) Preview1Final(profileMap: widget.profileMap),
            if (flowIndex == 2) Schedule2Final(activeFlow >= 2, frndsUidPN: widget.uidPN, frndsName: widget.profileMap['name'], sessionID: sessionID, matingID: getMatingId(widget.uidPN, xProfile!.uidPN)),
            if (flowIndex == 3) AdvancePay3Final(activeFlow >= 3, frndsUidPN: widget.uidPN, frndsName: widget.profileMap['name'], sessionID: sessionID, matingID: getMatingId(widget.uidPN, xProfile!.uidPN)),
            if (flowIndex == 4) Welcome4Final(true ?? activeFlow >= 4),
            if (flowIndex == 5) FinalPay5Final(true ?? activeFlow >= 5),
            if (flowIndex == 6) Feedback6Final(true ?? activeFlow >= 6),
            // bottom next back
            if (flowIndex != -1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: xSize / 2, vertical: xSize / 2),
                child: XBottomNavForSlide(
                  endInt: 6,
                  initialInt: flowIndex,
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
