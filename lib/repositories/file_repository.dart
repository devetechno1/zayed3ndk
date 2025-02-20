import 'package:zayed3ndk/app_config.dart';
import 'package:zayed3ndk/middlewares/banned_user.dart';
import 'package:zayed3ndk/repositories/api-request.dart';
import 'dart:convert';
import 'package:zayed3ndk/data_model/simple_image_upload_response.dart';
import 'package:zayed3ndk/helpers/shared_value_helper.dart';

class FileRepository {
  Future<dynamic> getSimpleImageUploadResponse(
      String image, String filename) async {
    var post_body = jsonEncode({"image": "${image}", "filename": "$filename"});

    String url = ("${AppConfig.BASE_URL}/file/image-upload");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body,
        middleware: BannedUser());

    return simpleImageUploadResponseFromJson(response.body);
  }
}
