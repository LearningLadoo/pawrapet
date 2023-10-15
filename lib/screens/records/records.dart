import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/extensions/dateTime.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/extensions/string.dart';
import 'package:pawrapet/utils/widgets/buttons.dart';

import '../../utils/widgets/appBar.dart';
import '../../utils/widgets/common.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  bool bottomInputFieldVisible = false;
  String? selected; // notes, weight, height, reports, docs, bills, others
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      // floatingActionButton: InkWell(
      //   splashColor: Colors.transparent,
      //   onTap: () {
      //     setState(() {
      //       bottomInputFieldVisible = !bottomInputFieldVisible;
      //     });
      //   },
      //   child: CircleAvatar(
      //     backgroundColor: xSecondary,
      //     radius: xSize * 0.6,
      //     child: Icon(
      //       (bottomInputFieldVisible) ? Icons.keyboard_arrow_down_rounded : Icons.add_rounded,
      //       color: xPrimary.withOpacity(0.8),
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            XAppBar(
              AppBarType.backWithHeading,
              title: "Records${(selected != null) ? ", ${selected!.capitalizeFirstOfEach}" : ""}",
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: xSize / 2),
                child: Stack(
                  children: [
                    ScrollConfiguration(
                      behavior: const CupertinoScrollBehavior(),
                      child: CustomScrollView(
                        slivers: datesList.map((dateString) {
                          DateTime dt = DateTime.fromMillisecondsSinceEpoch(int.parse(dummyData['time']!) * 1000);
                          return SliverStickyHeader(
                            header: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: xSecondary,
                                  radius: xSize * 0.6,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${DateFormat('dd').format(dt)}',
                                        style: xTheme.textTheme.labelLarge!.apply(color: xPrimary.withOpacity(0.6), heightFactor: 0.8),
                                      ),
                                      Text(
                                        '${DateFormat('MMM').format(dt)}',
                                        style: xTheme.textTheme.labelSmall!.apply(color: xPrimary.withOpacity(0.8)),
                                      ),
                                    ],
                                  ),
                                ),
                                const Expanded(child: Center()),
                              ],
                            ),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, i) => Container(
                                  margin: const EdgeInsets.only(left: xSize * 0.6 - 0.5),
                                  padding: const EdgeInsets.only(left: xSize * 0.6 + 0.5),
                                  width: xWidth,
                                  // constraints: const BoxConstraints(minHeight: xSize * 2),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(color: xPrimary.withOpacity(0.3), width: 1),
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(xSize / 4).copyWith(bottom: xSize / 8),
                                    margin: const EdgeInsets.only(bottom: xSize / 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffEEDEC2).withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(xSize2),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // todo ### come back here again to yaha par preview dalna hai, for image and pdf
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(minHeight: xSize * 3),
                                          child: ClipRRect(
                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(xSize / 4), bottom: Radius.circular(xSize / 10)),
                                              child: Image(
                                                image: Image.asset("assets/images/pet1_image.jpeg").image,
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                        const SizedBox().vertical(size: xSize / 8),
                                        Text(
                                          dummyData["text"]!,
                                          style: xTheme.textTheme.bodySmall!.apply(fontSizeDelta: -2, color: xPrimary.withOpacity(0.95)),
                                        ),
                                        Text(
                                          "${DateFormat('hh:mm a').format(dt)}",
                                          textAlign: TextAlign.right,
                                          style: xTheme.textTheme.labelSmall!.apply(color: xPrimary.withOpacity(0.5), heightFactor: 0.5),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                childCount: 10,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (bottomInputFieldVisible)
              Padding(
                padding: const EdgeInsets.all(xSize / 2),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: XColoredButton(
                            padding: EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 6),
                            backgroundColor: xSecondary,
                            text: "Reports",
                            invert: selected == "reports",
                            textStyle: xTheme.textTheme.bodyMedium!.apply(fontWeightDelta: -1),
                            textOpacity: 0.5,
                            onTap: () {
                              setState(() {
                                selected = "reports";
                              });
                            },
                          ),
                        ),
                        SizedBox().horizontal(),
                        Expanded(
                          child: XColoredButton(
                            padding: EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 6),
                            backgroundColor: xSecondary,
                            text: "Weight",
                            invert: selected == "weight",
                            textStyle: xTheme.textTheme.bodyMedium!.apply(fontWeightDelta: -1),
                            textOpacity: 0.5,
                            onTap: () {
                              setState(() {
                                selected = "weight";
                              });
                            },
                          ),
                        ),
                        SizedBox().horizontal(),
                        Expanded(
                          child: XColoredButton(
                            padding: EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 6),
                            backgroundColor: xSecondary,
                            text: "Height",
                            invert: selected == "height",
                            textStyle: xTheme.textTheme.bodyMedium!.apply(fontWeightDelta: -1),
                            textOpacity: 0.5,
                            onTap: () {
                              setState(() {
                                selected = "height";
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox().vertical(),
                    Row(
                      children: [
                        Expanded(
                          child: XColoredButton(
                            padding: EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 6),
                            backgroundColor: xSecondary,
                            text: "Notes",
                            invert: selected == "notes",
                            textStyle: xTheme.textTheme.bodyMedium!.apply(fontWeightDelta: -1),
                            textOpacity: 0.5,
                            onTap: () {
                              setState(() {
                                selected = "notes";
                              });
                            },
                          ),
                        ),
                        SizedBox().horizontal(),
                        Expanded(
                          child: XColoredButton(
                            padding: EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 6),
                            backgroundColor: xSecondary,
                            text: "Docs",
                            invert: selected == "docs",
                            textStyle: xTheme.textTheme.bodyMedium!.apply(fontWeightDelta: -1),
                            textOpacity: 0.5,
                            onTap: () {
                              setState(() {
                                selected = "docs";
                              });
                            },
                          ),
                        ),
                        SizedBox().horizontal(),
                        Expanded(
                          child: XColoredButton(
                            padding: EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 6),
                            backgroundColor: xSecondary,
                            text: "Bills",
                            invert: selected == "bills",
                            textStyle: xTheme.textTheme.bodyMedium!.apply(fontWeightDelta: -1),
                            textOpacity: 0.5,
                            onTap: () {
                              setState(() {
                                selected = "bills";
                              });
                            },
                          ),
                        ),
                        SizedBox().horizontal(),
                        Expanded(
                          child: XColoredButton(
                            padding: EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 6),
                            backgroundColor: xSecondary,
                            text: "Others",
                            invert: selected == "others",
                            textStyle: xTheme.textTheme.bodyMedium!.apply(fontWeightDelta: -1),
                            textOpacity: 0.5,
                            onTap: () {
                              setState(() {
                                selected = "others";
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}

List<String> datesList = List.generate(5, (index) => "${index + 1}-09-2023");
Map<String, String> dummyData = {'time': '${DateTime.now().millisecondsSinceEpoch ~/ 1000}', 'text': 'payment aefbjk sfaskdj f askdfj askfd kajsdf ajkdsf kajsf d of 100 rs is successful'};
