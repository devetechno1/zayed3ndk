import 'package:zayed3ndk/app_config.dart';
import 'package:zayed3ndk/repositories/api-request.dart';
import 'package:zayed3ndk/data_model/language_list_response.dart';
import 'package:zayed3ndk/helpers/shared_value_helper.dart';

class LanguageRepository {
  Future<LanguageListResponse> getLanguageList() async {
    String url = ("${AppConfig.BASE_URL}/languages");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$ ?? AppConfig.default_language,
    });

    return languageListResponseFromJson(response.body);
  }
}
