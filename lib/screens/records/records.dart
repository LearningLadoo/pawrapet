import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';
import 'package:pawrapet/screens/records/utils/widgets/widgets.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/sizedBox.dart';
import '../../utils/extensions/string.dart';
import '../../utils/widgets/buttons.dart';
import '../../utils/widgets/appBar.dart';
import '../../utils/widgets/inputFields.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  bool bottomInputFieldVisible = false;
  String? selected; // notes, weight, height, reports, docs, bills, others
  String hintTextDefault = "type here";
  String? hintText;
  TextInputType? textInputType = TextInputType.multiline;
  TextInputAction? textInputAction = TextInputAction.newline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            XAppBar(
              AppBarType.backWithHeading,
              title: "Records${(selected != null) ? ", ${selected!.capitalizeFirstOfEach}" : ""}",
            ),
            // the scrollable content, timeline and add content section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: xSize / 2),
                child: Stack(
                  children: [
                    // timeline vertical line
                    VerticalDivider(
                      width: xSize * 1.2,
                      thickness: xSize1 / 8,
                      color: xOnSecondary.withOpacity(0.4),
                    ),
                    // the scrollable section
                    ScrollConfiguration(
                      behavior: const CupertinoScrollBehavior(),
                      child: CustomScrollView(
                        slivers: datesList.map((dateString) {
                          // date
                          DateTime dt = DateTime.fromMillisecondsSinceEpoch(int.parse(dummyData['time']!) * 1000);
                          // preview widget // todo add compatibility for pdf and a placeholder with just text for others
                          Widget previewWidget = Image(
                            image: Image.asset("assets/images/pet1_image.jpeg").image,
                            fit: BoxFit.cover,
                          );
                          // todo calculate the length
                          int length = 2;
                          return SliverStickyHeader(
                            header: stickyDateHeader(dt),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, i) => sliverContentChild(dt: dt, text: dummyData['text'], previewImage: previewWidget),
                                childCount: length,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    // add button, search field and back
                    Positioned.fill(
                      child: Column(
                        children: [
                          const Expanded(child: Center()),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // circle + button
                              InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    bottomInputFieldVisible = !bottomInputFieldVisible;
                                    if (bottomInputFieldVisible) {
                                      selected = "notes";
                                    } else {
                                      selected = null;
                                    }
                                  });
                                },
                                child: CircleAvatar(
                                  backgroundColor: xSecondary,
                                  radius: xSize * 0.64,
                                  child: Icon(
                                    (bottomInputFieldVisible) ? Icons.keyboard_arrow_down_rounded : Icons.add_rounded,
                                    color: xPrimary.withOpacity(0.8),
                                  ),
                                ),
                              ),
                              // field and add button
                              if (bottomInputFieldVisible)
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(top: xSize1),
                                    color: xOnPrimary,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const SizedBox().horizontal(size: xSize1),
                                        Expanded(
                                          child: XTextFieldWithPicker(
                                            backgroundColor: xPrimary.withOpacity(0.05),
                                            onTextChangedFn: (c) {},
                                            textInputAction: textInputAction,
                                            keyboardType: textInputType,
                                            onFilePathsChangedFn: (paths) {},
                                            hintText: hintText ?? hintTextDefault,
                                            textStyle: xTheme.textTheme.labelLarge!.apply(fontSizeDelta: -1, fontWeightDelta: -1),
                                          ),
                                        ),
                                        const SizedBox().horizontal(size: xSize1),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            padding: const EdgeInsets.all(xSize / 3),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(xSize2),
                                              color: xPrimary.withOpacity(0.7),
                                            ),
                                            child: Text(
                                              "Add",
                                              style: xTheme.textTheme.labelLarge!.apply(fontSizeDelta: -1, color: xOnPrimary),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                            ],
                          ),
                          const SizedBox().vertical(size: bottomInputFieldVisible ? 0 : xSize / 2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // choose from type of content
            if (bottomInputFieldVisible)
              Padding(
                padding: const EdgeInsets.all(xSize / 2).copyWith(top: null),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: XColoredButton(
                            padding: const EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 6),
                            backgroundColor: xSecondary,
                            text: "Reports",
                            invert: selected == "reports",
                            textStyle: xTheme.textTheme.bodyMedium!.apply(fontWeightDelta: -1),
                            textOpacity: 0.5,
                            onTap: () {
                              setState(() {
                                selected = "reports";
                                textInputType = TextInputType.multiline;
                                textInputAction = TextInputAction.newline;
                                hintText = hintTextDefault;
                              });
                            },
                          ),
                        ),
                        const SizedBox().horizontal(),
                        Expanded(
                          child: XColoredButton(
                            padding: const EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 6),
                            backgroundColor: xSecondary,
                            text: "Weight",
                            invert: selected == "weight",
                            textStyle: xTheme.textTheme.bodyMedium!.apply(fontWeightDelta: -1),
                            textOpacity: 0.5,
                            onTap: () {
                              setState(() {
                                selected = "weight";
                                textInputType = TextInputType.number;
                                textInputAction = TextInputAction.done;
                                hintText = "type weight in Kg";
                              });
                            },
                          ),
                        ),
                        const SizedBox().horizontal(),
                        Expanded(
                          child: XColoredButton(
                            padding: const EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 6),
                            backgroundColor: xSecondary,
                            text: "Height",
                            invert: selected == "height",
                            textStyle: xTheme.textTheme.bodyMedium!.apply(fontWeightDelta: -1),
                            textOpacity: 0.5,
                            onTap: () {
                              setState(() {
                                selected = "height";
                                textInputType = TextInputType.number;
                                textInputAction = TextInputAction.done;
                                hintText = "type height in cm";
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox().vertical(),
                    Row(
                      children: [
                        Expanded(
                          child: XColoredButton(
                            padding: const EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 6),
                            backgroundColor: xSecondary,
                            text: "Notes",
                            invert: selected == "notes",
                            textStyle: xTheme.textTheme.bodyMedium!.apply(fontWeightDelta: -1),
                            textOpacity: 0.5,
                            onTap: () {
                              setState(() {
                                selected = "notes";
                                textInputType = TextInputType.multiline;
                                textInputAction = TextInputAction.newline;
                                hintText = hintTextDefault;
                              });
                            },
                          ),
                        ),
                        const SizedBox().horizontal(),
                        Expanded(
                          child: XColoredButton(
                            padding: const EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 6),
                            backgroundColor: xSecondary,
                            text: "Docs",
                            invert: selected == "docs",
                            textStyle: xTheme.textTheme.bodyMedium!.apply(fontWeightDelta: -1),
                            textOpacity: 0.5,
                            onTap: () {
                              setState(() {
                                selected = "docs";
                                textInputType = TextInputType.multiline;
                                textInputAction = TextInputAction.newline;
                                hintText = hintTextDefault;
                              });
                            },
                          ),
                        ),
                        const SizedBox().horizontal(),
                        Expanded(
                          child: XColoredButton(
                            padding: const EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 6),
                            backgroundColor: xSecondary,
                            text: "Bills",
                            invert: selected == "bills",
                            textStyle: xTheme.textTheme.bodyMedium!.apply(fontWeightDelta: -1),
                            textOpacity: 0.5,
                            onTap: () {
                              setState(() {
                                selected = "bills";
                                textInputType = TextInputType.multiline;
                                textInputAction = TextInputAction.newline;
                                hintText = hintTextDefault;
                              });
                            },
                          ),
                        ),
                        const SizedBox().horizontal(),
                        Expanded(
                          child: XColoredButton(
                            padding: const EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 6),
                            backgroundColor: xSecondary,
                            text: "Others",
                            invert: selected == "others",
                            textStyle: xTheme.textTheme.bodyMedium!.apply(fontWeightDelta: -1),
                            textOpacity: 0.5,
                            onTap: () {
                              setState(() {
                                selected = "others";
                                textInputType = TextInputType.multiline;
                                textInputAction = TextInputAction.newline;
                                hintText = hintTextDefault;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

List<String> datesList = List.generate(5, (index) => "${index + 1}-09-2023");
Map<String, String> dummyData = {'time': '${DateTime.now().millisecondsSinceEpoch ~/ 1000}', 'text': 'payment aefbjk sfaskdj f askdfj askfd kajsdf ajkdsf kajsf d of 100 rs is successful'};

