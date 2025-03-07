import 'package:zayed3ndk/app_config.dart';
import 'package:zayed3ndk/data_model/flash_deal_response.dart';
import 'package:zayed3ndk/helpers/shared_value_helper.dart';
import 'package:zayed3ndk/repositories/api-request.dart';

import '../helpers/system_config.dart';

class FlashDealRepository {
  Future<FlashDealResponse> getFlashDeals() async {
    String url = ("${AppConfig.BASE_URL}/flash-deals");
    final response = await ApiRequest.get(
      url: url,
      headers: {
        "App-Language": app_language.$!,
      },
    );

    return flashDealResponseFromJson(response.body.toString());
  }

  Future<FlashDealResponse> getFlashDealInfo(slug) async {
    String url = ("${AppConfig.BASE_URL}/flash-deals/info/$slug");
    final response = await ApiRequest.get(
      url: url,
      headers: {
        "App-Language": app_language.$!,
        "Currency-Code": SystemConfig.systemCurrency!.code!,
        "Currency-Exchange-Rate":
            SystemConfig.systemCurrency!.exchangeRate.toString(),
      },
    );
    return flashDealResponseFromJson(response.body.toString());
  }
}
