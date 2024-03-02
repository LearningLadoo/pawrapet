import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawrapet/screens/mating/utils/widgets/widgets.dart';
import 'package:pawrapet/utils/extensions/dateTime.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/widgets/displayText.dart';

import '../../../utils/constants.dart';
import '../../../utils/widgets/buttons.dart';
import '../../../utils/widgets/common.dart';

// so that the init or future builders are not called again for schedule 2
class Welcome4Final extends StatelessWidget {
  bool enabled;

  Welcome4Final(this.enabled, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return matingTile(children: [(enabled) ? const Welcome4() : welcome4Dummy()]);
  }
}

class Welcome4 extends StatefulWidget {
  const Welcome4({Key? key}) : super(key: key);

  @override
  State<Welcome4> createState() => _Welcome4State();
}

class _Welcome4State extends State<Welcome4> {
  late DateTime chosenDate;
  String matingPoint = "Center 1211 faridabad, Haryana";
  @override
  void initState() {
    chosenDate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'We can\'t wait to welcome you!',
          style: xTheme.textTheme.headlineMedium,
        ),
        const SizedBox().vertical(),
        xTextWithBold(
          "Upon your arrival, be sure to **scan the QR code** given to you by the Pawrapets representative. This will confirm your check-in.\nAlso make sure to **check the distance** to the **Pawrapet $matingPoint** beforehand.",
        ),
        const SizedBox().vertical(),
        Row(
          children: [
            Expanded(
              child: XRoundedButtonOutlined(
                onPressed: () {},
                text: "Open Map",
                textStyle: xTheme.textTheme.bodyMedium!.apply(color: xOnPrimary),
                enabled: true,
                color: xPrimary.withOpacity(0.7),
              ),
            ),
            const SizedBox().horizontal(),
            Expanded(
              child: XRoundedButton(
                onPressed: () {},
                text: "Scan QR",
                textStyle: xTheme.textTheme.bodyMedium!.apply(color: xOnPrimary),
                enabled: true,
                backgroundColor: xPrimary.withOpacity(0.8),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: xSize / 2),
          child: Text("Your time is ${DateFormat("hh:mm a").format(chosenDate)} on ${chosenDate.fullWithOrdinal()}", style: xTheme.textTheme.labelMedium),
        ),
      ],
    );
  }
}

Widget welcome4Dummy() {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.all(xSize / 2),
        child: Column(
          children: [
            Text(
              'We can\'t wait to welcome you!',
              style: xTheme.textTheme.headlineMedium,
            ),
            const SizedBox().vertical(),
            xTextWithBold(
              "Upon your arrival, be sure to **scan the QR code** given to you by the Pawrapets representative. This will confirm your check-in.\nAlso make sure to **check the distance** to the **Pawrapet center** beforehand.",
            ),
            const SizedBox().vertical(),
            Row(
              children: [
                Expanded(
                  child: XRoundedButtonOutlined(
                    onPressed: () {},
                    text: "Open Map",
                    textStyle: xTheme.textTheme.bodyMedium!.apply(color: xOnPrimary),
                    enabled: true,
                    color: xPrimary.withOpacity(0.7),
                  ),
                ),
                const SizedBox().horizontal(),
                Expanded(
                  child: XRoundedButton(
                    onPressed: () {},
                    text: "Scan QR",
                    textStyle: xTheme.textTheme.bodyMedium!.apply(color: xOnPrimary),
                    enabled: true,
                    backgroundColor: xPrimary.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: xSize / 2),
              child: Text("Your time is ${DateFormat("hh:mm a").format(DateTime.now())} on ${DateTime.now().fullWithOrdinal()}", style: xTheme.textTheme.labelMedium),
            ),
          ],
        ),
      ),
      Positioned.fill(child: xGlassBgEffect(child: lockWithHeading("4) We can't wait to welcome you!", "Please pay the advance to unlock this step, as it helps in avoiding scam profiles and enables us to provide you with best service."))),
    ],
  );
}
