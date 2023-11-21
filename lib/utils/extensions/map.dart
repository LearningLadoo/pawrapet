import 'dart:convert';

extension Operations on Map {
  Map deepClone() {
    return jsonDecode(jsonEncode(this));
  }
}
