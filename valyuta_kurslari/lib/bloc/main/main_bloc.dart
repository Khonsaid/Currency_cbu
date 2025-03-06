import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:valyuta_kurslari/data/source/locel/hive_helper.dart';
import 'package:valyuta_kurslari/data/source/remote/response/currency_response.dart';
import 'package:valyuta_kurslari/data/source/remote/service/currency_service.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState(lang: HiveHelper.get())) {
    on<LoadDataEvent>((event, emit) async {
      final lang = HiveHelper.get();
      try {
        emit(state.copyWith(status: Status.loading, lang: lang));
        final result = await CurrencyService.getCurrency();
        emit(state.copyWith(status: Status.success, data: result, currDate: result.first.date));
      } on DioException catch (e) {
        emit(state.copyWith(status: Status.error, errorMessage: e.message));
      }
    });
    on<OpenCalculateEvent>((event, emit) {});

    on<SearchByDateEvent>((event, emit) async {
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
      HiveHelper.set(event.lang);
      final lang = HiveHelper.get();
      emit(state.copyWith(lang: lang));
    });
  }
}
