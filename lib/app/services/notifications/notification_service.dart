import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project_2/app/services/app_state/app_state_service.dart';
import 'package:project_2/app/services/get_it/get_it.dart';
import 'package:project_2/firebase_options.dart';
import 'package:provider/provider.dart';

@pragma('vm:entry-point')
Future<void> _onBackgroundMessageArrived(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  if (message.notification != null) {
    debugPrint("Background message: ${message.notification?.body}");

  
         NotificationService().showNotification(
             title: message.notification?.title ?? "no title",
             body: message.notification?.body ?? "no body");


  }
}

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'channel ID',
    'channel name',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );
  static const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: _androidNotificationDetails);

  Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<String?> getFirebaseMessagingToken() async {
    await _firebaseMessaging.setAutoInitEnabled(true);
    String? token = await _firebaseMessaging.getToken();
    debugPrint("FCMToken $token");
    return token;
  }

  Future<void> initFirebaseNotifications() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        debugPrint(message.notification!.body);
        showNotification(
            title: message.notification!.title!,
            body: message.notification!.body!);
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        debugPrint("Background message: ${value.notification?.body}");

        NotificationService().showNotification(
            title: value.notification?.title ?? "no title",
            body: value.notification?.body ?? "no body");
      }
    });
    //FirebaseMessaging.onBackgroundMessage(_onBackgroundMessageArrived);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        debugPrint(message.notification!.body);
      }
    });
  }

  Future<void> showNotification(
      {required String title, required String body, payload}) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
