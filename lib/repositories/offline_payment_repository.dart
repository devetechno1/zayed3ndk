import 'dart:convert';

import 'package:zayed3ndk/app_config.dart';
import 'package:zayed3ndk/data_model/offline_payment_submit_response.dart';
import 'package:zayed3ndk/helpers/shared_value_helper.dart';
import 'package:zayed3ndk/middlewares/banned_user.dart';
import 'package:zayed3ndk/repositories/api-request.dart';

class OfflinePaymentRepository {
  Future<dynamic> getOfflinePaymentSubmitResponse(
      {required int? order_id,
      required String amount,
      required String name,
      required String trx_id,
      required int? photo}) async {
    var post_body = jsonEncode({
      "order_id": "$order_id",
      "amount": "$amount",
      "name": "$name",
      "trx_id": "$trx_id",
      "photo": "$photo",
    });

    String url = ("${AppConfig.BASE_URL}/offline/payment/submit");

    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
          "Accept": "application/json",
          "System-Key": AppConfig.system_key
        },
        body: post_body,
        middleware: BannedUser());
    return offlinePaymentSubmitResponseFromJson(response.body);
  }
}
