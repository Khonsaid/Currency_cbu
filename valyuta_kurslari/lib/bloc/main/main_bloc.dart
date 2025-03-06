import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:valyuta_kurslari/data/source/remote/response/currency_response.dart';
import 'package:valyuta_kurslari/data/source/remote/service/currency_service.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState(lang: 'uz')) {
    on<LoadDataEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: Status.loading));
        final result = await CurrencyService.getCurrency();
        emit(state.copyWith(status: Status.success, data: result, currDate: result.first.date));
      } on DioException catch (e) {
        print("TTT LoadDataEvent error ${e.message}");
        emit(state.copyWith(status: Status.error, errorMessage: e.message));
      }
    });
    on<OpenCalculateEvent>((event, emit) {});

    on<SearchByDateEvent>((event, emit) async {
      print("TTT OpenCalculateEvent ${event.date}");

      try {
        emit(state.copyWith(status: Status.loading));
        final result = await CurrencyService.getCurrencyByDate(event.date);
        emit(state.copyWith(status: Status.success, data: result, currDate: result.first.date));
        emit(state.copyWith(status: Status.success));
      } on DioException catch (e) {
        emit(state.copyWith(status: Status.error, errorMessage: e.message));
      }
    });
    on<ChangeLang>((event, emit) {
      if (event.lang == 'uz') {
        emit(state.copyWith(lang: 'uz'));
      } else if (event.lang == 'ru') {
        emit(state.copyWith(lang: 'ru'));
      } else if (event.lang == 'en') {
        emit(state.copyWith(lang: 'en'));
      }
    });
  }
}
