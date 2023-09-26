import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pawrapet/utils/constants.dart';

Widget xBottomNav({TabController? tabController}){
  return TabBar(
    // controller: tabController,
    indicatorWeight: xSize/3,
    splashBorderRadius: BorderRadius.circular(xSize),
    tabs: [
      const Tab(
        icon: Icon(Icons.circle),
      ),
      const Tab(
        icon: Icon(CupertinoIcons.house_alt_fill),
      ),
      Tab(
        child: SizedBox(
            height: xSize,
            width: xSize,
            child: SvgPicture.asset("assets/icons/essentialsIcon.svg")),
      ),
      const Tab(
        icon: Icon(CupertinoIcons.bell_solid),
      ),
      const Tab(
        icon: Icon(CupertinoIcons.search),
      ),
    ],
  );
}