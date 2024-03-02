import 'package:flutter/material.dart';
import 'package:pawrapet/screens/home/utils/widgets/feedWidgets.dart';
import 'package:pawrapet/screens/mating/utils/widgets/widgets.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/widgets/buttons.dart';

class Preview1Final extends StatefulWidget {
  Preview1Final({Key? key}) : super(key: key);

  @override
  State<Preview1Final> createState() => _Preview1FinalState();
}

class _Preview1FinalState extends State<Preview1Final> {

  @override
  void initState() {
    // todo get the details of the post
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: xSize/2, vertical: xSize/4),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              FindingPartnerWidget(feedMap: {},),
              const SizedBox().vertical(),
              SizedBox(
                width: xWidth,
                child: XColoredButton(
                  backgroundColor: xOnError.withOpacity(0.4),
                  textOpacity: 0.6,
                  text: "Remove from matches",
                  onTap: () {
                    // todo show confirmation dialog and remove from the matches list
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
