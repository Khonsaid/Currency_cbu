part of 'main_bloc.dart';

abstract class MainEvent {}

class LoadDataEvent extends MainEvent {}

class SearchByDateEvent extends MainEvent {
  final String date;

  SearchByDateEvent(this.date);
}

class OpenCalculateEvent extends MainEvent {
  final CurrencyResponse data;

  OpenCalculateEvent(this.data);
}

class ChangeLang extends MainEvent {
  String lang;

  ChangeLang(this.lang);
}

