import 'package:zayed3ndk/custom/lang_text.dart';
import 'package:zayed3ndk/custom/toast_component.dart';
import 'package:zayed3ndk/repositories/address_repository.dart';
import 'package:flutter/material.dart';

import '../helpers/shared_value_helper.dart';
import '../screens/checkout/shipping_info.dart';

class SelectAddressProvider with ChangeNotifier {
  ScrollController mainScrollController = ScrollController();

  int? selectedShippingAddress = -1;
  List<dynamic> shippingAddressList = [];
  bool isVisible = true;
  bool faceData = false;
  double mWidth = 0;
  double mHeight = 0;

  void init(BuildContext context) {
    if (is_logged_in.$ == true) {
      fetchAll(context);
    }
  }

  void dispose() {
    mainScrollController.dispose();
    super.dispose();
  }

  Future<void> fetchAll(BuildContext context) async{
    if (is_logged_in.$ == true) {
      await fetchShippingAddressList(context);
    }
  }

  Future<void> fetchShippingAddressList(BuildContext context) async {
    reset();
    var addressResponse = await AddressRepository().getAddressList();
    shippingAddressList.addAll(addressResponse.addresses);
    if (shippingAddressList.isNotEmpty) {
      for (int i = 0; i < shippingAddressList.length; i++) {
        if (shippingAddressList[i].location_available == true) {
          selectedShippingAddress = shippingAddressList[i].id;
          break;
        }
      }
      for (var address in shippingAddressList) {
        if (address.set_default == 1) {
          selectedShippingAddress = address.id;
        }
      }
    }
    faceData = true;
    notifyListeners();
  }

  void reset() {
    shippingAddressList.clear();
    faceData = false;
    selectedShippingAddress = -1;
    notifyListeners();
  }

  Future<void> onRefresh(BuildContext context) async {
    reset();
    if (is_logged_in.$ == true) {
      await fetchAll(context);
    }
  }

  void onPopped(value, BuildContext context) {
    reset();
    fetchAll(context);
  }

  void afterAddingAnAddress(BuildContext context) {
    reset();
    fetchAll(context);
  }

  void shippingInfoCardFnc(index, BuildContext context) {
    if (selectedShippingAddress != shippingAddressList[index].id) {
      selectedShippingAddress = shippingAddressList[index].id;
    }
    notifyListeners();
  }

  Future<void> onPressProceed(BuildContext context) async {
    if (selectedShippingAddress == -1) {
      ToastComponent.showDialog(
        LangText(context).local.choose_an_address_or_pickup_point,
      );
      return;
    }

    late var addressUpdateInCartResponse;

    if (selectedShippingAddress != -1) {
      addressUpdateInCartResponse = await AddressRepository()
          .getAddressUpdateInCartResponse(address_id: selectedShippingAddress);
    }
    if (addressUpdateInCartResponse.result == false) {
      ToastComponent.showDialog(
        addressUpdateInCartResponse.message,
      );
      return;
    }

    ToastComponent.showDialog(
      addressUpdateInCartResponse.message,
    );

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ShippingInfo();
    })).then((value) {
      onPopped(value, context);
    });
  }
}
