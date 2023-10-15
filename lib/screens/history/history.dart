import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/extensions/dateTime.dart';

import '../../utils/widgets/appBar.dart';
import '../../utils/widgets/common.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const XAppBar(
              AppBarType.backWithHeading,
              title: "History",
            ),
            Expanded(
                child: ScrollConfiguration(
              behavior: const CupertinoScrollBehavior(),
              child: CustomScrollView(
                slivers: datesList.map((dateString) {
                  DateTime dt = DateTime.fromMillisecondsSinceEpoch(int.parse(dummyData['time']!) * 1000);
                  return SliverStickyHeader(
                    header: Container(
                      padding: EdgeInsets.all(xSize/4),
                      color: xSecondary,
                      child:
                      Text(
                        dt.fullWithOrdinal(),
                        style: xTheme.textTheme.labelLarge!.apply(color: xPrimary.withOpacity(0.6)),
                      ),
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => Container(
                          padding: const EdgeInsets.all(xSize / 4),
                          width: xWidth,
                          constraints: const BoxConstraints(minHeight: xSize * 2),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: xPrimary.withOpacity(0.15), width: 0.5),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dummyData["text"]!,
                                style: xTheme.textTheme.bodySmall!.apply(fontSizeDelta: -1),
                              ),
                              Text(
                                "${DateFormat('hh:mm a').format(dt)}",
                                textAlign: TextAlign.right,
                                style: xTheme.textTheme.labelSmall!.apply(color: xPrimary.withOpacity(0.5)),
                              )
                            ],
                          ),
                        ),
                        childCount: 10,
                      ),
                    ),
                  );
                }).toList(),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

List<String> datesList = List.generate(5, (index) => "${index + 1}-09-2023");
Map<String, String> dummyData = {
  'time':'${DateTime.now().millisecondsSinceEpoch~/1000}',
  'text': 'payment of 100 rs is successful'
};