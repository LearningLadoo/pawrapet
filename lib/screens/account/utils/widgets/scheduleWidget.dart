import 'package:flutter/material.dart';
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

  TimeOfDay selectedTime = TimeOfDay.now();


  void _showEditScheduleBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set to true for flexible height
      builder: (BuildContext context) {
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
              Text(
                "Edit schedule for ${DateTime.now().fullWithOrdinal()}",
                style: xTheme.textTheme.headlineMedium!.apply(color: xPrimary.withOpacity(0.8)),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox().vertical(),
              Container(
                constraints: BoxConstraints(maxHeight: xHeight * 0.4),
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [],
                ),
              ),
              SizedBox().vertical(size: xSize1),
              Row(
                children: [
                  XTimePickerField(
                    expanded: false,
                    backgroundColor: xPrimary.withOpacity(0.05),
                    textStyle: xTheme.textTheme.labelLarge!.apply(fontSizeDelta: -1),
                    onSelected: (d) {},
                    onTap: () {},
                    hintText: "Time",
                  ),
                  SizedBox().horizontal(size: xSize1),
                  Expanded(
                    child: XTextField(
                      backgroundColor: xPrimary.withOpacity(0.05),
                      onChangedFn: (c) {},
                      hintText: "Write a task",
                      textStyle: xTheme.textTheme.labelLarge!.apply(fontSizeDelta: -1),
                    ),
                  ),
                  SizedBox().horizontal(size: xSize1),
                  GestureDetector(
                    onTap: () {
                    },
                    child: Container(
                      padding: EdgeInsets.all(xSize / 3),
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
              )
            ],
          ),
        );
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

  Widget scheduleEditListTile() {
    bool completed = false;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(xSize2),
        color: Color(0xffEEDEC2),
      ),
      margin: const EdgeInsets.only(bottom: xSize / 4),
      padding: const EdgeInsets.all(xSize / 4),
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
              setState(() {});
            },
            child: SizedBox(
              height: xSize * 0.7,
              width: xSize * 0.7,
              child: Icon(
                Icons.edit,
                color: xPrimary.withOpacity(0.3),
              ),
            ),
          ),
          const SizedBox().horizontal(size: xSize / 4),
          InkWell(
            onTap: () {
              setState(() {});
            },
            child: SizedBox(
              height: xSize * 0.7,
              width: xSize * 0.7,
              child: Icon(
                Icons.delete_rounded,
                color: xPrimary.withOpacity(0.3),
              ),
            ),
          )
        ],
      ),
    );
  }
}