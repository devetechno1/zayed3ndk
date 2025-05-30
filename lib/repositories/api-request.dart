import 'dart:developer';

import 'package:zayed3ndk/helpers/main_helpers.dart';
import 'package:zayed3ndk/middlewares/group_middleware.dart';
import 'package:zayed3ndk/middlewares/middleware.dart';
import 'package:zayed3ndk/repositories/aiz_api_response.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiRequest {
  static Future<http.Response> get(
      {required String url,
      Map<String, String>? headers,
      Middleware? middleware,
      GroupMiddleware? groupMiddleWare}) async {
    Uri uri = Uri.parse(url);
    Map<String, String>? headerMap = commonHeader;
    headerMap.addAll(currencyHeader);
    if (headers != null) {
      headerMap.addAll(headers);
    }
    if(kDebugMode) print("api request url: $url headers: $headerMap");
    var response = await http.get(uri, headers: headerMap);
    if(kDebugMode) log("api response url: $url response: ${response.body}");
    return AIZApiResponse.check(response,
        middleware: middleware, groupMiddleWare: groupMiddleWare);
  }

  static Future<http.Response> post(
      {required String url,
      Map<String, String>? headers,
      required String body,
      Middleware? middleware,
      GroupMiddleware? groupMiddleWare}) async {
    Uri uri = Uri.parse(url);
    Map<String, String>? headerMap = commonHeader;
    headerMap.addAll(currencyHeader);
    if (headers != null) {
      headerMap.addAll(headers);
    }
    if(kDebugMode) print("post api request url: $url headers: $headerMap body: $body");
    var response = await http.post(uri, headers: headerMap, body: body);
    if(kDebugMode) log("post api response url: $url response: ${response.body}");
    return AIZApiResponse.check(response,
        middleware: middleware, groupMiddleWare: groupMiddleWare);
  }

  static Future<http.Response> delete(
      {required String url,
      Map<String, String>? headers,
      Middleware? middleware,
      GroupMiddleware? groupMiddleWare}) async {
    Uri uri = Uri.parse(url);
    Map<String, String>? headerMap = commonHeader;
    headerMap.addAll(currencyHeader);
    if (headers != null) {
      headerMap.addAll(headers);
    }
    var response = await http.delete(uri, headers: headerMap);
    return AIZApiResponse.check(response,
        middleware: middleware, groupMiddleWare: groupMiddleWare);
  }
}
