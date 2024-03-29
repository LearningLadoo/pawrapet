import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawrapet/screens/mating/utils/widgets/widgets.dart';
import 'package:pawrapet/utils/extensions/dateTime.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/widgets/displayText.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../firebase/firestore.dart';
import '../../../firebase/functions.dart';
import '../../../providers/authProvider.dart';
import '../../../utils/constants.dart';
import '../../../utils/functions/common.dart';
import '../../../utils/functions/toShowWidgets.dart';
import '../../../utils/widgets/buttons.dart';
import '../../../utils/widgets/common.dart';

// so that the init or future builders are not called again for schedule 2
class AdvancePay3Final extends StatelessWidget {
  bool enabled;
  String frndsUidPN;
  String frndsName;
  String? sessionID;
  String matingID;

  AdvancePay3Final(this.enabled, {super.key, required this.frndsUidPN, required this.frndsName, required this.sessionID, required this.matingID});

  @override
  Widget build(BuildContext context) {
    return matingTile(children: [(enabled && sessionID != null) ? AdvancedPay3(frndsName: frndsName, frndsUidPN: frndsUidPN, sessionID: sessionID!, matingID: matingID) : advancePay3Dummy()]);
  }
}

class AdvancedPay3 extends StatefulWidget {
  String frndsUidPN;
  String sessionID;
  String matingID;
  String frndsName;

  AdvancedPay3({super.key, required this.frndsUidPN, required this.frndsName, required this.sessionID, required this.matingID});

  @override
  State<AdvancedPay3> createState() => _AdvancedPay3State();
}

class _AdvancedPay3State extends State<AdvancedPay3> {
  late DateTime chosenDate;
  int securityDeposit = 500;
  int paymentToPartner = 0;
  late int finalAmount;
  int paidAmount = 0;
  final _razorpay = Razorpay();
  Map<String, dynamic> orderMap = {};
  bool payInitiated = false;
  bool payError = false;

  @override
  void initState() {
    payError = false;
    chosenDate = DateTime.now().add(const Duration(minutes: 30));
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Do something when payment succeeds
    String? resData = (await FirebaseCloudFunctions().verifySecurityPayAndUpdateCloud(xProfile!.uidPN, response.orderId!, widget.sessionID, true))?.body;
    xPrint("handle payment ${resData} ${response.orderId} ${response.data}", header: "AdvancedPay3");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    xPrint("error in payment ${response.error}", header: "AdvancedPay3");
    setState(() {
      payError = true;
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // success, pending, failed, null
  Future<String> fetchTheOrderDetailsAndReturnPayStatus() async {
    paidAmount = 0;
    String output = "initiated";
    String? resData = (await FirebaseCloudFunctions().getSecurityPayOrderIdAndDetails(xProfile!.uidPN, widget.frndsUidPN, widget.sessionID))?.body;
    xPrint("the resposene is $resData", header: "AdvancedPay3");
    orderMap = jsonDecode(resData!);
    // todo handle error
    if (orderMap['error'] != null) {
      xSnackbar(context, "Please try again later");
    } else if (orderMap['orderStatus'] == "paid") {
      // todo call for verification
      String? res = (await FirebaseCloudFunctions().verifySecurityPayAndUpdateCloud(xProfile!.uidPN, orderMap['orderId']!, widget.sessionID, false))?.body;
      xPrint("handle payment res $res", header: "AdvancedPay3");
      Map<String, dynamic> resMap = jsonDecode(res!);
      output = resMap['status'];
      paidAmount = 500;
    }
    finalAmount = (paymentToPartner / 2 + securityDeposit - paidAmount).round();
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchTheOrderDetailsAndReturnPayStatus(),
        builder: (context, snap) {
          xPrint("the snap data ${snap.hasData} ${snap.data}", header: "AdvancedPay3");
          if (snap.hasData) {
            switch (snap.data) {
              case "success":
                return payAmount("Paid", false);
              case "pending":
                return payAmount("Verifying...", false);
              case "failed":
              case "initiated":
                return payAmount("Pay ₹$finalAmount", true);
              default:
                return xErrorText(context, "Unhandled case");
            }
          } else {
            return const LinearProgressIndicator();
          }
        });
  }

  Widget payAmount(String buttonText, bool buttonEnabled) {
    return Column(
      children: [
        Text(
          'Pay security deposit',
          style: xTheme.textTheme.headlineMedium,
        ),
        const SizedBox().vertical(),
        BulletText(
          textWidget: xTextWithBold(
              "The **security deposit** will be **returned only** if you **reach** the allocated **center** within **30 minutes of delay**. That is **by ${DateFormat("hh:mm a").format(chosenDate)} on ${chosenDate.fullWithOrdinal()}**."),
        ),
        BulletText(
          textWidget: xTextWithBold(
              "If you are **unable to arrive** within the designated timeframe, your security deposit will be **equally transferred** to **${widget.frndsName}** (your mating partner) and the **mating center** as inconvenience fees."),
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
        (payInitiated)
            ? LinearProgressIndicator()
            : AbsorbPointer(
          absorbing: !buttonEnabled,
              child: XRoundedButton(
                  onPressed: () async {
                    // todo $start here, to save the orderID in local as current active payments and remove it once the details are added in the server
                    // flow
                    // get order id from server
                    // todo add order id in local storage; is it really needed now because we have a unique order id for each session
                    // open razorpay payment with details
                    // todo do this after the setting up other things poll from api until the payment is either success, failed or timeout
                    // on success of payment-> call an https function which verifies the payment and update the details in firestore and update status
                    // after the above function remove the order id from local
                    // if the order id exists, then make sure to call the https request again.

                    // get order id. the order id is same for a session.

                    xPrint("resData resMap - $orderMap", header: "AdvancePay3");
                    setState(() {
                      payInitiated = true;
                    });
                    _razorpay.open({
                      'key': 'rzp_test_ZaNurDjOc7x3Di',
                      'amount': orderMap['amount'] * 100, //in the smallest currency sub-unit.
                      'name': 'Pawrapets',
                      'order_id': orderMap['orderId'], // Generate order_id using Orders API
                      'description': orderMap['description'],
                      'timeout': 60 * 5,
                      'prefill': {'contact': '+919999999999', 'email': Provider.of<AuthProvider>(context, listen: false).email} // in seconds
                    });
                    await Future.delayed(const Duration(seconds: 1));
                    setState(() {
                      payInitiated = false;
                    });
                  },
                  text: buttonText,
                  textStyle: xTheme.textTheme.bodyMedium!.apply(color: xOnPrimary),
                  expand: true,
                  enabled: buttonEnabled,
                  backgroundColor: xPrimary.withOpacity(0.8),
                ),
            ),
        if(payError)SizedBox().vertical(size: xSize/2),
        if(payError)xErrorText(context, 'There was an error while payment. Do not worry if the amount has been deducted from your account, it will be refunded within 24 hours.'),
        if (buttonText == "Paid") SizedBox().vertical(size: xSize/2),
        if (buttonText == "Paid")
          FutureBuilder(
            future: FirebaseCloudFirestore().getMatingPaymentInfo(widget.frndsUidPN, widget.matingID, widget.sessionID),
            builder: (context, snap) {
              if (snap.hasData) {
                xPrint('is the friends has paid security or not ${snap.data}');
                if (snap.data?['securityAmountDeposited'] == 500) {
                  return xInfoText(context, "${widget.frndsName} has also paid security deposit");
                } else {
                  return xInfoText(context, "Waiting for ${widget.frndsName} to pay security deposit.");
                }
              } else {
                return const LinearProgressIndicator();
              }
            },
          )
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
