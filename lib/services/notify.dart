// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initNotification() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//             requestAlertPermission: true,
//             requestBadgePermission: true,
//             requestSoundPermission: true,
//             onDidReceiveLocalNotification:
//                 (int id, String? title, String? body, String? payload) async {
//               // Handle iOS local notification tapped logic here if needed
//             });

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

//     await notificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse:
//             (NotificationResponse notificationResponse) async {
//           // Handle notification tapped logic here
//         });
//   }

//   NotificationDetails notificationDetails() {
//     return const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'channelId', // Unique channel ID
//           'channelName', // Channel name for the user
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//         iOS: DarwinNotificationDetails());
//   }

//   Future<void> showNotification(
//       {int id = 0, String? title, String? body, String? payload}) async {
//     return notificationsPlugin.show(
//         id, title, body, notificationDetails(), payload: payload);
//   }
// }

import 'package:coffee_order_application/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

import '../screens/user/StartPage.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.notification?.title);
  print(message.notification?.body);
  print(message.data);
}

class NotificationService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void handle(RemoteMessage? message) {
    if (message == null) {
      return;
    }

    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (context) => StartPage(),
    ));
  }

  Future<void> initPushNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification:
                (int id, String? title, String? body, String? payload) async {
              // Handle iOS local notification tapped logic here if needed
            });

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      // Handle notification tapped logic here
    });

    NotificationDetails notificationDetails() {
      return const NotificationDetails(
          android: AndroidNotificationDetails(
            'channelId', // Unique channel ID
            'channelName', // Channel name for the user
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails());
    }

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handle);
    FirebaseMessaging.onMessageOpenedApp.listen(handle);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((massage) {
      final notification = massage.notification;
      if (notification == null) {
        return;
      }
      notificationsPlugin.show(0, massage.notification?.title,
          massage.notification?.body, notificationDetails());
    });
  }

  Future<void> initNotification() async {
    FirebaseMessaging.instance.requestPermission();

    var Token = await FirebaseMessaging.instance.getToken();

    print(Token);
    initPushNotification();
  }

  // NotificationDetails notificationDetails() {
  //   return const NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'channelId', // Unique channel ID
  //         'channelName', // Channel name for the user
  //         importance: Importance.max,
  //         priority: Priority.high,
  //       ),
  //       iOS: DarwinNotificationDetails());
  // }

  // void shownote(id, title, massage) {
  //   notificationsPlugin.show(id, title, massage, notificationDetails());
  // }
}
