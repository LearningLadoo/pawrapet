import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawrapet/screens/mating/utils/widgets/widgets.dart';
import 'package:pawrapet/utils/extensions/dateTime.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/functions/common.dart';
import 'package:pawrapet/utils/widgets/displayText.dart';
import 'package:pawrapet/utils/widgets/inputFields.dart';

import '../../../utils/constants.dart';
import '../../../utils/widgets/buttons.dart';
import '../../../utils/widgets/common.dart';

// so that the init or future builders are not called again for schedule 2
class Feedback6Final extends StatelessWidget {
  bool enabled;

  Feedback6Final(this.enabled, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return matingTile(children: [(enabled) ? const Feedback6() : feedback6Dummy()]);
  }
}

class Feedback6 extends StatefulWidget {
  const Feedback6({Key? key}) : super(key: key);

  @override
  State<Feedback6> createState() => _Feedback6State();
}

class _Feedback6State extends State<Feedback6> {
  String feedback = "";
  bool submitted = false;
  int? rating; // 1-5
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Feedback',
          style: xTheme.textTheme.headlineMedium,
        ),
        const SizedBox().vertical(),
        XTextField(
          hintText: "\n\nEnter your feedback\n\n",
          textInputAction: TextInputAction.done,
          initialValue: feedback,
          keyboardType: TextInputType.text,
          lines: 5,
          autofillHints: ["Smooth process", "Professional", "Great", "Satisfied", "Organised", "Scope of improved"],
          onChangedFn: (String? value) {
            setState(() {
              feedback = value ?? "";
            });
          },
          onEditingComplete: () {
          },
        ),
        const SizedBox().vertical(),
        Rating(onChanged: (r){
          setState(() {
            rating = r;
          });
        }, initialRating: rating),
        const SizedBox().vertical(),
        XRoundedButton(
          onPressed: () {},
          text: (submitted) ? "Submitted" : "Submit",
          textStyle: xTheme.textTheme.bodyMedium!.apply(color: xOnPrimary),
          expand: true,
          enabled: (feedback != "" && !submitted && rating!=null),
          backgroundColor: xPrimary.withOpacity(0.8),
        ),
      ],
    );
  }
}

Widget feedback6Dummy() {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.all(xSize / 2),
        child: Column(
          children: [
            Text(
              'Feedback',
              style: xTheme.textTheme.headlineMedium,
            ),
            const SizedBox().vertical(),
            XTextField(
              hintText: "\n\nEnter your feedback\n\n",
              textInputAction: TextInputAction.done,
              initialValue: "",
              keyboardType: TextInputType.text,
              lines: 5,
              autofillHints: ["Smooth process", "Professional", "Great", "Satisfied", "Organised", "Scope of improved"],
              onChangedFn: (String? value) {
              },
              onEditingComplete: () {
              },
            ),
            const SizedBox().vertical(),
            Rating(onChanged: (r){
            }, initialRating: 5),
            const SizedBox().vertical(),
            XRoundedButton(
              onPressed: () {},
              text: "Submit",
              textStyle: xTheme.textTheme.bodyMedium!.apply(color: xOnPrimary),
              expand: true,
              enabled: true,
              backgroundColor: xPrimary.withOpacity(0.8),
            ),
          ],
        ),
      ),
      Positioned.fill(child: xGlassBgEffect(child: lockWithHeading("6) Feedback", "It will be unlocked on its own once the mating session completes."))),
    ],
  );
}
