import 'dart:convert';

import 'package:zayed3ndk/app_config.dart';
import 'package:zayed3ndk/data_model/cart_add_response.dart';
import 'package:zayed3ndk/data_model/cart_count_response.dart';
import 'package:zayed3ndk/data_model/cart_delete_response.dart';
import 'package:zayed3ndk/data_model/cart_process_response.dart';
import 'package:zayed3ndk/data_model/cart_response.dart';
import 'package:zayed3ndk/data_model/cart_summary_response.dart';
import 'package:zayed3ndk/helpers/shared_value_helper.dart';
import 'package:zayed3ndk/middlewares/banned_user.dart';
import 'package:zayed3ndk/repositories/api-request.dart';

class CartRepository {
  // get cart list
  Future<dynamic> getCartResponseList(
    int? uid,
  ) async {
    String url = ("${AppConfig.BASE_URL}/carts");
    var postBody;

    if (guest_checkout_status.$ && !is_logged_in.$) {
      postBody = jsonEncode({"temp_user_id": temp_user_id.$});
    } else {
      postBody = jsonEncode({"user_id": user_id.$});
    }

    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: postBody,
        middleware: BannedUser());

    return cartResponseFromJson(response.body);
  }

  // cart count
  Future<dynamic> getCartCount() async {
    var postBody;
    if (guest_checkout_status.$ && !is_logged_in.$) {
      postBody = jsonEncode({"temp_user_id": temp_user_id.$});
    } else {
      postBody = jsonEncode({"user_id": user_id.$});
    }

    // if (guest_checkout_status.$ && !is_logged_in.$) {
    // var postBody = jsonEncode({"temp_user_id": temp_user_id.$});
    String url = ("${AppConfig.BASE_URL}/cart-count");
    final response = await ApiRequest.post(
      url: url,
      headers: {
        "Content-Type": "application/json",
        "App-Language": app_language.$ ?? AppConfig.default_language,
      },
      body: postBody,
    );

    return cartCountResponseFromJson(response.body);
  }

  // cart item delete
  Future<dynamic> getCartDeleteResponse(int cartId) async {
    String url = "${AppConfig.BASE_URL}/carts/$cartId";

    final response = await ApiRequest.delete(
      url: url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },
      middleware: BannedUser(),
    );

    if (response.statusCode == 200) {
      return cartDeleteResponseFromJson(response.body);
    } else {
      throw Exception("Failed to delete item: ${response.body}");
    }
  }

  // cart process
  Future<dynamic> getCartProcessResponse(
      String cart_ids, String cart_quantities) async {
    var post_body = jsonEncode(
        {"cart_ids": "${cart_ids}", "cart_quantities": "$cart_quantities"});

    String url = ("${AppConfig.BASE_URL}/carts/process");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body,
        middleware: BannedUser());
    return cartProcessResponseFromJson(response.body);
  }

  // cart add
  Future<dynamic> getCartAddResponse(
      int? id, String? variant, int? user_id, int? quantity) async {
    var post_body;

    if (guest_checkout_status.$ && !is_logged_in.$) {
      post_body = jsonEncode({
        "id": "${id}",
        "variant": variant,
        "quantity": "$quantity",
        "cost_matrix": AppConfig.purchase_code,
        "temp_user_id": temp_user_id.$
      });
    } else {
      post_body = jsonEncode({
        "id": "${id}",
        "variant": variant,
        "user_id": "$user_id",
        "quantity": "$quantity",
        "cost_matrix": AppConfig.purchase_code,
      });
    }

    String url = ("${AppConfig.BASE_URL}/carts/add");
    final response = await ApiRequest.post(
      url: url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!
      },
      body: post_body,
      middleware: BannedUser(),
    );
    print("digital cart add response: ${response.body}");
    return cartAddResponseFromJson(response.body);
  }

  Future<dynamic> getCartSummaryResponse() async {
    var postBody;

    if (guest_checkout_status.$ && !is_logged_in.$) {
      postBody = jsonEncode({"temp_user_id": temp_user_id.$});
    } else {
      postBody = jsonEncode({"user_id": user_id.$});
    }

    String url = ("${AppConfig.BASE_URL}/cart-summary");
    final response = await ApiRequest.post(
        url: url,
        body: postBody,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser());

    return cartSummaryResponseFromJson(response.body);
  }
}
