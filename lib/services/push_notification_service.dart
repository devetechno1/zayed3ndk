import 'dart:io';

import 'package:zayed3ndk/custom/btn.dart';
import 'package:zayed3ndk/helpers/shared_value_helper.dart';
import 'package:zayed3ndk/repositories/profile_repository.dart';
import 'package:zayed3ndk/screens/auth/login.dart';
import 'package:zayed3ndk/screens/orders/order_details.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:one_context/one_context.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../custom/toast_component.dart';
import '../helpers/shimmer_helper.dart';

final FirebaseMessaging _fcm = FirebaseMessaging.instance;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  '0', // id
  'High Importance Notifications', // title
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class PushNotificationService {
  static Future initialize() async {
    await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    updateDeviceToken();


    FirebaseMessaging.onMessage.listen((event) async{
      print("onLaunch: ${event.toMap()}");
      if(Platform.isIOS) {
        _showIosMessage(event);
        return;
      }
      //(Map<String, dynamic> message) async => _showMessage(message);
      RemoteNotification? notification = event.notification;

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );


      final AndroidNotification? android = notification?.android;
      final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/notification_icon'); 

      final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

      BigPictureStyleInformation? bigPictureStyle;
      FilePathAndroidBitmap? image;
      if(android?.imageUrl != null){
        final String largeIconPath = await _downloadAndSaveFile(android!.imageUrl!, 'largeIcon');
        image = FilePathAndroidBitmap(largeIconPath);
        bigPictureStyle = BigPictureStyleInformation(
            image, 
            contentTitle: notification?.title,
            summaryText: notification?.body,
            hideExpandedLargeIcon: true,
          );

      }
      
      final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
          channel.id,
          channel.name,
          importance: Importance.max,
          priority: Priority.max,
          icon: android?.smallIcon,
          styleInformation: bigPictureStyle,
          largeIcon: image,
        );
      
      final DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails();

      

      flutterLocalNotificationsPlugin.initialize(initializationSettings);


      if (notification != null) {
        return flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(android: androidNotificationDetails, iOS: darwinNotificationDetails),
          payload: notification.toMap().toString(),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onResume: ${message.toMap()}");
      _serialiseAndNavigate(message.toMap());
    });
  }
  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static Future<void> updateDeviceToken() async {
    if (is_logged_in.$) {
      String fcmToken = await _fcm.getToken() ?? '';
      print("fcmToken $fcmToken");
    
      await ProfileRepository().getDeviceTokenUpdateResponse(fcmToken);
    }
  }

  static void _showIosMessage(RemoteMessage message) {
    //print("onMessage: $message");

    OneContext().showDialog(
      // barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(message.notification!.title!),
          subtitle:message.notification?.apple?.imageUrl == null ? Text(message.notification!.body!) : _dialogImageBody(message),
        ),
        actions: <Widget>[
          Btn.basic(
            child: Text('close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Btn.basic(
            child: Text('GO'),
            onPressed: () {
              if (is_logged_in.$ == false) {
                ToastComponent.showDialog(
                  "You are not logged in",
                );
                return;
              }
              //print(message);
              Navigator.of(context).pop();
              if (message.data['item_type'] == 'order') {
                OneContext().push(MaterialPageRoute(builder: (_) {
                  return OrderDetails(
                      id: int.parse(message.data['item_type_id']),
                      from_notification: true);
                }));
              }
            },
          ),
        ],
      ),
    );
  }

  static void _serialiseAndNavigate(Map<String, dynamic> message) {
    if (is_logged_in.$ == false) {
      OneContext().showDialog(
          // barrierDismissible: false,
          builder: (context) => AlertDialog(
                title: new Text("You are not logged in"),
                content: new Text("Please log in"),
                actions: <Widget>[
                  Btn.basic(
                    child: Text('close'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Btn.basic(
                      child: Text('Login'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        OneContext().push(MaterialPageRoute(builder: (_) {
                          return Login();
                        }));
                      }),
                ],
              ));
      return;
    }
    if (message['data']['item_type'] == 'order') {
      OneContext().push(MaterialPageRoute(builder: (_) {
        return OrderDetails(
            id: int.parse(message['data']['item_type_id']),
            from_notification: true);
      }));
    } // If there's no view it'll just open the app on the first view    }
  }
}

class _dialogImageBody extends StatelessWidget {
  const _dialogImageBody(this.message);
  final RemoteMessage message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 16),
        Text(message.notification!.body!),
        SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            message.notification!.apple!.imageUrl!,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return ShimmerHelper().buildBasicShimmer(height: 120.0);
            },
          )
        ),
      ],
    );
  }
}
