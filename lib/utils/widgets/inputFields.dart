import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
import 'package:pawrapet/utils/extensions/string.dart';
import 'package:pawrapet/utils/functions/common.dart';
import '../constants.dart';
import 'displayText.dart';

class XTextField extends StatefulWidget {
  final TextStyle? textStyle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hintText;
  final String? initialValue;
  final int? lines;
  final Color? backgroundColor;
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
    this.backgroundColor,
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
            fillColor: widget.backgroundColor ?? xSecondary.withOpacity(0.8),
            hintText: widget.hintText,
            hintMaxLines: widget.lines ?? 1,
            hintStyle: (widget.textStyle ?? xTheme.textTheme.bodyLarge)!.copyWith(color: xOnSecondary.withOpacity(0.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: xSize / 3, vertical: xSize / 3),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: widget.backgroundColor ?? xSecondary),
              borderRadius: BorderRadius.circular(xSize2),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: widget.backgroundColor ?? xSecondary),
              borderRadius: BorderRadius.circular(xSize2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: widget.backgroundColor ?? xSecondary),
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
  final Color? fillColor;
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
    this.fillColor,
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

class XDropDownChip extends StatefulWidget {
  final TextStyle? textStyle;
  final Color? fillColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hintText;
  final String? initialValue;
  final Function? onSelected;
  final Function? onTap;
  final FocusNode? focusNode;
  final List<String>? autofillHints;
  List<String> list;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;

  XDropDownChip({
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
    this.onTap,
    this.focusNode,
    this.autofillHints,
    this.fillColor,
  }) : super(key: key);

  @override
  State<XDropDownChip> createState() => _XDropDownChipState();
}

class _XDropDownChipState extends State<XDropDownChip> {
  FocusNode focusNode = FocusNode();
  bool expanded = false;
  List<String> displayList = [];
  String? selectedText;
  late double expandedHeight;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
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
    controller.text = "";
    setState(() {});
    xPrint("I ran");
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            width: expanded ? xWidth : xSize * 2.5,
            height: xSize * 0.9,
            child: TextField(
              controller: controller,
              enabled: widget.enabled ?? true,
              style: widget.textStyle ?? xTheme.textTheme.labelLarge!.copyWith(color: xPrimary.withOpacity(0.9)),
              focusNode: focusNode,
              decoration: InputDecoration(
                filled: true,
                isDense: true,
                fillColor: xPrimary.withOpacity(0.2),
                hintText: widget.hintText,
                hintStyle: (widget.textStyle ?? xTheme.textTheme.labelLarge)!.copyWith(color: xPrimary.withOpacity(0.8)),
                contentPadding: EdgeInsets.symmetric(horizontal: xSize1, vertical: xSize1 / 3).copyWith(right: xSize1 / 4),
                constraints: BoxConstraints(minHeight: xSize, maxHeight: xSize),
                suffixIconConstraints: BoxConstraints(minWidth: xSize, minHeight: xSize),
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0, color: xPrimary.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(xSize2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 0, color: xPrimary.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(xSize2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 0, color: xPrimary.withOpacity(0.2)),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(xSize2)),
                ),
                suffixIcon: InkWell(
                  onTap: () {
                    (focusNode.hasFocus) ? focusNode.unfocus() : focusNode.requestFocus();
                  },
                  child: Icon(
                    expanded ? Icons.keyboard_arrow_up_rounded : Icons.add_rounded,
                    size: xSize * 0.8,
                    color: xPrimary.withOpacity(1),
                  ),
                ),
              ),
              keyboardType: widget.keyboardType ?? TextInputType.text,
              textInputAction: widget.textInputAction ?? TextInputAction.next,
              autofillHints: widget.autofillHints,
              inputFormatters: widget.inputFormatters,
              onTapOutside: (event) {
                // setState(() {
                //   focusNode.unfocus();
                // });
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
          ),
          // the list
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            height: expanded ? expandedHeight : 0,
            width: expanded ? xWidth : xSize * 2.5,
            decoration: BoxDecoration(
              color: xPrimary.withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(xSize2)),
            ),
            child: (displayList.isEmpty)
                ? Container(
                    alignment: Alignment.bottomCenter,
                    width: xWidth,
                    padding: const EdgeInsets.symmetric(horizontal: xSize / 3, vertical: xSize / 3),
                    child: Text(
                      "No result found. Try changing your search.",
                      style: xTheme.textTheme.labelLarge!.copyWith(color: xPrimary.withOpacity(0.7)),
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
                                  style: xTheme.textTheme.labelLarge!.copyWith(
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
        ],
      );
    } catch (e) {
      return Text("$e");
    }
  }
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

// it cannot be made final because the list keeps on changing in some cases
class XWrapChipsWithHeadingAndAddFromList extends StatefulWidget {
  String heading;
  List<String> list;
  /// this list will be updated in the parent widget as well
  List<String> initialList;
  Function(List<String>) onChanged;

  XWrapChipsWithHeadingAndAddFromList({super.key, required this.heading, required this.list, required this.initialList, required this.onChanged});

  @override
  State<XWrapChipsWithHeadingAndAddFromList> createState() => _XWrapChipsWithHeadingAndAddFromListState();
}

class _XWrapChipsWithHeadingAndAddFromListState extends State<XWrapChipsWithHeadingAndAddFromList> {
  List<String> selectedList = [];

  @override
  void initState() {
    selectedList = [...widget.initialList];
    for (String i in selectedList) {
      widget.list.remove(i);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant XWrapChipsWithHeadingAndAddFromList oldWidget) {
    if (oldWidget.list != widget.list) {
      selectedList = [...widget.initialList];
      for (String i in selectedList) {
        if (widget.list.contains(i)) {
          widget.list.remove(i);
        } else {
          selectedList.remove(i);
        }
      }
    }
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    xPrint("selectedList -${widget.heading} $selectedList", header: "chips");
    return Wrap(
      runSpacing: xSize / 4,
      spacing: xSize / 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...[widget.heading],
        ...selectedList,
        ...["add"]
      ].map((value) {
        if (value == widget.heading) {
          return Text(
            value,
            style: xTheme.textTheme.labelLarge!.apply(color: xPrimary.withOpacity(0.9), fontWeightDelta: 1),
            overflow: TextOverflow.ellipsis,
          );
        }
        if (value == "add") {
          if (widget.list.isEmpty && selectedList.isEmpty) {
            return Container(
              decoration: BoxDecoration(
                color: xOnError.withOpacity(0.4),
                borderRadius: BorderRadius.circular(xSize2),
              ),
              padding: EdgeInsets.symmetric(horizontal: xSize1, vertical: xSize1 / 3),
              child: Text(
                "not found",
                style: xTheme.textTheme.labelLarge!.apply(color: xPrimary.withOpacity(0.9)),
              ),
            );
          }
          if (widget.list.isEmpty) {
            return const Text("");
          }
          return XDropDownChip(
            list: widget.list,
            onSelected: (v) {
              selectedList.add(v);
              widget.list.remove(v);
              setState(() {});
              widget.onChanged(selectedList);
            },
            hintText: "Add",
          );
        }
        return InkWell(
          onTap: (){
            selectedList.remove(value);
            widget.list.add(value);
            widget.onChanged(selectedList);
            setState(() {});
          },
          child: Container(
            decoration: BoxDecoration(
              color: xPrimary.withOpacity(0.4),
              borderRadius: BorderRadius.circular(xSize2),
            ),
            padding: EdgeInsets.symmetric(horizontal: xSize1, vertical: xSize1 / 3).copyWith(right: xSize1 / 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: xWidth * 0.35),
                  child: Text(
                    value.trim(),
                    style: xTheme.textTheme.labelLarge!.apply(color: xOnPrimary.withOpacity(0.9)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.close_rounded,
                  color: xOnPrimary.withOpacity(0.7),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class XSearchFieldWithFilter extends StatefulWidget {
  final TextStyle? textStyle;
  final Color? fillColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hintText;
  final String? initialValue;
  final Function onChanged;
  final Function? onTap;
  final FocusNode? focusNode;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;

  XSearchFieldWithFilter({
    Key? key,
    this.enabled,
    this.textStyle,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.hintText,
    this.initialValue,
    required this.onChanged,
    this.onTap,
    this.focusNode,
    this.fillColor,
  }) : super(key: key);

  @override
  State<XSearchFieldWithFilter> createState() => _XSearchFieldWithFilterState();
}

class _XSearchFieldWithFilterState extends State<XSearchFieldWithFilter> {
  FocusNode focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    focusNode = widget.focusNode ?? focusNode;
    focusNode.addListener(_handleFocus);
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.removeListener(_handleFocus);
    focusNode.dispose();
    super.dispose();
  }

  void _handleFocus() {
    // this set state is only changing the values
    setState(() {});
    xPrint("I ran");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          enabled: widget.enabled ?? true,
          style: widget.textStyle ?? xTheme.textTheme.bodyLarge!.copyWith(color: xOnSecondary.withOpacity(1)),
          focusNode: focusNode,
          controller: textEditingController,
          decoration: InputDecoration(
            filled: true,
            isDense: true,
            fillColor: xPrimary.withOpacity(0.1),
            hintText: widget.hintText ?? "Search",
            hintStyle: (widget.textStyle ?? xTheme.textTheme.bodyLarge)!.copyWith(color: xOnSecondary.withOpacity(0.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: xSize / 4, vertical: 0),
            // padding in the left or right is already 0,
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
            prefixIcon: (!focusNode.hasFocus)
                ? SizedBox(
                    child: InkWell(
                      onTap: () {},
                      child: Icon(
                        // focusNode.hasFocus ? CupertinoIcons.clear : CupertinoIcons.search,
                        Icons.search_rounded,
                        size: xSize,
                        color: xPrimary.withOpacity(0.3),
                      ),
                    ),
                  )
                : null,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (focusNode.hasFocus) SizedBox().horizontal(size: xSize / 6),
                if (focusNode.hasFocus)
                  InkWell(
                    onTap: () {
                      textEditingController.text = "";
                      // todo call the onChanged here
                      setState(() {});
                    },
                    child: Icon(
                      // focusNode.hasFocus ? CupertinoIcons.clear : CupertinoIcons.search,
                      Icons.close,
                      size: xSize,
                      color: xPrimary.withOpacity(0.7),
                    ),
                  ),
                SizedBox().horizontal(size: xSize / 6),
                InkWell(
                  onTap: () {
                    // todo
                  },
                  child: Icon(
                    // CupertinoIcons.slider_horizontal_3,
                    Icons.filter_alt_rounded,
                    size: xSize,
                    color: xPrimary.withOpacity(0.7),
                  ),
                ),
                // SizedBox().horizontal(size: xSize / 6),
              ],
            ),
          ),
          keyboardType: widget.keyboardType ?? TextInputType.text,
          textInputAction: widget.textInputAction ?? TextInputAction.search,
          inputFormatters: widget.inputFormatters,
          onTap: () {
            if (widget.onTap != null) widget.onTap!();
          },
          onTapOutside: (event) {
            setState(() {
              focusNode.unfocus();
            });
          },
          onChanged: (value) {
            String? temp = value.handleEmpty;
            widget.onChanged(temp);
            setState(() {});
          },
        ),
      ],
    );
  }
}

class XTextFieldWithPicker extends StatefulWidget {
  final TextStyle? textStyle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hintText;
  final Color? backgroundColor;
  final Function onTextChangedFn;
  final Function onFilePathsChangedFn;

  /// list of paths as input
  List<String>? autofillHints;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;

  XTextFieldWithPicker({
    Key? key,
    this.enabled,
    this.textStyle,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.hintText,
    required this.onTextChangedFn,
    this.backgroundColor,
    required this.onFilePathsChangedFn,
    this.autofillHints,
  }) : super(key: key);

  @override
  State<XTextFieldWithPicker> createState() => _XTextFieldWithPickerState();
}

class _XTextFieldWithPickerState extends State<XTextFieldWithPicker> {
  late TextEditingController controller;
  FocusNode focusNode = FocusNode();
  List<String?> paths = [];

  @override
  void initState() {
    controller = TextEditingController(text: "");
    focusNode = focusNode;
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (paths.isNotEmpty)
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            runSpacing: xSize1 / 2,
            spacing: xSize1 / 2,
            children: paths.map((path) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: xSize / 4, vertical: xSize / 6),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(xSize), color: const Color(0xFFcec3c6).withOpacity(0.5)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: xSize * 5.5),
                      child: Text(
                        path.extractFileNameFromPath()!,
                        style: xTheme.textTheme.labelMedium!.apply(
                          fontSizeDelta: -2,
                          color: xOnSecondary.withOpacity(0.9),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox().horizontal(size: xSize / 6),
                    InkWell(
                      onTap: () {
                        setState(() {
                          paths.remove(path);
                        });
                      },
                      child: const Icon(
                        Icons.close_rounded,
                        size: xSize / 2,
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        if (paths.isNotEmpty) const SizedBox().vertical(size: xSize1 / 2),
        TextField(
          enabled: widget.enabled ?? true,
          controller: controller,
          style: widget.textStyle ?? xTheme.textTheme.bodyLarge!.copyWith(color: xOnSecondary.withOpacity(1)),
          focusNode: focusNode,
          decoration: InputDecoration(
              filled: true,
              isDense: true,
              fillColor: widget.backgroundColor ?? xSecondary.withOpacity(0.8),
              hintText: widget.hintText,
              hintMaxLines: 1,
              hintStyle: (widget.textStyle ?? xTheme.textTheme.bodyLarge)!.copyWith(color: xOnSecondary.withOpacity(0.5)),
              contentPadding: const EdgeInsets.symmetric(horizontal: xSize / 4, vertical: xSize / 4).copyWith(left: 0),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 0, color: widget.backgroundColor ?? xSecondary),
                borderRadius: BorderRadius.circular(xSize2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 0, color: widget.backgroundColor ?? xSecondary),
                borderRadius: BorderRadius.circular(xSize2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 0, color: widget.backgroundColor ?? xSecondary),
                borderRadius: BorderRadius.circular(xSize2),
              ),
              prefixIconConstraints: const BoxConstraints(
                maxWidth: xSize1 * 2 + xSize * 0.6,
                minWidth: xSize1 * 2 + xSize * 0.6,
                minHeight: xSize * 1.3,
              ),
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox().horizontal(size: xSize1),
                  InkWell(
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
                      if (result != null) {
                        paths.addAll(result.paths);
                      } else {
                        // User canceled the picker
                      }
                      setState(() {});
                    },
                    child: SizedBox(
                      width: xSize * 0.7,
                      child: FittedBox(
                        child: Icon(
                          CupertinoIcons.paperclip,
                          color: xOnSecondary.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          keyboardType: widget.keyboardType ?? TextInputType.multiline,
          textInputAction: widget.textInputAction ?? TextInputAction.newline,
          minLines: 1,
          maxLines: 3,
          onChanged: widget.onTextChangedFn as String? Function(String?)?,
          autofillHints: widget.autofillHints,
          inputFormatters: widget.inputFormatters,
          onTapOutside: (event) {
            setState(() {
              focusNode.unfocus();
            });
          },
        ),
      ],
    );
  }
}
