import 'package:flutter/material.dart';
import '../constants.dart';

/// Creates a rounded button with customizable text, appearance, and behavior.
///
/// Parameters:
///   - [text]: The text to display on the button. Defaults to "Text" if not provided.
///   - [onPressed]: The callback function to be invoked when the button is pressed. Required.
///   - [expand]: Whether the button should expand to fill available horizontal space. Defaults to false.
///   - [padding]: The padding for the button. Defaults to half of `xSize`.
///   - [backgroundColor]: The background color of the button. Defaults to `xPrimary`.
///   - [textStyle]: The text style of the button text. Defaults to a modified version of `xTheme.textTheme.headlineMedium`.
///
/// Example Usage:
/// ```dart
/// xRoundedButton(
///   text: "Click Me",
///   onPressed: () {
///     // Handle button press
///   },
///   expand: true,
///   padding: EdgeInsets.all(16.0),
///   backgroundColor: Colors.blue,
///   textStyle: TextStyle(color: Colors.white),
/// )
/// ```
///
/// Default Values:
///   - [expand]: false
///   - [padding]: Half of `xSize`
///   - [backgroundColor]: `xPrimary`
///   - [textStyle]: Modified `xTheme.textTheme.headlineMedium` with color `xOnPrimary`

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
      height: (widget.textStyle ?? xTheme.textTheme.headlineMedium)!.fontSize!*2.5,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(0,0),
          backgroundColor: widget.enabled?(widget.backgroundColor ?? xPrimary):Colors.grey.withOpacity(0.7),
          padding: widget.padding ??  const EdgeInsets.symmetric(horizontal: xSize / 2),
          shadowColor: Colors.transparent
        ),
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
