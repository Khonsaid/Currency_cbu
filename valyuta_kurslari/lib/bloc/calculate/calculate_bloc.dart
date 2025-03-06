import 'package:bloc/bloc.dart';

import '../../data/source/remote/response/currency_response.dart';

part 'calculate_event.dart';
part 'calculate_state.dart';

class CalculateBloc extends Bloc<CalculateEvent, CalculateState> {
  CalculateBloc() : super(CalculateState()) {
    on<SelectedDataEvent>((event, emit) {
      emit(state.copyWith(selectedData: event.data, convertedSum: '0', inputSum: '0'));
    });

    on<SwipeConvertEvent>((event, emit) {
      var temp = state.inputSum;
      emit(state.copyWith(
          isReversed: !(state.isReversed ?? false), inputSum: state.convertedSum, convertedSum: temp));
    });

    on<InputSumEvent>((event, emit) {
      print('TTT input ${event.sum}');

      if (event.sum.isEmpty) {
        emit(state.copyWith(inputSum: event.sum, convertedSum: '0'));
      } else {
        final inputSum = double.tryParse(event.sum) ?? 0;
        final rate = double.tryParse(state.selectedData!.rate ?? "0") ?? 1;

        // Calculate based on direction
        final convertedSum = (state.isReversed ?? false)
            ? (inputSum / rate) // Reverse calculation
            : (inputSum * rate); // Normal calculation

        // Natijani formatlaymiz
        String formattedSum = '';

        if (convertedSum.abs() < 0.000001) {  // Juda kichik sonlar uchun (0.000001 dan kichik)
          // Ilmiy formatda ko'rsatamiz (masalan: 1e-7)
          formattedSum = convertedSum.toStringAsExponential(6);
        } else if (convertedSum.abs() < 1) { // 1 dan kichik sonlar uchun
          // Muhim raqamlarni saqlab qolamiz
          formattedSum = convertedSum.toStringAsPrecision(6);
        } else {  // Oddiy sonlar uchun
          // Kerakli o'nlik kasrlar sonini aniqlaymiz
          formattedSum = convertedSum.toStringAsFixed(_getAppropriateDecimals(convertedSum));
        }

        emit(state.copyWith(inputSum: event.sum, convertedSum: formattedSum));
      }
    });
  }

// O'nlik kasrlar sonini aniqlash uchun yordamchi funksiya
  int _getAppropriateDecimals(double number) {
    String numStr = number.toString();

    // Agar butun son bo'lsa, 0 qaytaramiz
    if (number % 1 == 0) return 0;

    // O'nlik kasrlar uchun tahlil qilamiz
    int decimalPlaces = 2; // Standart 2 ta o'nlik kasr

    if (numStr.contains('.')) {
      String decimal = numStr.split('.')[1];
      // Agar muhim raqamlar bo'lsa, o'nlik kasrlar sonini oshiramiz
      for (int i = 0; i < decimal.length; i++) {
        if (decimal[i] != '0') {
          decimalPlaces = i + 1 > 2 ? i + 1 : 2;
          break;
        }
      }
    }
    // Maksimum 6 ta o'nlik kasrgacha cheklaymiz
    return decimalPlaces > 6 ? 6 : decimalPlaces;
  }
}
