import 'dart:developer';

void xPrint(String? str){
  log("$str");
}
bool xContainsDate(List<DateTime> list, DateTime date){
  for (DateTime d in list){
    if(d.day == date.day && d.month == date.month && d.year == date.year) return true;
  }
  return false;
}