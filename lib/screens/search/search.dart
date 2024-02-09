import 'package:flutter/material.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/widgets/appBar.dart';

import '../../utils/constants.dart';
import '../../utils/functions/common.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        XAppBar(
          AppBarType.search
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(xSize / 2).copyWith(top: xSize / 3),
            physics: const BouncingScrollPhysics(),
            children: [
              ...[searchWidget(),Divider()],
              ...[searchWidget(),Divider()],
              ...[searchWidget(),Divider()],
            ],
          ),
        ),
      ],
    );
  }
}
Widget searchWidget(){
  return Row(
    children: [
      CircleAvatar(
        backgroundImage: xMyIcon().image,
        radius: xSize,
      ),
      SizedBox().horizontal(size: xSize/4),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Name", style: xTheme.textTheme.bodyMedium,),
          Text("@username", style: xTheme.textTheme.bodySmall!.copyWith(color: xPrimary.withOpacity(0.9)),),
        ],
      )
    ],
  );
}