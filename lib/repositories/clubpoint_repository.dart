import 'dart:convert';

import 'package:zayed3ndk/app_config.dart';
import 'package:zayed3ndk/data_model/clubpoint_response.dart';
import 'package:zayed3ndk/data_model/clubpoint_to_wallet_response.dart';
import 'package:zayed3ndk/helpers/shared_value_helper.dart';
import 'package:zayed3ndk/middlewares/banned_user.dart';
import 'package:zayed3ndk/repositories/api-request.dart';

class ClubpointRepository {
  Future<dynamic> getClubPointListResponse({page = 1}) async {
    String url = ("${AppConfig.BASE_URL}/clubpoint/get-list?page=$page");

    final response = await ApiRequest.get(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        middleware: BannedUser());
    return clubpointResponseFromJson(response.body);
  }

  Future<dynamic> getClubpointToWalletResponse(int? id) async {
    var post_body = jsonEncode({
      "id": "${id}",
    });
    String url = ("${AppConfig.BASE_URL}/clubpoint/convert-into-wallet");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body,
        middleware: BannedUser());
    return clubpointToWalletResponseFromJson(response.body);
  }
}
