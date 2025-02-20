import 'package:zayed3ndk/app_config.dart';
import 'package:zayed3ndk/data_model/pickup_points_response.dart';
import 'package:zayed3ndk/repositories/api-request.dart';

class PickupPointRepository {
  Future<PickupPointListResponse> getPickupPointListResponse() async {
    String url = ('${AppConfig.BASE_URL}/pickup-list');

    final response = await ApiRequest.get(url: url);

    return pickupPointListResponseFromJson(response.body);
  }
}
