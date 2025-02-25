import 'package:zayed3ndk/app_config.dart';
import 'package:zayed3ndk/data_model/business_setting_response.dart';
import 'package:zayed3ndk/repositories/api-request.dart';

class BusinessSettingRepository {
  Future<BusinessSettingListResponse> getBusinessSettingList() async {
    String url = ("${AppConfig.BASE_URL}/business-settings");

    // var businessSettings = [
    //   "facebook_login",
    //   "google_login",
    //   "twitter_login",
    //   "pickup_point",
    //   "wallet_system",
    //   "email_verification",
    //   "conversation_system",
    //   "shipping_type",
    //   "classified_product",
    //   "google_recaptcha",
    //   "vendor_system_activation",
    //   "guest_checkout_activation",
    //   "last_viewed_product_activation",
    //   "notification_show_type"
    // ];
    // String params = businessSettings.join(',');
    // var body = {"keys": params};
    var response = await ApiRequest.get(
      url: url,
    );

    return businessSettingListResponseFromJson(response.body);
  }
}
