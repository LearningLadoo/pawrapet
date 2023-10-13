import 'package:flutter/material.dart';
import 'package:pawrapet/utils/widgets/buttons.dart';
import '../../utils/extensions/dateTime.dart';
import '../../utils/extensions/sizedBox.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/datePicker.dart';
import '../../utils/widgets/inputFields.dart';

class AskAnythingBottomSheet extends StatefulWidget {
  const AskAnythingBottomSheet({super.key});

  @override
  State<AskAnythingBottomSheet> createState() => _AskAnythingBottomSheetState();
}

class _AskAnythingBottomSheetState extends State<AskAnythingBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: xWidth,
      padding: const EdgeInsets.all(xSize / 2).copyWith(bottom: 0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(xSize2),
          topRight: Radius.circular(xSize2),
        ),
        color: xOnPrimary,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: xSize * 2,
                child: XBackButton(),
              ),
              Expanded(
                child: Text(
                  "Ask Anything",
                  style: xTheme.textTheme.headlineMedium!.apply(color: xPrimary.withOpacity(0.8)),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: xSize * 2,
                child: Text(
                  "2/10",
                  style: xTheme.textTheme.headlineMedium!.apply(
                    color: xPrimary.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
          SizedBox().vertical(),
          Container(
            height: xHeight * 0.35,
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                chatTile(true, "Hello Bruno, I'm an AI assistant at PAWRAPET, You can ask me anything related to your pet. For better answers ask one thing at a time.\n10 questions are left, after that you need to purchase more."),
                chatTile(false, "how to stop him from eating furniture ?"),
                chatTile(true, 'To prevent Bruno from eating furniture:\nRedirect Attention: Offer chew toys or treats 🦴 when he shows interest in furniture.\nTraining: Use "leave it" command and reward compliance 🏅.Bitter Spray: Apply a pet-safe bitter spray to deter chewing.\nSupervision: Monitor and correct behavior, providing positive reinforcement for appropriate chewing 🐾.\nCrate Training: Utilize a crate for times you can\'t supervise, with toys to keep him occupied 🏠.')
              ]
              ,
            ),
          ),
          SizedBox().vertical(size: xSize1),
          Row(
            children: [
              Expanded(
                child: XTextField(
                  backgroundColor: xPrimary.withOpacity(0.05),
                  onChangedFn: (c) {},
                  hintText: "Type your query",
                  textStyle: xTheme.textTheme.labelLarge!.apply(fontSizeDelta: -1),
                ),
              ),
              SizedBox().horizontal(size: xSize1),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(xSize / 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(xSize2),
                    color: xPrimary.withOpacity(0.7),
                  ),
                  child: Text(
                    "Ask",
                    style: xTheme.textTheme.labelLarge!.apply(fontSizeDelta: -1, color: xOnPrimary),
                  ),
                ),
              ),
            ],
          ),
          SizedBox().vertical(size: MediaQuery.of(context).viewInsets.bottom)
        ],
      ),
    );
  }
  Widget chatTile(bool left, text){
    LinearGradient lg = (left)?LinearGradient(
      stops: [0.01,0.01],
      colors: [xPrimary.withOpacity(0.2), Color(0xffEEDEC2)],
    ):LinearGradient(
      stops: [0.99,0.99],
      colors: [ Color(0xffEEDEC2), xPrimary.withOpacity(0.2)],
    );
    BorderRadius bg = BorderRadius.horizontal(left: Radius.circular((left)?xSize2/2:xSize2), right: Radius.circular((left)?xSize2:xSize2/2));
    return Container(
      decoration: BoxDecoration(
        gradient: lg,
        borderRadius: bg,
      ),
      margin: EdgeInsets.only(right: ((left)?xSize:0),left: ((left)?0:xSize), bottom: xSize / 4),
      padding: const EdgeInsets.all(xSize / 4),
      child: Text(
        text,
        style: xTheme.textTheme.labelLarge!.apply(fontSizeDelta: -1),
        textAlign: (left)?TextAlign.left:TextAlign.right,
      ),
    );
  }
}
