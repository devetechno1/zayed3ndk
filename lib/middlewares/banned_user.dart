import 'dart:convert';

import 'package:zayed3ndk/helpers/auth_helper.dart';
import 'package:zayed3ndk/helpers/system_config.dart';
import 'package:zayed3ndk/middlewares/middleware.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class BannedUser extends Middleware {
  @override
  bool next(http.Response response) {
    var jsonData = jsonDecode(response.body);
    if (jsonData.runtimeType != List &&
        jsonData.containsKey("result") &&
        !jsonData['result']) {
      if (jsonData.containsKey("status") && jsonData['status'] == "banned") {
        AuthHelper().clearUserData();
        if (SystemConfig.context != null) {
          SystemConfig.context!.go('/');
        }

        return false;
      }
    }
    return true;
  }
}
