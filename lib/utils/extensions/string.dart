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
}