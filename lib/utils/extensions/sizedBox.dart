import 'package:flutter/cupertino.dart';
import 'package:pawrapet/utils/constants.dart';

extension SizedBoxSpacings on SizedBox{
  SizedBox vertical({double? size}){
    return SizedBox(
      height: size??xSize/2,
    );
  }
  SizedBox horizontal({double? size}){
    return SizedBox(
      width: size??xSize/2,
    );
  }
}