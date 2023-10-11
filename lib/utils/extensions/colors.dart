import 'dart:ui';

extension ColorModifications on Color{
  Color getAdjustColor(double amount) {
    Map<String, int> colors = {
      'r': red,
      'g': green,
      'b': blue
    };

    colors = colors.map((key, value) {
      if (value + amount < 0) {
        return MapEntry(key, 0);
      }
      if (value + amount > 255) {
        return MapEntry(key, 255);
      }
      return MapEntry(key, (value + amount).floor());
    });
    return Color.fromRGBO(colors['r']!, colors['g']!, colors['b']!, 1);
  }
}