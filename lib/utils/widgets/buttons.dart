import 'package:flutter/material.dart';
import 'package:pawrapet/utils/extensions/buildContext.dart';
import '../constants.dart';


class XRoundedButton extends StatefulWidget {
  final String? text;
  final VoidCallback onPressed;
  final bool expand;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  bool enabled;

  XRoundedButton({
    Key? key,
    this.text,
    this.enabled = true,
    required this.onPressed,
    this.expand = false,
    this.padding,
    this.backgroundColor,
    this.textStyle,
  }) : super(key: key);

  @override
  _XRoundedButtonState createState() => _XRoundedButtonState();
}

class _XRoundedButtonState extends State<XRoundedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: (widget.textStyle ?? xTheme.textTheme.headlineMedium)!.fontSize! * 2.5,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(0, 0),
            backgroundColor: widget.enabled ? (widget.backgroundColor ?? xPrimary.withOpacity(0.9)) : Colors.grey.withOpacity(0.7),
            padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: xSize / 2),
            shadowColor: Colors.transparent),
        onPressed: widget.onPressed,
        child: SizedBox(
          width: widget.expand ? xWidth : null,
          child: Text(
            widget.text ?? "Text",
            textAlign: TextAlign.center,
            style: widget.textStyle ?? xTheme.textTheme.headlineMedium!.copyWith(color: xOnPrimary),
          ),
        ),
      ),
    );
  }
}

class XRoundedButtonOutlined extends StatefulWidget {
  final String? text;
  final VoidCallback onPressed;
  final bool expand;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final TextStyle? textStyle;
  bool enabled;

  XRoundedButtonOutlined({
    Key? key,
    this.text,
    this.enabled = true,
    required this.onPressed,
    this.expand = false,
    this.padding,
    this.color,
    this.textStyle,
  }) : super(key: key);

  @override
  _XRoundedButtonOutlinedState createState() => _XRoundedButtonOutlinedState();
}

class _XRoundedButtonOutlinedState extends State<XRoundedButtonOutlined> {
  late Color color;
  @override
  void initState() {
    color = widget.enabled ? (widget.color ?? xPrimary.withOpacity(0.9)) : Colors.grey.withOpacity(0.7);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: (widget.textStyle ?? xTheme.textTheme.headlineMedium)!.fontSize! * 2.5,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 0),
            padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: xSize / 2),
            side: BorderSide(width: xSize1/3, color: color),
            shadowColor: Colors.transparent),
        onPressed: widget.onPressed,
        child: SizedBox(
          width: widget.expand ? xWidth : null,
          child: Text(
            widget.text ?? "Text",
            textAlign: TextAlign.center,
            style: (widget.textStyle ?? xTheme.textTheme.headlineMedium)!.apply(color: color, fontWeightDelta: 1),
          ),
        ),
      ),
    );
  }
}

class XColoredButton extends StatefulWidget {
  Color backgroundColor;
  String text;
  VoidCallback onTap;
  TextStyle? textStyle;
  EdgeInsets? padding;
  double? textOpacity;
  bool invert;
  Color? invertedTextColor;
  XColoredButton({Key? key, required this.backgroundColor, required this.text, required this.onTap, this.textStyle, this.padding, this.textOpacity, this.invert = false, this.invertedTextColor}) : super(key: key);

  @override
  State<XColoredButton> createState() => _XColoredButtonState();
}

class _XColoredButtonState extends State<XColoredButton> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(xSize1),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          color: widget.backgroundColor,
          child: Container(
            padding: widget.padding ?? const EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 2),
            color: (!widget.invert)?widget.backgroundColor:xPrimary.withOpacity(widget.textOpacity ?? 0.7),
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: (widget.textStyle??xTheme.textTheme.bodyMedium)!.apply(color: (widget.invert)?(widget.invertedTextColor??widget.backgroundColor):(xPrimary.withOpacity(widget.textOpacity ?? 0.7)), fontWeightDelta: 1),
            ),
          ),
        ),
      ),
    );
  }
}

class XBackButton extends StatelessWidget {
  double size;
  XBackButton({Key? key, this.size = xSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pop();
      },
      child: SizedBox(
        height: size,
        child: Transform.translate(
          offset: Offset(-size*0.8/4, 0),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            size: size*0.8,
          ),
        ),
      ),
    );
  }
}
