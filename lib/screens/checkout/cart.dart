import 'package:zayed3ndk/custom/btn.dart';
import 'package:zayed3ndk/custom/text_styles.dart';
import 'package:zayed3ndk/custom/useful_elements.dart';
import 'package:zayed3ndk/helpers/shared_value_helper.dart';
import 'package:zayed3ndk/helpers/shimmer_helper.dart';
import 'package:zayed3ndk/helpers/system_config.dart';
import 'package:zayed3ndk/my_theme.dart';
import 'package:zayed3ndk/presenter/cart_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../custom/cart_seller_item_list_widget.dart';
import '../../custom/lang_text.dart';
import '../../presenter/cart_provider.dart';

class Cart extends StatelessWidget {
  const Cart(
      {Key? key,
      this.has_bottomnav,
      this.from_navigation = false,
      this.counter})
      : super(key: key);
  final bool? has_bottomnav;
  final bool from_navigation;
  final CartCounter? counter;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: _Cart(
        counter: counter,
        from_navigation: from_navigation,
        has_bottomnav: has_bottomnav,
      ),
    );
  }
}

class _Cart extends StatefulWidget {
  _Cart(
      {Key? key,
      this.has_bottomnav,
      this.from_navigation = false,
      this.counter})
      : super(key: key);
  final bool? has_bottomnav;
  final bool from_navigation;
  final CartCounter? counter;

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<_Cart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).initState(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, _) {
      return Scaffold(
        key: cartProvider.scaffoldKey,
        backgroundColor: MyTheme.mainColor,
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            RefreshIndicator(
              color: MyTheme.accent_color,
              backgroundColor: Colors.white,
              onRefresh: () => cartProvider.onRefresh(context),
              displacement: 0,
              child: CustomScrollView(
                controller: cartProvider.mainScrollController,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: cartProvider.isMinOrderQuantityNotEnough ? 25:0,
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 3),
                          color: MyTheme.accent_color,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.white),
                                children: [
                                  TextSpan(text: '${LangText(context).local.minimum_order_qty_is} ${minimum_order_quantity.$} , '),
                                  TextSpan(text: LangText(context).local.remaining),
                                  TextSpan(text: ' ${minimum_order_quantity.$ - (cartProvider.shopList.firstOrNull?.cartItems?.length ?? 0)} '),
                                ]
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: cartProvider.isMinOrderAmountNotEnough?25:0,
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 3),
                          color: MyTheme.accent_color,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.white),
                                children: [
                                  TextSpan(text: '${LangText(context).local.minimum_order_amount_is} ${minimum_order_amount.$} , '),
                                  TextSpan(text: LangText(context).local.remaining),
                                  TextSpan(text: ' ${minimum_order_amount.$ - cartProvider.cartTotal} '),
                                ]
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: buildCartSellerList(cartProvider, context),
                        ),
                        SizedBox(height: widget.has_bottomnav! ? 140 : 100),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: buildBottomContainer(cartProvider),
            )
          ],
        ),
      );
    });
  }

  Container buildBottomContainer(cartProvider) {
    return Container(
      decoration: BoxDecoration(
        color: MyTheme.mainColor,
      ),

      height: widget.has_bottomnav! ? 200 : 120,
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
        child: Column(
          children: [
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: MyTheme.soft_accent_color),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      AppLocalizations.of(context)!.total_amount_ucf,
                      style: TextStyle(
                          color: MyTheme.dark_font_grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(cartProvider.cartTotalString,
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: 58,
                    width: (MediaQuery.of(context).size.width - 48),
                    // width: (MediaQuery.of(context).size.width - 48) * (2 / 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: MyTheme.accent_color, width: 1),
                      borderRadius: app_language_rtl.$!
                          ? const BorderRadius.only(
                              topLeft: const Radius.circular(6.0),
                              bottomLeft: const Radius.circular(6.0),
                              topRight: const Radius.circular(6.0),
                              bottomRight: const Radius.circular(6.0),
                            )
                          : const BorderRadius.only(
                              topLeft: const Radius.circular(6.0),
                              bottomLeft: const Radius.circular(6.0),
                              topRight: const Radius.circular(6.0),
                              bottomRight: const Radius.circular(6.0),
                            ),
                    ),
                    child: Btn.basic(
                      minWidth: MediaQuery.of(context).size.width,
                      color: MyTheme.accent_color,
                      shape: app_language_rtl.$!
                          ? RoundedRectangleBorder(
                              borderRadius: const BorderRadius.only(
                                topLeft: const Radius.circular(6.0),
                                bottomLeft: const Radius.circular(6.0),
                                topRight: const Radius.circular(0.0),
                                bottomRight: const Radius.circular(0.0),
                              ),
                            )
                          : RoundedRectangleBorder(
                              borderRadius: const BorderRadius.only(
                                topLeft: const Radius.circular(0.0),
                                bottomLeft: const Radius.circular(0.0),
                                topRight: const Radius.circular(6.0),
                                bottomRight: const Radius.circular(6.0),
                              ),
                            ),
                      child: Text(
                        AppLocalizations.of(context)!.proceed_to_shipping_ucf,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {
                        cartProvider.onPressProceedToShipping(context);
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.mainColor,
      leading: Builder(
        builder: (context) => widget.from_navigation
            ? UsefulElements.backToMain(context, go_back: false)
            : UsefulElements.backButton(context),
      ),
      centerTitle: widget.from_navigation,
      title: Text(
        AppLocalizations.of(context)!.shopping_cart_ucf,
        style: TextStyles.buildAppBarTexStyle(),
      ),
      elevation: 0.0,
      titleSpacing: 0,
      scrolledUnderElevation: 0.0,
    );
  }

  buildCartSellerList(cartProvider, context) {
    if (cartProvider.isInitial && cartProvider.shopList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (cartProvider.shopList.length > 0) {
      return SingleChildScrollView(
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            height: 26,
          ),
          itemCount: cartProvider.shopList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: Row(
                    children: [
                      Text(
                        cartProvider.shopList[index].name,
                        style: TextStyle(
                            color: MyTheme.dark_font_grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                      Spacer(),
                      Text(
                        cartProvider.shopList[index].subTotal.replaceAll(
                                SystemConfig.systemCurrency!.code,
                                SystemConfig.systemCurrency!.symbol) ??
                            '',
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                CartSellerItemListWidget(
                  sellerIndex: index,
                  cartProvider: cartProvider,
                  context: context,
                ),
              ],
            );
          },
        ),
      );
    } else if (!cartProvider.isInitial && cartProvider.shopList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)!.cart_is_empty,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }
}
