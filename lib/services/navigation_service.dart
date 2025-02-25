import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:one_context/one_context.dart';

import '../app_config.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void handleUrls(String? url, [BuildContext? context]) {
    if(url?.isNotEmpty != true) return;
    context ??= OneContext().context!;
    final Uri? uri = Uri.tryParse(url ?? '');
    if(uri?.hasAbsolutePath ?? false){
      if(uri?.host ==  AppConfig.DOMAIN_PATH){
        context.push(uri!.path);
      }else{
        launchUrl(uri!);
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar( content: Text('Invalid URL')));
    }
  }

/*

    Not using this as One context is used

    https://stackoverflow.com/questions/66139776/get-the-global-context-in-flutter/66140195

    Create the class. Here it named as NavigationService

    class NavigationService {
    static GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

    }

    Set the navigatorKey property of MaterialApp in the main.dart

    Widget build(BuildContext context) {
      return MaterialApp(
        navigatorKey: NavigationService.navigatorKey, // set property
      )
    }

    Great! Now you can use anywhere you want e.g.

    print("---print context:
      ${NavigationService.navigatorKey.currentContext}");


  */
}
