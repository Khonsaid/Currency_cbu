extension MonetFormat on String {
  String formatToMoney({String currency = ""}) {
    String reversed = split('').reversed.join();
    String spaced = reversed.replaceAllMapped(RegExp(r".{3}"), (match) => "${match.group(0)}");
    return spaced.split('').reversed.join().trim() + currency;
  }
}
