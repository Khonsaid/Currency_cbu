part of 'calculate_bloc.dart';

class CalculateState {
  final CurrencyResponse? selectedData;
  final String? lang;
  final bool? isReversed;
  final String? convertedSum; // Hisoblangan natija
  final String? inputSum; // Foydalanuvchi kiritgan summa

  CalculateState({this.inputSum, this.convertedSum, this.isReversed, this.selectedData, this.lang});

  CalculateState copyWith(
          {String? inputSum,
          String? convertedSum,
          bool? isReversed,
          String? lang,
          CurrencyResponse? selectedData}) =>
      CalculateState(
          inputSum: inputSum ?? this.inputSum,
          convertedSum: convertedSum ?? this.convertedSum,
          isReversed: isReversed ?? this.isReversed,
          selectedData: selectedData ?? this.selectedData,
          lang: lang ?? this.lang);
}
