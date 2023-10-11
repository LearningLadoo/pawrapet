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
class FinalPay5Final extends StatelessWidget {
  bool enabled;

  FinalPay5Final(this.enabled, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return matingTile(children: [(enabled) ? const FinalPay5() : finalPay5Dummy()]);
  }
}

class FinalPay5 extends StatefulWidget {
  const FinalPay5({Key? key}) : super(key: key);

  @override
  State<FinalPay5> createState() => _FinalPay5State();
}

class _FinalPay5State extends State<FinalPay5> {
  late DateTime chosenDate;
  int securityDeposit = 500;
  int paymentToPartner = 1200;
  int paymentByPartner = 0; // take platform charges on this

  late int finalAmount;
  int paidAmount = 0; // +ve when the primary user has paid and -ve when he has received

  @override
  void initState() {
    chosenDate = DateTime.now().add(const Duration(minutes: 30));
    paidAmount = 0;
    finalAmount = (paymentToPartner / 2 - securityDeposit - paymentByPartner + paymentByPartner * 0.1 - paidAmount).round();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Final payment',
          style: xTheme.textTheme.headlineMedium,
        ),
        const SizedBox().vertical(),
        Text(
          'Finalize payment to start the mating process',
          style: xTheme.textTheme.bodyMedium,
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
                  "Return of Security Deposit"
                  "${(paymentToPartner == 0) ? "" : "\n50% pending of ₹$paymentToPartner"}"
                  "${(paymentByPartner == 0) ? "" : "\nPayment by Scooby"}"
                  "${(paymentByPartner == 0) ? "" : "\n10% platform charges"}"
                  "${(paidAmount == 0) ? "" : "\nPaid Amount"}"
                  "\n**Total**",
                  style: xTheme.textTheme.labelLarge,
                ),
                SizedBox().horizontal(size: xSize / 4),
                xTextWithBold(
                  "="
                  "${(paymentToPartner == 0) ? "" : "\n="}"
                  "${(paymentByPartner == 0) ? "" : "\n="}"
                  "${(paymentByPartner == 0) ? "" : "\n="}"
                  "${(paidAmount == 0) ? "" : "\n="}"
                  "\n**=**",
                  style: xTheme.textTheme.labelLarge,
                ),
                SizedBox().horizontal(size: xSize / 4),
                xTextWithBold(
                  "− ₹$securityDeposit"
                  "${(paymentToPartner == 0) ? "" : "\n+ ₹${(paymentToPartner * 0.5).round()}"}"
                  "${(paymentByPartner == 0) ? "" : "\n− ₹${(paymentByPartner).round()}"}"
                  "${(paymentByPartner == 0) ? "" : "\n+ ₹${(paymentByPartner * 0.1).round()}"}"
                  "${paidAmount == 0 ? "" : (paidAmount > 0 ? "\n− ₹$paidAmount" : "\n+ ₹${paidAmount * -1}")}"
                  "\n**${finalAmount >= 0 ? "+ ₹$finalAmount" : "− ₹${finalAmount * -1}"}**",
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
          text: (finalAmount != 0) ? (finalAmount > 0 ? "Pay $finalAmount" : "Get ${finalAmount * -1}") : "Paid",
          textStyle: xTheme.textTheme.bodyMedium!.apply(color: xOnPrimary),
          expand: true,
          enabled: (finalAmount != 0) ? true : false,
          backgroundColor: xPrimary.withOpacity(0.8),
        ),
      ],
    );
  }
}

Widget finalPay5Dummy() {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.all(xSize / 2),
        child: Column(
          children: [
            Text(
              'Final Payment',
              style: xTheme.textTheme.headlineMedium,
            ),
            const SizedBox().vertical(),
            Text(
              'Finalize payment to start the mating process',
              style: xTheme.textTheme.bodyMedium,
            ),
            const Divider(
              height: xSize,
            ),
            SizedBox().vertical(size: xSize*2),
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
      Positioned.fill(child: xGlassBgEffect(child: lockWithHeading("5) Final Payment", "Scan the QR code to unlock this step"))),
    ],
  );
}
