import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../helpers/shimmer_helper.dart';
import '../presenter/home_presenter.dart';
import '../services/navigation_service.dart';
import 'aiz_image.dart';
import 'lang_text.dart';

class HomeBannerOne extends StatelessWidget {
  final HomePresenter? homeData;

  const HomeBannerOne({Key? key, this.homeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Null safety check for homeData
    if (homeData == null) {
      return Container(
        height: 100,
        child: Center(child: Text(LangText(context).local.no_data_is_available)),
      );
    }

    // When data is loading and no images are available
    if (homeData!.isBannerOneInitial && homeData!.bannerOneImageList.isEmpty) {
      return Padding(
        padding:
            const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 20),
        child: ShimmerHelper().buildBasicShimmer(height: 120),
      );
    }

    // When banner images are available
    else if (homeData!.bannerOneImageList.isNotEmpty) {
      return SizedBox(
        height: 170,
        child: CarouselSlider(
          options: CarouselOptions(
            height: 166,
            aspectRatio: 1.1,
            viewportFraction: .43,
            initialPage: 0,
            padEnds: false,
            enableInfiniteScroll: true,
            autoPlay: true,
            onPageChanged: (index, reason) {
              // Optionally handle page change
            },
          ),
          items: homeData!.bannerOneImageList.map((i) {
            return Container(
              margin: const EdgeInsetsDirectional.only(start: 12, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white, // background color for container
                borderRadius: BorderRadius.circular(10), // rounded corners
                boxShadow: [
                  BoxShadow(
                    color:
                        Color(0xff000000).withOpacity(0.1), // shadow color
                    spreadRadius: 2, // spread radius
                    blurRadius: 5, // blur radius
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    10), // round corners for the image too
                child: InkWell(
                  onTap: () {
                    // Null safety for URL and handle it properly
                    NavigationService.handleUrls(i.url, context);
                    // var url =
                    //     i.url?.split(AppConfig.DOMAIN_PATH).last ?? null;
                    // if (url != null && url.isNotEmpty) {
                    //   GoRouter.of(context).go(url);
                    // } else {
                    //   // Handle invalid or empty URL case
                    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //     content: Text('Invalid URL'),
                    //   ));
                    // }
                  },
                  child: AIZImage.radiusImage(
                      i.photo, 6), // Display the image with rounded corners
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    // When images are not found and loading is complete
    else if (!homeData!.isBannerOneInitial &&
        homeData!.bannerOneImageList.isEmpty) {
      return SizedBox();
      // return Container(
      //   height: 100,
      //   child: Center(
      //     child: Text(
      //       AppLocalizations.of(context)!.no_carousel_image_found,
      //       style: TextStyle(color: MyTheme.font_grey),
      //     ),
      //   ),
      // );
    }

    // Default container if no condition matches
    else {
      return Container(height: 100);
    }
  }
}
