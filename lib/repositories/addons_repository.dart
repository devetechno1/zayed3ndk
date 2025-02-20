import 'package:zayed3ndk/app_config.dart';
import 'package:zayed3ndk/data_model/addons_response.dart';
import 'package:zayed3ndk/repositories/api-request.dart';

class AddonsRepository {
  Future<List<AddonsListResponse>> getAddonsListResponse() async {
    // $();
    String url = ('${AppConfig.BASE_URL}/addon-list');
    final response = await ApiRequest.get(url: url);

    return addonsListResponseFromJson(response.body);
  }
}
