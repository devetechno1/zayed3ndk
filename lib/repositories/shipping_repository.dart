import 'dart:convert';

import 'package:zayed3ndk/app_config.dart';
import 'package:zayed3ndk/data_model/delivery_info_response.dart';
import 'package:zayed3ndk/helpers/shared_value_helper.dart';
import 'package:zayed3ndk/repositories/api-request.dart';

class ShippingRepository {
  Future<dynamic> getDeliveryInfo() async {
    String url = ("${AppConfig.BASE_URL}/delivery-info");

    var post_body;
    if (guest_checkout_status.$ && !is_logged_in.$) {
      post_body = jsonEncode({"temp_user_id": temp_user_id.$});
    } else {
      post_body = jsonEncode({"user_id": user_id.$});
    }

    final response = await ApiRequest.post(
      url: url,
      body: post_body,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },
    );

    return deliveryInfoResponseFromJson(response.body);
  }
}
