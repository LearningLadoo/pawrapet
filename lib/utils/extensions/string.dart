extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstOfEach => this.split(" ").map((str) => str.inCaps).join(" ");
}
extension HandleValues on String? {
  String? get handleEmpty {
    if(this==null||this!.trim()=="") return null;
    return this!.trim();
  }
  int? get getIntFromString {
    if(this==null) return null;
    String numbers = "0123456789";
    String temp = "";
    for(String i in  this!.split("")){
      if(numbers.contains(i)){
        temp=temp+i;
      }
    }
    return int.parse(temp);
  }
  String removeTrailingZeros() {
    String valueString = this!;
    if (valueString.contains('.')) {
      valueString = valueString.replaceAll(RegExp(r'0*$'), '');
      valueString = valueString.replaceAll(RegExp(r'\.$'), '');
    }
    return valueString;
  }
  String? extractFileNameFromPath() {
    RegExp regex = RegExp(r'\/([^\/]+)$');
    Match? match = regex.firstMatch(this!);
    if (match != null && match.groupCount >= 1) {
      return match.group(1)!;
    } else {
      // If no match is found, return the original filePath
      return this;
    }
  }
  String? extractFileNameFromLink(){
    if (this == null) return null;
    Uri uri = Uri.parse(this!);
    // Get the file name from the path
    String fileName = uri.pathSegments.last;
    // Decoding percent-encoded characters in the file name
    fileName = Uri.decodeComponent(fileName);
    return fileName;
  }
}