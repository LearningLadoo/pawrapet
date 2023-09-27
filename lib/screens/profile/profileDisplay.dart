import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/widgets/heart.dart';
class ProfileDisplay extends StatefulWidget {
  const ProfileDisplay({Key? key}) : super(key: key);

  @override
  State<ProfileDisplay> createState() => _ProfileDisplayState();
}

class _ProfileDisplayState extends State<ProfileDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            XHeartWithImage()
          ],
        ),
      ),
    );
  }
}