import 'package:zayed3ndk/app_config.dart';
import 'package:zayed3ndk/data_model/search_suggestion_response.dart';
import 'package:zayed3ndk/helpers/shared_value_helper.dart';
import 'package:zayed3ndk/repositories/api-request.dart';

class SearchRepository {
  Future<List<SearchSuggestionResponse>> getSearchSuggestionListResponse(
      {query_key = "", type = "product"}) async {
    String url =
        ("${AppConfig.BASE_URL}/get-search-suggestions?query_key=$query_key&type=$type");
    final response = await ApiRequest.get(
      url: url,
      headers: {
        "App-Language": app_language.$!,
      },
    );
    return searchSuggestionResponseFromJson(response.body);
  }
}
