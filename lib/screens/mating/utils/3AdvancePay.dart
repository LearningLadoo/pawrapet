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
class AdvancePay3Final extends StatelessWidget {
  bool enabled;

  AdvancePay3Final(this.enabled, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return matingTile(children: [(enabled) ? const AdvancedPay3() : advancePay3Dummy()]);
  }
}

class AdvancedPay3 extends StatefulWidget {
  const AdvancedPay3({Key? key}) : super(key: key);

  @override
  State<AdvancedPay3> createState() => _AdvancedPay3State();
}

class _AdvancedPay3State extends State<AdvancedPay3> {
  late DateTime chosenDate;
  int securityDeposit = 500;
  int paymentToPartner = 0;
  late int finalAmount;
  int paidAmount = 0;

  @override
  void initState() {
    chosenDate = DateTime.now().add(const Duration(minutes: 30));
    paidAmount = 0;
    finalAmount = (paymentToPartner / 2 + securityDeposit - paidAmount).round();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Pay security deposit and 50% advance.',
          style: xTheme.textTheme.headlineMedium,
        ),
        const SizedBox().vertical(),
        BulletText(
          textWidget: xTextWithBold(
            "If the pets are unable to mate by any chance at the schedule, the **advance will be refunded**.",
          ),
        ),
        BulletText(
          textWidget: xTextWithBold(
              "The **security deposit** will be **returned only** if you **reach** the allocated **center** within **30 minutes of delay**. That is **by ${DateFormat("hh:mm a").format(chosenDate)} on ${chosenDate.fullWithOrdinal()}**."),
        ),
        const Divider(
          height: xSize,
        ),
        Center(
          child: Opacity(
            opacity: 0.9,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                xTextWithBold(
                  "Security Deposit"
                  "${(paymentToPartner == 0) ? "" : "\n50% advance of ₹$paymentToPartner"}"
                  "${(paidAmount == 0) ? "" : "\nPaid Amount"}"
                  "\n**Total**",
                  style: xTheme.textTheme.labelLarge,
                ),
                SizedBox().horizontal(size: xSize / 4),
                xTextWithBold(
                  "="
                  "${(paymentToPartner == 0) ? "" : "\n="}"
                  "${(paidAmount == 0) ? "" : "\n="}"
                  "\n**=**",
                  style: xTheme.textTheme.labelLarge,
                ),
                SizedBox().horizontal(size: xSize / 4),
                xTextWithBold(
                  "+ ₹$securityDeposit"
                  "${(paymentToPartner == 0) ? "" : "\n+ ₹${(paymentToPartner * 0.5).round()}"}"
                  "${(paidAmount == 0) ? "" : "\n− ₹$paidAmount"}"
                  "\n**+ ₹$finalAmount**",
                  style: xTheme.textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ),
        const Divider(
          height: xSize,
        ),
        XRoundedButton(
          onPressed: () {},
          text: (finalAmount != 0) ? "Pay ₹$finalAmount" : "Paid",
          textStyle: xTheme.textTheme.bodyMedium!.apply(color: xOnPrimary),
          expand: true,
          enabled: (finalAmount != 0) ? true : false,
          backgroundColor: xPrimary.withOpacity(0.8),
        ),
      ],
    );
  }
}

Widget advancePay3Dummy() {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.all(xSize / 2),
        child: Column(
          children: [
            Text(
              'Pay security deposit and 50% advance.',
              style: xTheme.textTheme.headlineMedium,
            ),
            const SizedBox().vertical(),
            BulletText(
              textWidget: xTextWithBold(
                "If the pets are unable to mate by any chance at the schedule, the **advance will be refunded**.",
              ),
            ),
            BulletText(
              textWidget: xTextWithBold(
                  "The **security deposit** will be **returned only** if you **reach** the allocated **center** within **30 minutes of delay**. That is **by ${DateFormat("hh:mm a").format(DateTime.now())} on ${DateTime.now().fullWithOrdinal()}**."),
            ),
            const Divider(
              height: xSize,
            ),
            const Divider(
              height: xSize,
            ),
            XRoundedButton(
              onPressed: () {},
              text: "Pay ₹finalAmount",
              textStyle: xTheme.textTheme.bodyMedium!.apply(color: xOnPrimary),
              expand: true,
              enabled: true,
              backgroundColor: xPrimary.withOpacity(0.8),
            ),
          ],
        ),
      ),
      Positioned.fill(child: xGlassBgEffect(child: lockWithHeading("3) Pay security deposit and 50% advance.", "It will be unlocked when you and your partner finalize the date."))),
    ],
  );
}
