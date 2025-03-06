extension MonetFormat on String {
  String formatToMoney({String currency = ""}) {
    // Agar son o‘nlik kasr bo‘lsa, uni butun va kasr qismlarga ajratamiz
    List<String> parts = split('.');

    // Butun son qismini teskari tartibda 3 xonadan ajratamiz
    String integerPart = parts[0].split('').reversed.join();
    String spacedInteger = integerPart.replaceAllMapped(RegExp(r".{3}"), (match) => "${match.group(0)} ");
    String formattedInteger = spacedInteger.split('').reversed.join().trim();

    // Agar kasr qismi mavjud bo‘lsa, uni qo‘shamiz
    String formattedNumber = parts.length > 1 ? "$formattedInteger.${parts[1]}" : formattedInteger;
    return formattedNumber + currency;
  }
}
