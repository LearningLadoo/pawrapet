import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/widgets/appBar.dart';

import '../../utils/constants.dart';

class PetShop extends StatefulWidget {
  const PetShop({Key? key}) : super(key: key);

  @override
  State<PetShop> createState() => _PetShopState();
}

class _PetShopState extends State<PetShop> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        XAppBar(AppBarType.heading, title: "Pet Shop"),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity:0.9,
                child: SizedBox(
                  height: xSize*5,
                  child: SvgPicture.asset("assets/icons/essentialsIcon.svg"),
                ),
              ),
              SizedBox().vertical(),
              Text("Coming soon!",  style: xTheme.textTheme.bodyLarge,),
            ],
          ),
        ),
      ],
    );
  }
}
