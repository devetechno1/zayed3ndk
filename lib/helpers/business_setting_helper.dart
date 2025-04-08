import 'package:zayed3ndk/app_config.dart';
import 'package:zayed3ndk/data_model/business_setting_response.dart';
import 'package:zayed3ndk/helpers/shared_value_helper.dart';
import 'package:zayed3ndk/repositories/business_setting_repository.dart';

import '../data_model/language_list_response.dart';
import '../repositories/language_repository.dart';

class BusinessSettingHelper {
  setBusinessSettingData() async {
    BusinessSettingListResponse businessLists =
        await BusinessSettingRepository().getBusinessSettingList();

    businessLists.data!.forEach((element) {
      switch (element.type) {
        case 'facebook_login':
          {
            if (element.value.toString() == "1") {
              allow_facebook_login.$ = true;
            } else {
              allow_facebook_login.$ = false;
            }
          }
          break;
        case 'google_login':
          {
            if (element.value.toString() == "1") {
              allow_google_login.$ = true;
            } else {
              allow_google_login.$ = false;
            }
          }
          break;
        case 'twitter_login':
          {
            if (element.value.toString() == "1") {
              allow_twitter_login.$ = true;
            } else {
              allow_twitter_login.$ = false;
            }
          }
          break;
        case 'apple_login':
          {
            if (element.value.toString() == "1") {
              allow_apple_login.$ = true;
            } else {
              allow_apple_login.$ = false;
            }
          }
          break;
        case 'pickup_point':
          {
            if (element.value.toString() == "1") {
              pick_up_status.$ = true;
            } else {
              pick_up_status.$ = false;
            }
          }
          break;
        case 'wallet_system':
          {
            if (element.value.toString() == "1") {
              wallet_system_status.$ = true;
            } else {
              wallet_system_status.$ = false;
            }
          }
          break;
        case 'email_verification':
          {
            if (element.value.toString() == "1") {
              mail_verification_status.$ = true;
            } else {
              mail_verification_status.$ = false;
            }
          }
          break;
        case 'must_otp':
          {
            if (element.value.toString() == "1") {
              must_otp.$ = true;
            } else {
              must_otp.$ = false;
            }
          }
          break;
        case 'conversation_system':
          {
            if (element.value.toString() == "1") {
              conversation_system_status.$ = true;
            } else {
              conversation_system_status.$ = false;
            }
          }
          break;
        case 'classified_product':
          {
            if (element.value.toString() == "1") {
              classified_product_status.$ = true;
            } else {
              classified_product_status.$ = false;
            }
          }
          break;

        case 'shipping_type':
          {
            // print(element.value.toString());
            if (element.value.toString() == "carrier_wise_shipping") {
              carrier_base_shipping.$ = true;
            } else {
              carrier_base_shipping.$ = false;
            }
          }
          break;
        case 'google_recaptcha':
          {
            // print(element.type.toString());
            // print(element.value.toString());
            if (element.value.toString() == "1") {
              google_recaptcha.$ = true;
            } else {
              google_recaptcha.$ = false;
            }
          }
          break;
        case 'vendor_system_activation':
          {
            // print(element.type.toString());
            // print(element.value.toString());
            if (element.value.toString() == "1") {
              vendor_system.$ = true;
            } else {
              vendor_system.$ = false;
            }
          }
          break;
        case 'guest_checkout_activation':
          {
            // print(element.type.toString());
            // print(element.value.toString());
            if (element.value.toString() == "1") {
              guest_checkout_status.$ = true;
            } else {
              guest_checkout_status.$ = false;
            }
          }
          break;
        case 'notification_show_type':
          {
            notificationShowType.$ = element.value.toString();
            // print(element.type.toString());
            // print(element.value.toString());
            // if (element.value.toString() == "1") {
            //   notificationShowType.$ = true;
            // } else {
            //   notificationShowType.$ = false;
            // }
          }
          break;
        case 'last_viewed_product_activation':
          {
            if (element.value.toString() == "1") {
              last_viewed_product_status.$ = true;
            } else {
              last_viewed_product_status.$ = false;
            }
          }
          break;
        case 'minimum_order_quantity_check':
          {
            if (element.value.toString() == "1") {
              minimum_order_quantity_check.$ = true;
            } else {
              minimum_order_quantity_check.$ = false;
            }
          }
          break;
        case 'minimum_order_amount_check':
          {
            if (element.value.toString() == "1") {
              minimum_order_amount_check.$ = true;
            } else {
              minimum_order_amount_check.$ = false;
            }
          }
          break;
        case 'minimum_order_amount':
          {
            minimum_order_amount.$ = double.parse(element.value?.toString() ?? '0.0');
          }
          break;
        case 'minimum_order_quantity':
          {
            minimum_order_quantity.$ = int.parse(element.value?.toString() ?? '0');
          }
          break;


        default:
          {}
          break;
      }
    });
  }

  static Future<void> setInitLang()async {
    final LanguageListResponse langs = await LanguageRepository().getLanguageList();

    if (langs.success != true) return;

    if(langs.languages?.length == 1){
      await _setLangConfig(langs.languages!.first);
      return;
    }
    await app_language.load();
    if(app_language.$ == null){
      for (Language lang in langs.languages ?? []) {
        if (lang.is_default ?? false) {
          await _setLangConfig(lang);
          return;
        }
      }
    }
  }

  static Future<void> _setLangConfig (Language lang) async{
    AppConfig.default_language = lang.code ?? AppConfig.default_language;
    AppConfig.mobile_app_code = lang.mobile_app_code ?? AppConfig.mobile_app_code;
    AppConfig.app_language_rtl = lang.rtl ?? AppConfig.app_language_rtl;
    app_language.$ = lang.code;
    app_mobile_language.$ = lang.mobile_app_code;
    app_language_rtl.$ = lang.rtl;
    await Future.wait([
      app_language.save(),
      app_mobile_language.save(),
      app_language_rtl.save(),
    ]);
  }
}
