import 'package:intl/intl.dart';

extension DateFormats on DateTime {
  String ordinalSuffix() {
    int day = int.parse(DateFormat('d').format(this));
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }
  String fullWithOrdinal(){
    String month = DateFormat('MMM').format(this);
    String year = DateFormat('y').format(this);

    // Add the ordinal suffix to the day
    String dayWithSuffix = ordinalSuffix();

    return '$dayWithSuffix $month $year';
  }
  String toddMMyyyy(){
    return DateFormat('dd/MM/yyyy').format(this);
  }
  DateTime fromddMMyyyy(String ddMMyyyy){
    return DateFormat('dd/MM/yyyy').parseStrict(ddMMyyyy);
  }
}