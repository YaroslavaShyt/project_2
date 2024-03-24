import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:flutter/material.dart';

class NotificationService{
  static final NotificationService _instance =
      NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  ReceivedAction? initialAction;

  static Future<void> initNotifications() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (isAllowed) {
      initializeLocalNotifications(debug: true);
      initializeRemoteNotifications(debug: true);
    }
  }

  static Future<void> initializeLocalNotifications(
      {required bool debug}) async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'alerts',
            channelName: 'Alerts',
            channelDescription: 'Notification tests as alerts',
            playSound: true,
            importance: NotificationImportance.High,
            defaultPrivacy: NotificationPrivacy.Private,
            defaultColor: Colors.deepPurple,
            ledColor: Colors.deepPurple)
      ],
      debug: debug,
    );
  }

  static Future<void> initializeRemoteNotifications(
      {required bool debug}) async {
    String token = await requestFirebaseToken();
    debugPrint(token);
    await AwesomeNotificationsFcm().initialize(
        onFcmTokenHandle: NotificationService.myFcmTokenHandle,
        onNativeTokenHandle: NotificationService.myNativeTokenHandle,
        onFcmSilentDataHandle: NotificationService.mySilentDataHandle,
        // licenseKeys:
        //     [
        //   // me.carda.awesomeNotificationsFcmExample
        //   '2024-01-02==kZDwJQkSR7mrjEgDk7afWDSrqYCiqW6Ao/7wn/w6v5OKOgAnoEWt'
        //       'gqO0ELI1BxWNzSde2gbaW+9Ki6Tx94pU2gQRJuJxXGsvcmCRla1mB/0U/rPh'
        //       'f77bxgPRG+PHn9+p9sQ5nfvY6Ytw9IvDn4NjH3ccbjoXFRrs7R/ou9aapq2a'
        //       'jRHqXlIzDR1ihyQHC91Wvkviw2qTOEYDhR5hE4T2l1iHsTTpeXOqWk0XmgnC'
        //       'gO18e4Hv0P5WKICCull+PCh+OXQYTK5x0UwQPNOGN20rQu5zR9C0ph0hFQxk'
        //       'WLa/ft206pBZmWDf4HiyAawXPoR1AMWAh/t0cjh8gRTTNfHeog==',

        //   // me.carda.awesome_notifications_fcm_example
        //   '2024-01-02==lYUBqt9kKmObnP7UzWd2KK9FOTOySkVATX/j/CGEzSlSKsQx5y5S9'
        //       'RKHG1lP1TZ5KHO6+wwkNbzxmni4uJ418WM3ywTY199bHAp5MHWxZEEgvMMG4/'
        //       '/V2W0acFhSgxH6GL/6XNYvhS2RwaX7X/z4NX7Z4dgZVOn0VW3GRyg7I/zLcgl'
        //       'Dhh+n9obRuGnZI+Xakw2id97PSG4QZOCw15A0LzE1lip/Fzj0cMRsqpvcAW2K'
        //       'VWYZm5ZmK2yKVcop1kxiq1faZGL1fBteJCQ8YeQKpqS+aaVmexdJXmB7sJVl0'
        //       '5o87ORRfijpO+Q6gmTYfjYxoiQMismHUx6NAnoB/txaLw=='
        // ],
        debug: debug);
  }

  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    debugPrint('"SilentData": ${silentData.toString()}');
    if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {
      debugPrint("bg");
    } else {
      debugPrint("FOREGROUND");
    }
  }

  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String token) async {
    if (token.isNotEmpty) {
      debugPrint('Firebase Token:"$token"');
    } else {
      debugPrint('Firebase Token deleted');
    }
  }

  @pragma("vm:entry-point")
  static Future<void> myNativeTokenHandle(String token) async {
    debugPrint('Native Token:"$token"');
  }

  Future<void> createNewNotification(
      {required String title,
      required String body,
      NotificationLayout layout = NotificationLayout.Default,
      Map<String, String>? payload}) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

    if (!isAllowed) {
      isAllowed =
          await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: -1,
          channelKey: 'alerts',
          title: title,
          body: body,
          notificationLayout: layout,
          payload: payload),
    );
  }

  static Future<void> deleteToken() async {
    await AwesomeNotificationsFcm().deleteToken();
    await Future.delayed(const Duration(seconds: 5));
    await requestFirebaseToken();
  }

  static Future<String> requestFirebaseToken() async {
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        return await AwesomeNotificationsFcm().requestFirebaseAppToken();
      } catch (exception) {
        debugPrint('$exception');
      }
    } else {
      debugPrint('Firebase is not available on this project');
    }
    return '';
  }
}
