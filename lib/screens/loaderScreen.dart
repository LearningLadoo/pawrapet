import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';

import 'package:pawrapet/utils/constants.dart';

import '../utils/widgets/common.dart';

class LoaderScreen extends StatelessWidget {
  const LoaderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Transform.rotate(
                angle: pi / 2,
                origin: Offset(xSize*2.7, -xSize*2),
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "assets/images/element2.png",
                  width: MediaQuery.of(context).size.width,
                  height: xSize*2,
                ),
              ),
              Lottie.asset("assets/lotties/dog_happy_walk.json", width: xSize*10),
              Transform.rotate(
                angle: -pi / 2,
                origin: Offset(-xSize*4, -xSize*3),
                alignment: Alignment.centerRight,
                child: Image.asset(
                  "assets/images/element2.png",
                  width: MediaQuery.of(context).size.width,
                  height: xSize*2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
