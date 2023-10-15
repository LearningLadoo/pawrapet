import 'package:flutter/material.dart';
import 'package:pawrapet/screens/records/records.dart';
import 'package:pawrapet/utils/extensions/buildContext.dart';
import '/../utils/constants.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';

class ManageRecords extends StatelessWidget {
  const ManageRecords({super.key});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        context.push(RecordsPage());
      },
      child: Container(
        height: xSize * 3,
        padding: const EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFdce1cb), Color(0xFFe8ebd8), Color(0xFFe4e6d8), Color(0xFFdce1cb)], stops: [0, 0.2, 0.6, 1], begin: Alignment.bottomLeft),
          borderRadius: BorderRadius.circular(xSize2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Manage Records",
              style: xTheme.textTheme.headlineMedium!.apply(color: xPrimary.withOpacity(0.8)),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox().vertical(size: xSize / 16),
            Text(
              "Bills, Prescriptions, Weight, Diet, Notes and more",
              overflow: TextOverflow.ellipsis,
              style: xTheme.textTheme.bodySmall!.apply(color: xPrimary.withOpacity(0.8), fontSizeDelta: -1),
            ),
          ],
        ),
      ),
    );
  }
}
