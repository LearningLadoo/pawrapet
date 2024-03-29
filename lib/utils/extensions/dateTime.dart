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

  String fullWithOrdinal() {
    String month = DateFormat('MMM').format(this);
    String year = DateFormat('y').format(this);

    // Add the ordinal suffix to the day
    String dayWithSuffix = ordinalSuffix();

    return '$dayWithSuffix $month $year';
  }

  String toddMMyyyy() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  DateTime fromddMMyyyy(String ddMMyyyy) {
    return DateFormat('dd/MM/yyyy').parseStrict(ddMMyyyy);
  }

  String toddMMyyyyhhmm() {
    return DateFormat('dd/MM/yyyy hh:mm a').format(this);
  }

  DateTime fromddMMyyyyhhmm(String ddMMyyyyhhmm) {
    return DateFormat('dd/MM/yyyy hh:mm a').parseStrict(ddMMyyyyhhmm);
  }
  String tohhmma(){
    return DateFormat('hh:mm a').format(this);
  }
}

extension Operations on DateTime {
  int calculateYears() {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - year;

    // Check if the birthdate hasn't occurred yet this year
    if (currentDate.month < month || (currentDate.month == month && currentDate.day < day)) {
      age--;
    }

    return age;
  }
  int calculateDays() {
    DateTime currentDate = DateTime.now();
    return currentDate.difference(this).inDays;
  }
  bool isSameDate(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }
  DateTime getWithSameDate(DateTime date) {
    return copyWith(year: date.year, month: date.month, day: date.day);
  }
  bool isSameTime(DateTime date) {
    return hour == date.hour && minute == date.minute;
  }
  DateTime getWithSameTime(DateTime date) {
    return copyWith(hour: date.hour, minute: date.minute);
  }
}
