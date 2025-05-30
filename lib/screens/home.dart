import 'package:zayed3ndk/app_config.dart';
import 'package:zayed3ndk/custom/flash%20deals%20banner/flash_deal_banner.dart';
import 'package:zayed3ndk/helpers/shared_value_helper.dart';
import 'package:zayed3ndk/my_theme.dart';
import 'package:zayed3ndk/presenter/home_presenter.dart';
import 'package:zayed3ndk/screens/filter.dart';
import 'package:zayed3ndk/screens/flash_deal/flash_deal_list.dart';
import 'package:zayed3ndk/screens/product/todays_deal_products.dart';
import 'package:zayed3ndk/screens/top_sellers.dart';

import 'package:zayed3ndk/single_banner/sincle_banner_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../custom/feature_categories_widget.dart';
import '../custom/featured_product_horizontal_list_widget.dart';
import '../custom/home_all_products_2.dart';
import '../custom/home_banner_one.dart';
import '../custom/home_carousel_slider.dart';
import '../custom/home_search_box.dart';
import '../custom/pirated_widget.dart';
import '../other_config.dart';
import '../services/push_notification_service.dart';
HomePresenter homeData = HomePresenter();

class Home extends StatefulWidget {
  const Home({
    Key? key,
    this.title,
    this.show_back_button = false,
    this.go_back = true,
  }) : super(key: key);

  final String? title;
  final bool show_back_button;
  final bool go_back;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      if (OtherConfig.USE_PUSH_NOTIFICATION) PushNotificationService.updateDeviceToken();
      change();
    });

    super.initState();
  }

  void change() {
    homeData.onRefresh();
    homeData.mainScrollListener();
    homeData.initPiratedAnimation(this);
  }

  @override
  void dispose() {
    homeData.pirated_logo_controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return widget.go_back;
      },
      child: Directionality(
        textDirection:
            app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
        child: SafeArea(
          child: Scaffold(
            appBar: buildAppBar(34, context),
            backgroundColor: Colors.white,
            body: ListenableBuilder(
              listenable: homeData,
              builder: (context, child) {
                return Stack(
                  children: [
                    RefreshIndicator(
                      color: MyTheme.accent_color,
                      backgroundColor: Colors.white,
                      onRefresh: homeData.onRefresh,
                      displacement: 0,
                      child:
                          //CustomScroll
                          CustomScrollView(
                        controller: homeData.mainScrollController,
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildListDelegate([
                              AppConfig.purchase_code == ""
                                  ? PiratedWidget(homeData: homeData)
                                  : SizedBox(),
                              SizedBox(height: 10),

                              //Header Search
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.symmetric(horizontal: 20),
                              //   child: HomeSearchBox(),
                              // ),
                              // SizedBox(height: 8),
                              //Header Banner
                              HomeCarouselSlider(
                                homeData: homeData,
                                context: context,
                              ),
                              SizedBox(height: 16),

                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: buildHomeMenu(context, homeData),
                              ),
                              // SizedBox(height: 16),

                              //Home slider one
                              HomeBannerOne(homeData: homeData),
                            ]),
                          ),

                          //Featured Categories
                          if(homeData.isCategoryInitial ||  homeData.featuredCategoryList.isNotEmpty)...[
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 10.0, 18.0, 0.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .featured_categories_ucf,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),

                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: 175,
                                child: FeaturedCategoriesWidget(
                                  homeData: homeData,
                                ),
                              ),
                            ),
                          ],

                          if (homeData.isFlashDeal)
                            SliverList(
                                delegate: SliverChildListDelegate([
                              InkWell(
                                onTap: () => GoRouter.of(context).go('/flash-deals'),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: Text(
                                    AppLocalizations.of(context)!.flash_deals_ucf,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              FlashDealBanner(
                                context: context,
                                homeData: homeData,
                              ),
                            ])),

                          // SliverList(
                          //     delegate: SliverChildListDelegate([
                          //   FlashDealBanner(
                          //     context: context,
                          //     homeData: homeData,
                          //   ),
                          // ])),

                          SliverList(delegate: SliverChildListDelegate(const [PhotoWidget()])),
                          //Featured Products
                          if(homeData.isFeaturedProductInitial || homeData.featuredProductList.length != 0)
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Container(
                                  height: 305,
                                  margin: EdgeInsets.only(top: 12),
                                  color: MyTheme.accent_color.withOpacity(0.1),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.only(top: 20, start: 20),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .featured_products_ucf,
                                          style: TextStyle(
                                            color: Color(0xff000000),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Flexible(child: FeaturedProductHorizontalListWidget(homeData: homeData)),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          //Home Banner Slider Two
                          // SliverList(
                          //   delegate: SliverChildListDelegate([
                          //     HomeBannerTwo(
                          //       context: context,
                          //       homeData: homeData,
                          //     ),
                          //   ]),
                          // ),
                          SliverList(
                            delegate: SliverChildListDelegate([
                              SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          18.0, 20, 20.0, 0.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .all_products_ucf,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //Home All Product
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          HomeAllProducts2(
                                              context: context,
                                              homeData: homeData),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Container(
                              //   height: 80,
                              // ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: buildProductLoadingContainer(homeData),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHomeMenu(BuildContext context, HomePresenter homeData) {
    // Check if the menu is loading (assuming both deals are false when data is not available)
    // if (!homeData.isFlashDeal && !homeData.isTodayDeal) {
    //   return Container(
    //     height: 40,
    //     child: ShimmerHelper().buildHorizontalGridShimmerWithAxisCount(
    //       crossAxisSpacing: 12.0,
    //       mainAxisSpacing: 12.0,
    //       item_count: 4, // Adjust as needed
    //       mainAxisExtent: 40.0, // Height of each item
    //     ),
    //   );
    // }

    final List<Map<String, dynamic>> menuItems = [
      if (homeData.isTodayDeal)
        {
          "title": AppLocalizations.of(context)!.todays_deal_ucf,
          "image": "assets/todays_deal.png",
          "onTap": () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TodaysDealProducts();
            }));
          },
          "textColor": Colors.white,
          "backgroundColor": const Color(0xffE62D05),
        },
      if (homeData.isFlashDeal)
        {
          "title": AppLocalizations.of(context)!.flash_deal_ucf,
          "image": "assets/flash_deal.png",
          "onTap": () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FlashDealList();
            }));
          },
          "textColor": Colors.white,
          "backgroundColor": const Color(0xffF6941C),
        },
      if(homeData.isBrands)
        {
          "title": AppLocalizations.of(context)!.brands_ucf,
          "image": "assets/brands.png",
          "onTap": () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Filter(selected_filter: "brands");
            }));
          },
          "textColor": Color(0xff263140),
          "backgroundColor": const Color(0xffE9EAEB),
        },
      // Ensure `vendor_system.$` is valid or properly defined
      if (vendor_system.$)
        {
          "title": AppLocalizations.of(context)!.top_sellers_ucf,
          "image": "assets/top_sellers.png",
          "onTap": () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TopSellers();
            }));
          },
          "textColor": Color(0xff263140),
          "backgroundColor": const Color(0xffE9EAEB),
        },
    ];
    

    if(menuItems.isEmpty) return const SizedBox();

    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];

          return GestureDetector(
            onTap: item['onTap'],
            child: Container(
              margin: EdgeInsetsDirectional.only(start: 8),
              height: 40,
              width: 106,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: item['backgroundColor'],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: 16,
                        width: 16,
                        alignment: Alignment.center,
                        child: Image.asset(
                          item['image'],
                          color: item['textColor'],
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        item['title'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: item['textColor'],
                          fontWeight: FontWeight.w300,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar buildAppBar(double statusBarHeight, BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0.0,
      centerTitle: false,
      elevation: 0,
      flexibleSpace: Padding(
        padding:
            const EdgeInsets.only(top: 10.0, bottom: 10, left: 18, right: 18),
        child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Filter()));
            },
            child: HomeSearchBox(context: context)),
      ),
    );
  }
  // AppBar buildAppBar(double statusBarHeight, BuildContext context) {
  //   return AppBar(
  //     automaticallyImplyLeading: false,
  //     // Don't show the leading button
  //     backgroundColor: Colors.white,
  //     centerTitle: false,
  //     elevation: 0,
  //     flexibleSpace: Padding(
  //       // padding:
  //       //     const EdgeInsets.only(top: 40.0, bottom: 22, left: 18, right: 18),
  //       padding:
  //           const EdgeInsets.only(top: 10.0, bottom: 10, left: 18, right: 18),
  //       child: GestureDetector(
  //         onTap: () {
  //           Navigator.push(context, MaterialPageRoute(builder: (context) {
  //             return Filter();
  //           }));
  //         },
  //         child: HomeSearchBox(context: context),
  //       ),
  //     ),
  //   );
  // }

  Container buildProductLoadingContainer(HomePresenter homeData) {
    return Container(
      height: homeData.showAllLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(
          homeData.totalAllProductData == homeData.allProductList.length
              ? AppLocalizations.of(context)!.no_more_products_ucf
              : AppLocalizations.of(context)!.loading_more_products_ucf,
        ),
      ),
    );
  }
}
