import 'package:flutter/material.dart';
import 'package:pawrapet/screens/scheduleBottomSheet/scheduleBottomSheet.dart';
import 'package:pawrapet/utils/extensions/dateTime.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/widgets/datePicker.dart';
import '../../../../utils/widgets/inputFields.dart';

class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({Key? key}) : super(key: key);

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: xSize * 6,
      padding: const EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 4),
      decoration: BoxDecoration(
        color: const Color(0xffEEDEC2),
        borderRadius: BorderRadius.circular(xSize2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Schedule",
                style: xTheme.textTheme.headlineMedium!.apply(color: xPrimary.withOpacity(0.8)),
                overflow: TextOverflow.ellipsis,
              ),
              const Expanded(child: Center()),
              const SizedBox().horizontal(size: xSize / 4),
              Opacity(
                opacity: 0.8,
                child: XDatePickerField(
                  expanded: false,
                  backgroundColor: xOnPrimary.withOpacity(0.6),
                  textStyle: xTheme.textTheme.labelMedium!.apply(fontSizeDelta: -1),
                  onSelected: (d) {},
                  onTap: () {},
                  initialValue: DateTime.now().toddMMyyyy(),
                ),
              ),
              const SizedBox().horizontal(size: xSize / 4),
              GestureDetector(
                onTap: () {},
                child: Opacity(
                  opacity: 0.8,
                  child: GestureDetector(
                    onTap: () {
                      _showEditScheduleBottomSheet(context);
                    },
                    child: Container(
                      height: xSize * 1.2,
                      padding: const EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 4),
                      decoration: BoxDecoration(
                        color: xOnPrimary.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(xSize2),
                      ),
                      child: const Icon(
                        Icons.edit_calendar_rounded,
                        size: xSize * 0.6,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox().vertical(size: xSize / 4),
          Expanded(
            child: Container(
              width: xWidth,
              decoration: BoxDecoration(
                color: xOnPrimary.withOpacity(0.6),
                borderRadius: BorderRadius.circular(xSize2),
              ),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  scheduleListTile(),
                  scheduleListTile(),
                  scheduleListTile(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditScheduleBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set to true for flexible height
      builder: (BuildContext context) {
        return ScheduleBottomSheet();
      },
    );
  }

  Widget scheduleListTile() {
    bool completed = false;
    return Padding(
      padding: const EdgeInsets.all(xSize / 4).copyWith(bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              "5:00 Pm - Appointment with Scooby for mating.",
              style: xTheme.textTheme.bodySmall!.apply(color: xPrimary.withOpacity(0.8), fontSizeDelta: -1),
            ),
          ),
          const SizedBox().horizontal(size: xSize / 4),
          InkWell(
            onTap: () {
              setState(() {
                completed = !completed;
              });
            },
            child: SizedBox(
              height: xSize * 0.7,
              width: xSize * 0.7,
              child: Icon(
                completed ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                color: Colors.grey.withOpacity(0.9),
              ),
            ),
          )
        ],
      ),
    );
  }
}