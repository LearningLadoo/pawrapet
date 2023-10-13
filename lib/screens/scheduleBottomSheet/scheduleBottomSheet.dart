import 'package:flutter/material.dart';
import '../../utils/extensions/dateTime.dart';
import '../../utils/extensions/sizedBox.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/datePicker.dart';
import '../../utils/widgets/inputFields.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
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
          ),
          SizedBox().vertical(size:MediaQuery.of(context).viewInsets.bottom)
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
