part of 'main_bloc.dart';

class MainState {
  List<CurrencyResponse>? data;
  String? errorMessage;
  String? currDate;
  String? lang;
  Status? status;

  MainState({this.lang, this.currDate, this.data, this.errorMessage, this.status});

  MainState copyWith(
          {String? lang,
          CurrencyResponse? selectedData,
          List<CurrencyResponse>? data,
          String? errorMessage,
          String? currDate,
          Status? status}) =>
      MainState(
          lang: lang ?? this.lang,
          currDate: currDate ?? this.currDate,
          status: status ?? this.status,
          data: data ?? this.data,
          errorMessage: errorMessage ?? this.errorMessage);
}

enum Status { loading, success, error }
