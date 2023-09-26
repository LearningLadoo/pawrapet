import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:pawrapet/utils/extensions/dateTime.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/extensions/string.dart';
import 'package:pawrapet/utils/functions/common.dart';
import '../constants.dart';

class XTextField extends StatefulWidget {
  final TextStyle? textStyle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hintText;
  final String? initialValue;
  final int? lines;
  final Function onChangedFn;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  List<String>? autofillHints;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;

  XTextField({
    Key? key,
    this.enabled,
    this.textStyle,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.hintText,
    this.initialValue,
    this.lines,
    required this.onChangedFn,
    this.onEditingComplete,
    this.focusNode,
    this.autofillHints,
  }) : super(key: key);

  @override
  State<XTextField> createState() => _XTextFieldState();
}

class _XTextFieldState extends State<XTextField> {
  late TextEditingController controller;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    controller = TextEditingController(text: widget.initialValue);
    focusNode = widget.focusNode ?? focusNode;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          enabled: widget.enabled ?? true,
          controller: controller,
          style: widget.textStyle ?? xTheme.textTheme.bodyLarge!.copyWith(color: xOnSecondary.withOpacity(1)),
          focusNode: focusNode,
          decoration: InputDecoration(
            filled: true,
            isDense: true,
            fillColor: xSecondary.withOpacity(0.8),
            hintText: widget.hintText,
            hintMaxLines: widget.lines ?? 1,
            hintStyle: (widget.textStyle ?? xTheme.textTheme.bodyLarge)!.copyWith(color: xOnSecondary.withOpacity(0.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: xSize / 3, vertical: xSize / 3),
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 0, color: xSecondary),
              borderRadius: BorderRadius.circular(xSize2),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 0, color: xSecondary),
              borderRadius: BorderRadius.circular(xSize2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 0, color: xSecondary),
              borderRadius: BorderRadius.circular(xSize2),
            ),
          ),
          keyboardType: widget.keyboardType ?? TextInputType.text,
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          minLines: widget.lines ?? 1,
          maxLines: widget.lines ?? 1,
          onChanged: widget.onChangedFn as String? Function(String?)?,
          onEditingComplete: widget.onEditingComplete,
          autofillHints: widget.autofillHints,
          inputFormatters: widget.inputFormatters,
          onTapOutside: (event) {
            setState(() {
              focusNode.unfocus();
            });
          },
        ),
        if (widget.autofillHints != null) const SizedBox().vertical(size: xSize / 6),
        if (widget.autofillHints != null)
          SizedBox(
            width: xWidth,
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: xSize / 6,
              runSpacing: xSize / 6,
              children: [
                // Opacity(
                //   opacity: 0.6,
                //     child: Padding(
                //       padding: EdgeInsets.symmetric(horizontal: xSize/6, vertical: xSize/8),
                //       child: Text("suggestions :",style: xTheme.textTheme.labelMedium,),
                //     )),
                ...widget.autofillHints!
                    .map((i) => InkWell(
                          onTap: () {
                            controller.text = "${controller.text}${controller.text == "" ? "" : ","} $i";
                            widget.onChangedFn!(controller.text);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: xPrimary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(xSize2 / 2),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: xSize / 6, vertical: xSize / 8),
                            child: Text(
                              i,
                              style: xTheme.textTheme.labelMedium!.apply(
                                color: xPrimary.withOpacity(0.75),
                              ),
                            ),
                          ),
                        ))
                    .toList()
              ],
            ),
          )
      ],
    );
  }
}

class XDropDownField extends StatefulWidget {
  final TextStyle? textStyle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hintText;
  final String? initialValue;
  final Function? onSelected;
  final Function onTap;
  final FocusNode? focusNode;
  final List<String>? autofillHints;
  List<String> list;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;

  XDropDownField({
    Key? key,
    required this.list,
    this.enabled,
    this.textStyle,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.hintText,
    this.initialValue,
    this.onSelected,
    required this.onTap,
    this.focusNode,
    this.autofillHints,
  }) : super(key: key);

  @override
  State<XDropDownField> createState() => _XDropDownFieldState();
}

class _XDropDownFieldState extends State<XDropDownField> {
  late TextEditingController controller;
  FocusNode focusNode = FocusNode();
  bool expanded = false;
  List<String> displayList = [];
  String? selectedText;
  late double expandedHeight;

  @override
  void initState() {
    controller = TextEditingController(text: widget.initialValue);
    focusNode = widget.focusNode ?? focusNode;
    focusNode.addListener(_handleFocus);
    displayList = widget.list;
    if (displayList.length < 3) {
      expandedHeight = xSize * 2;
    } else {
      expandedHeight = xSize * 3;
    }
    super.initState();
  }

  @override
  void dispose() {
    focusNode.removeListener(_handleFocus);
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  void _handleFocus() {
    expanded = focusNode.hasFocus;
    // to refresh the list and properties
    displayList = widget.list;
    if (displayList.length < 3) {
      expandedHeight = xSize * 2;
    } else {
      expandedHeight = xSize * 3;
    }
    // avoid wrong selected Text because of on changed or change in the list
    selectedText = displayList.contains(selectedText.toString()) ? selectedText : null;
    controller.text = selectedText ?? "";
    setState(() {});
    xPrint("I ran");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          enabled: widget.enabled ?? true,
          controller: controller,
          style: widget.textStyle ?? xTheme.textTheme.bodyLarge!.copyWith(color: xOnSecondary.withOpacity(1)),
          focusNode: focusNode,
          decoration: InputDecoration(
            filled: true,
            isDense: true,
            fillColor: xSecondary.withOpacity(0.8),
            hintText: widget.hintText,
            hintStyle: (widget.textStyle ?? xTheme.textTheme.bodyLarge)!.copyWith(color: xOnSecondary.withOpacity(0.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: xSize / 3, vertical: xSize / 3),
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 0, color: xSecondary),
              borderRadius: BorderRadius.circular(xSize2),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 0, color: xSecondary),
              borderRadius: BorderRadius.circular(xSize2),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: xSecondary),
              borderRadius: BorderRadius.vertical(top: Radius.circular(xSize2)),
            ),
            suffixIcon: InkWell(
              onTap: () {
                (focusNode.hasFocus) ? focusNode.unfocus() : focusNode.requestFocus();
              },
              child: Icon(
                expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                size: xSize,
                color: xOnSecondary.withOpacity(0.5),
              ),
            ),
          ),
          keyboardType: widget.keyboardType ?? TextInputType.text,
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          autofillHints: widget.autofillHints,
          inputFormatters: widget.inputFormatters,
          onTap: () {
            widget.onTap();
          },
          onTapOutside: (event) {
            setState(() {
              focusNode.unfocus();
            });
          },
          onChanged: (value) {
            String? temp = value.handleEmpty;
            if (temp == null) {
              displayList = widget.list;
            } else {
              List<String> startList = [], containList = [];
              for (String i in widget.list) {
                if (i.toLowerCase().startsWith(temp.toLowerCase())) {
                  startList.add(i);
                } else if (i.toLowerCase().contains(temp.toLowerCase())) {
                  containList.add(i);
                }
              }
              displayList = [...startList, ...containList];
            }
            setState(() {});
          },
        ),
        // the list
        TextFieldTapRegion(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: expanded ? expandedHeight : 0,
            decoration: BoxDecoration(
              color: xSecondary.withOpacity(0.8),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(xSize2)),
            ),
            child: (displayList.isEmpty)
                ? Container(
                    alignment: Alignment.bottomCenter,
                    width: xWidth,
                    padding: const EdgeInsets.symmetric(horizontal: xSize / 3, vertical: xSize / 3),
                    child: Text(
                      "No result found. Try changing your search.",
                      style: xTheme.textTheme.bodySmall!.copyWith(color: xPrimary.withOpacity(0.7)),
                    ))
                : ListView(
                    physics: const BouncingScrollPhysics(),
                    children: displayList.map((field) {
                      return Column(
                        children: [
                          Divider(
                            height: 0,
                            color: xPrimary.withOpacity(0.1),
                          ),
                          InkWell(
                            onTap: () {
                              widget.onSelected!(field);
                              selectedText = field;
                              focusNode.nextFocus();
                            },
                            splashColor: xOnSecondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(xSize2),
                            child: Container(
                                alignment: Alignment.centerLeft,
                                width: xWidth,
                                padding: const EdgeInsets.symmetric(horizontal: xSize / 3, vertical: xSize / 6),
                                child: Text(
                                  field,
                                  style: xTheme.textTheme.bodySmall!.copyWith(
                                    color: xPrimary.withOpacity(0.9),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                          ),
                        ],
                      );
                    }).toList(),
                    // itemExtent: small,
                  ),
          ),
        ),
      ],
    );
  }
}

Widget xErrorText(BuildContext context, String message) {
  return Container(
    padding: const EdgeInsets.all(xSize / 8),
    width: xWidth,
    decoration: const BoxDecoration(
      color: xError,
      borderRadius: BorderRadius.all(Radius.circular(xSize2)),
    ),
    child: Center(
      child: Text(
        message,
        style: xTheme.textTheme.labelLarge!.apply(color: xOnError, fontSizeDelta: -1),
      ),
    ),
  );
}
Widget xInfoText(BuildContext context, String message) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: xSize / 4, vertical: xSize / 8),
    width: xWidth,
    decoration: BoxDecoration(
      color: xInfoColor,
      borderRadius: BorderRadius.all(Radius.circular(xSize2)),
    ),
    child: Center(
      child: Text(
        message,
        style: xTheme.textTheme.labelLarge!.apply(color: xOnInfoColor, fontSizeDelta: -1),
      ),
    ),
  );
}

class XOtpTextField extends StatefulWidget {
  final double height, width;
  final Function(String) onChanged;

  const XOtpTextField({super.key, required this.height, required this.width, required this.onChanged});

  @override
  State<XOtpTextField> createState() => _XOtpTextFieldState();
}

class _XOtpTextFieldState extends State<XOtpTextField> {
  late FocusNode _focusNode;
  late TextEditingController _textFieldController;

  @override
  void initState() {
    _textFieldController = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        widget.onChanged("");
        _textFieldController.clear();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextField(
        style: xTheme.textTheme.titleLarge!.copyWith(color: xPrimary.withOpacity(0.8)),
        focusNode: _focusNode,
        controller: _textFieldController,
        onChanged: (v) {
          widget.onChanged(v);
        },
        decoration: InputDecoration(
          hintText: "0",
          filled: true,
          isDense: true,
          fillColor: xSecondary.withOpacity(0.8),
          hintStyle: (xTheme.textTheme.titleLarge)!.copyWith(color: xPrimary.withOpacity(0.2)),
          contentPadding: const EdgeInsets.symmetric(horizontal: xSize / 2, vertical: xSize / 2),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: xSecondary.withOpacity(0.8)),
            borderRadius: BorderRadius.circular(xSize2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: xSecondary.withOpacity(0.8)),
            borderRadius: BorderRadius.circular(xSize2),
          ),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(xSize2), borderSide: BorderSide(color: xOnSecondary.withOpacity(0.5), width: 2)),
        ),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }
}

class XDatePickerField extends StatefulWidget {
  final TextStyle? textStyle;
  final String? hintText;
  final String? initialValue; // storing the string as dd/MM/yyyy
  final Function onSelected;
  final Function onTap;
  final bool enabled;

  const XDatePickerField({
    Key? key,
    this.enabled = true,
    this.textStyle,
    this.hintText,
    this.initialValue,
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
          width: xWidth,
          padding: const EdgeInsets.symmetric(horizontal: xSize / 3, vertical: xSize / 3),
          decoration: BoxDecoration(
            color: xSecondary.withOpacity(0.8),
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

class MultipleDayPickerScreen extends StatefulWidget {

  List<DateTime> selectedDates;
  Color? color, onColor;
  ValueChanged<List<DateTime>> onChanged;
  TextStyle? style;

  MultipleDayPickerScreen({super.key, required this.selectedDates, required this.onChanged, this.color, this.onColor, this.style});

  @override
  _MultipleDayPickerScreenState createState() => _MultipleDayPickerScreenState();
}

class _MultipleDayPickerScreenState extends State<MultipleDayPickerScreen> {
  late List<DateTime> _selectedDates;
  DateTime firstDate = DateTime.now();
  late Color color, onColor;
  late TextStyle style;
  @override
  void initState() {
    color = widget.color??xOnSecondary;
    onColor = widget.onColor??xSecondary;
    style = widget.style??xTheme.textTheme.bodySmall!;
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
