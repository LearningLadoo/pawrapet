import 'package:flutter/material.dart';
import 'package:pawrapet/utils/widgets/buttons.dart';
import '../../../../utils/functions/common.dart';
import '/../utils/constants.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        xShowDialog(
          context: context,
          heading: "Account Deletion",
          content: "Are you sure you want to delete Bruno's profile? Doing so will result in the loss of all the details and records related to this file.",
          bottomWidget: Column(
            children: [
              SizedBox().vertical(size: xSize / 2),
              XRoundedButtonOutlined(
                onPressed: () {},
                expand: true,
                text: "Cancel",
                textStyle: xTheme.textTheme.bodyMedium!.apply(fontWeightDelta: 0, color: xOnPrimary),
              ),
              SizedBox().vertical(size: xSize / 2),
              XRoundedButton(
                onPressed: () {},
                expand: true,
                text: "Delete",
                textStyle: xTheme.textTheme.bodyMedium!.apply(fontWeightDelta: 0, color: xSecondary),
              ),
            ],
          ),
        );
      },
      child: Container(
        height: xSize * 1.5,
        padding: const EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 4),
        decoration: BoxDecoration(
          color: xError.withOpacity(0.5),
          borderRadius: BorderRadius.circular(xSize2),
        ),
        child: Center(
          child: Text(
            "Delete the Account",
            style: TextStyle(
              color: xOnError.withOpacity(0.95),
            ),
          ),
        ),
      ),
    );
  }
}
