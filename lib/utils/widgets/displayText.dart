import 'package:flutter/material.dart';
import 'package:pawrapet/utils/constants.dart';

class BulletText extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final Widget? textWidget;
  final double? gap;

  const BulletText({this.textWidget, this.text, this.style, this.gap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "●",
          style: style??xTheme.textTheme.bodySmall,
        ), // Bullet point icon
        SizedBox(width: gap ?? xSize / 4), // Space between bullet point and text
        if (textWidget != null)
          Flexible(
            child: textWidget!,
          ),
        if (text != null)
          Flexible(
            child: Text(
              text!,
              style: style??xTheme.textTheme.bodySmall,
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

// rich text
RichText xTextWithBold(String input, {TextStyle? style}) {
  List<TextSpan> textSpans = [];
  RegExp regex = RegExp(r'\*\*(.*?)\*\*');

  int currentIndex = 0;
  for (RegExpMatch match in regex.allMatches(input)) {
    // Add the text before the match
    if (currentIndex < match.start) {
      textSpans.add(
        TextSpan(text: input.substring(currentIndex, match.start)),
      );
    }
    // Add the bolded text
    textSpans.add(
      TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
    currentIndex = match.end;
  }
  // Add any remaining text after the last match
  if (currentIndex < input.length) {
    textSpans.add(
      TextSpan(text: input.substring(currentIndex, input.length)),
    );
  }
  return RichText(
    text: TextSpan(
      style: style??xTheme.textTheme.bodyMedium!.apply(color: xPrimary.withOpacity(0.9)),
      children: textSpans,
    ),
  );
}