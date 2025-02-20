import 'package:zayed3ndk/app_config.dart';
import 'package:zayed3ndk/data_model/currency_response.dart';
import 'package:zayed3ndk/repositories/api-request.dart';

class CurrencyRepository {
  Future<CurrencyResponse> getListResponse() async {
    String url = ('${AppConfig.BASE_URL}/currencies');

    final response = await ApiRequest.get(url: url);
    return currencyResponseFromJson(response.body);
  }
}
