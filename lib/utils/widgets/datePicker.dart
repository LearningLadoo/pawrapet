import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';
import 'package:pawrapet/utils/extensions/dateTime.dart';

import '../constants.dart';
import '../functions/common.dart';

class XTimePickerField extends StatefulWidget {
  final TextStyle? textStyle;
  final String? hintText;
  final String? initialValue; // storing the string as hh:mm a
  final Function onSelected;
  final Function onTap;
  final bool enabled, expanded;
  final Color? backgroundColor;

  const XTimePickerField({
    Key? key,
    this.enabled = true,
    this.expanded = true,
    this.textStyle,
    this.hintText,
    this.initialValue,
    this.backgroundColor,
    required this.onSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  State<XTimePickerField> createState() => _XTimePickerFieldState();
}

class _XTimePickerFieldState extends State<XTimePickerField> {
  DateTime? selectedTime;

  @override
  void initState() {
    if (widget.initialValue != null) {
      selectedTime = DateFormat('hh:mm a').parse(widget.initialValue!).copyWith(year: 1,month: 1,day: 1);
    }
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: xTheme.copyWith(
            colorScheme: xDatePickerColorScheme,
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          ),
        );
      },
    );
    DateTime? picked;
    if (pickedTime != null) picked = DateTime(1, 1, 1, pickedTime.hour, pickedTime.minute);
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      widget.onSelected(selectedTime == null ? null : selectedTime!.toddMMyyyy());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (!widget.enabled) return;
          widget.onTap();
          _selectDate(context);
          xPrint("Wow Sexyyy");
        },
        child: Container(
          width: widget.expanded ? xWidth : null,
          padding: const EdgeInsets.symmetric(horizontal: xSize / 3, vertical: xSize / 3),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? xSecondary.withOpacity(0.8),
            borderRadius: BorderRadius.circular(xSize2),
          ),
          child: Text(
            "${selectedTime != null ? DateFormat('hh:mm a').format(selectedTime!) : widget.hintText}",
            style: (widget.textStyle ?? xTheme.textTheme.bodyLarge)!.copyWith(
              color: xOnSecondary.withOpacity(selectedTime == null ? 0.5 : 1),
            ),
          ),
        ));
  }
}

class XDatePickerField extends StatefulWidget {
  final TextStyle? textStyle;
  final String? hintText;
  final String? initialValue; // storing the string as dd/MM/yyyy
  final Function onSelected;
  final Function onTap;
  final bool enabled, expanded;
  final Color? backgroundColor;

  const XDatePickerField({
    Key? key,
    this.enabled = true,
    this.expanded = true,
    this.textStyle,
    this.hintText,
    this.initialValue,
    this.backgroundColor,
    required this.onSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  State<XDatePickerField> createState() => _XDatePickerFieldState();
}

class _XDatePickerFieldState extends State<XDatePickerField> {
  DateTime? selectedDate;

  @override
  void initState() {
    if (widget.initialValue != null) {
      selectedDate = DateTime(0).fromddMMyyyy(widget.initialValue!);
    }
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) => Theme(
            data: xTheme.copyWith(
              textTheme: xTheme.textTheme.apply(
                displayColor: xOnSecondary.withOpacity(0.8),
                bodyColor: xOnSecondary.withOpacity(0.8),
              ),
              colorScheme: xDatePickerColorScheme,
            ),
            child: child!));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      widget.onSelected(selectedDate == null ? null : selectedDate!.toddMMyyyy());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (!widget.enabled) return;
          widget.onTap();
          _selectDate(context);
          xPrint("Wow Sexyyy");
        },
        child: Container(
          width: widget.expanded ? xWidth : null,
          padding: const EdgeInsets.symmetric(horizontal: xSize / 3, vertical: xSize / 3),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? xSecondary.withOpacity(0.8),
            borderRadius: BorderRadius.circular(xSize2),
          ),
          child: Text(
            "${selectedDate != null ? selectedDate!.fullWithOrdinal() : widget.hintText}",
            style: (widget.textStyle ?? xTheme.textTheme.bodyLarge)!.copyWith(
              color: xOnSecondary.withOpacity(selectedDate == null ? 0.5 : 1),
            ),
          ),
        ));
  }
}

class XDayPicker extends StatefulWidget {
  List<DateTime> availableDates;
  Color? color, onColor;
  ValueChanged<DateTime> onChanged;
  TextStyle? style;
  DateTime? initialDate;

  XDayPicker({super.key, required this.availableDates, required this.onChanged, this.color, this.onColor, this.style, this.initialDate});

  @override
  _XDayPickerState createState() => _XDayPickerState();
}

class _XDayPickerState extends State<XDayPicker> {
  late DateTime _selectedDate;
  DateTime firstDate = DateTime.now();
  late Color color, onColor;
  late TextStyle style;

  @override
  void initState() {
    color = widget.color ?? xPrimary;
    onColor = widget.onColor ?? xOnPrimary;
    style = widget.style ?? xTheme.textTheme.bodySmall!;
    _selectedDate = widget.initialDate ?? widget.availableDates.first;
    super.initState();
  }

  void _handleDateChanged(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
    widget.onChanged(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return DayPicker.single(
      selectedDate: _selectedDate,
      onChanged: _handleDateChanged,
      firstDate: widget.availableDates.first,
      lastDate: widget.availableDates.last,
      selectableDayPredicate: (date) {
        return xContainsDate(widget.availableDates, date);
      },
      datePickerLayoutSettings: const DatePickerLayoutSettings(
        contentPadding: EdgeInsets.all(0),
        cellContentMargin: EdgeInsets.all(2),
        maxDayPickerRowCount: 5,
      ),
      datePickerStyles: DatePickerRangeStyles(
        defaultDateTextStyle: style.copyWith(color: color.withOpacity(0.9)),
        selectedDateStyle: style.copyWith(color: onColor),
        disabledDateStyle: style.copyWith(color: color.withOpacity(0.3)),
        currentDateStyle: style.copyWith(color: color.withOpacity(0.9)),
        displayedPeriodTitle: style.apply(color: color.withOpacity(1), fontSizeDelta: 4),
        dayHeaderStyle: DayHeaderStyle(textStyle: style.copyWith(color: color.withOpacity(1))),
        selectedSingleDateDecoration: BoxDecoration(color: color.withOpacity(0.8), shape: BoxShape.circle),
        nextIcon: Icon(Icons.chevron_right_rounded, color: color),
        prevIcon: Icon(Icons.chevron_left_rounded, color: color),
      ),
    );
  }
}

class XMultipleDayPickerScreen extends StatefulWidget {
  List<DateTime> selectedDates;
  Color? color, onColor;
  ValueChanged<List<DateTime>> onChanged;
  TextStyle? style;

  XMultipleDayPickerScreen({super.key, required this.selectedDates, required this.onChanged, this.color, this.onColor, this.style});

  @override
  _XMultipleDayPickerScreenState createState() => _XMultipleDayPickerScreenState();
}

class _XMultipleDayPickerScreenState extends State<XMultipleDayPickerScreen> {
  late List<DateTime> _selectedDates;
  DateTime firstDate = DateTime.now();
  late Color color, onColor;
  late TextStyle style;

  @override
  void initState() {
    color = widget.color ?? xOnSecondary;
    onColor = widget.onColor ?? xSecondary;
    style = widget.style ?? xTheme.textTheme.bodySmall!;
    _selectedDates = widget.selectedDates;
    super.initState();
  }

  void _handleDateChanged(List<DateTime> selectedDates) {
    setState(() {
      _selectedDates = selectedDates;
    });
    widget.onChanged(selectedDates);
  }

  @override
  Widget build(BuildContext context) {
    return DayPicker.multi(
      selectedDates: _selectedDates,
      onChanged: _handleDateChanged,
      firstDate: firstDate,
      lastDate: DateTime(firstDate.year, firstDate.month + 3, firstDate.day),
      datePickerLayoutSettings: const DatePickerLayoutSettings(
        contentPadding: EdgeInsets.all(0),
        cellContentMargin: EdgeInsets.all(2),
      ),
      datePickerStyles: DatePickerRangeStyles(
        defaultDateTextStyle: style.copyWith(color: color.withOpacity(0.9)),
        selectedDateStyle: style.copyWith(color: onColor),
        disabledDateStyle: style.copyWith(color: color.withOpacity(0.3)),
        currentDateStyle: style.copyWith(color: color.withOpacity(0.9)),
        displayedPeriodTitle: style.apply(color: color.withOpacity(1), fontSizeDelta: 4),
        dayHeaderStyle: DayHeaderStyle(textStyle: style.copyWith(color: color.withOpacity(1))),
        selectedSingleDateDecoration: BoxDecoration(color: color.withOpacity(0.9), shape: BoxShape.circle),
        nextIcon: Icon(Icons.chevron_right_rounded, color: color),
        prevIcon: Icon(Icons.chevron_left_rounded, color: color),
      ),
    );
  }
}
