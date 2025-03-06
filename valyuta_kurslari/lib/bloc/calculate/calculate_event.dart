part of 'calculate_bloc.dart';

abstract class CalculateEvent {}

class SelectedDataEvent extends CalculateEvent {
  CurrencyResponse data;

  SelectedDataEvent(this.data);
}

class SwipeConvertEvent extends CalculateEvent {}

class InputSumEvent extends CalculateEvent {
  String sum;

  InputSumEvent(this.sum);
}
