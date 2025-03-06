import 'package:dio/dio.dart';
import 'package:valyuta_kurslari/data/source/remote/response/currency_response.dart';

class CurrencyService {
  static final dio = Dio(BaseOptions(
    baseUrl: 'https://cbu.uz/uz/',
    receiveTimeout: Duration(seconds: 30),
    connectTimeout: Duration(seconds: 30),
    sendTimeout: Duration(seconds: 30),
    receiveDataWhenStatusError: true,
  ));

  static Future<List<CurrencyResponse>> getCurrency() async {
    try {
      final response = await dio.get('arkhiv-kursov-valyut/json/');
      return (response.data as List).map((element) => CurrencyResponse.fromJson(element)).toList();
    } on DioException {
      rethrow;
    }
  }

  static Future<List<CurrencyResponse>> getCurrencyByDate(String date) async {
    try {
      final response = await dio.get('https://cbu.uz/uz/arkhiv-kursov-valyut/json/all/$date/');
      return (response.data as List).map((element) => CurrencyResponse.fromJson(element)).toList();
    } on DioException {
      rethrow;
    }
  }
}
