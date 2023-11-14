import 'package:flutter/material.dart';
import '../../utils/extensions/sizedBox.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/appBar.dart';
import 'utils/widgets/askAnything.dart';
import 'utils/widgets/deleteAccount.dart';
import 'utils/widgets/logOut.dart';
import 'utils/widgets/editProfile.dart';
import 'utils/widgets/govtId.dart';
import 'utils/widgets/history.dart';
import 'utils/widgets/manageRecords.dart';
import 'utils/widgets/scheduleWidget.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        XAppBar(
          AppBarType.account,
          title: "Bruno",
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(xSize / 2).copyWith(top: xSize / 4),
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  Expanded(flex: 2, child: editProfile()),
                  const SizedBox().horizontal(),
                  Expanded(
                    flex: 1,
                    child: govtId(),
                  )
                ],

              ),
              const SizedBox().vertical(),
              const AskAnything(),
              const SizedBox().vertical(),
              const ScheduleWidget(),
              const SizedBox().vertical(),
              const ManageRecords(),
              const SizedBox().vertical(),
              const History(),
              const SizedBox().vertical(),
              const Logout(),
              const SizedBox().vertical(),
              const DeleteAccount()
            ],
          ),
        )
      ],
    );
  }






}


