import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import '../constants.dart';

void xPrint(String? str, {String? header}){
  log("${header??""}: $str");
}
bool xContainsDate(List<DateTime> list, DateTime date){
  for (DateTime d in list){
    if(d.day == date.day && d.month == date.month && d.year == date.year) return true;
  }
  return false;
}
Widget waitingDogLottie() => Lottie.asset("assets/lotties/dog_happy_waiting.json", width: xSize * 10);

