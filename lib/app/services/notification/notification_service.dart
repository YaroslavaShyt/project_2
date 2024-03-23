import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_2/app/app.dart';
import 'package:project_2/app/utils/permissions/permission_handler.dart';


class NotificationController extends ChangeNotifier {
  /// *********************************************
  ///   SINGLETON PATTERN
  /// *********************************************

  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() {
    return _instance;
  }

  NotificationController._internal();

  /// *********************************************
  ///  OBSERVER PATTERN
  /// *********************************************

  String _firebaseToken = '';
  String get firebaseToken => _firebaseToken;

  String _nativeToken = '';
  String get nativeToken => _nativeToken;

  ReceivedAction? initialAction;

  /// *********************************************
  ///   INITIALIZATION METHODS
  /// *********************************************

  static Future<void> initializeLocalNotifications(
      {required bool debug}) async {
    await AwesomeNotifications().initialize(
      null, //'resource://drawable/res_app_icon',//
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
      languageCode: 'ko',
    );
   
    // Get initial notification action is optional
    _instance.initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static Future<void> initializeRemoteNotifications(
      {required bool debug}) async {
    
    await AwesomeNotificationsFcm().initialize(
        onFcmTokenHandle: NotificationController.myFcmTokenHandle,
        onNativeTokenHandle: NotificationController.myNativeTokenHandle,
        onFcmSilentDataHandle: NotificationController.mySilentDataHandle,
        licenseKeys:
            // On this example app, the app ID / Bundle Id are different
            // for each platform, so i used the main Bundle ID + 1 variation
            [
          // me.carda.awesomeNotificationsFcmExample
          '2024-01-02==kZDwJQkSR7mrjEgDk7afWDSrqYCiqW6Ao/7wn/w6v5OKOgAnoEWt'
              'gqO0ELI1BxWNzSde2gbaW+9Ki6Tx94pU2gQRJuJxXGsvcmCRla1mB/0U/rPh'
              'f77bxgPRG+PHn9+p9sQ5nfvY6Ytw9IvDn4NjH3ccbjoXFRrs7R/ou9aapq2a'
              'jRHqXlIzDR1ihyQHC91Wvkviw2qTOEYDhR5hE4T2l1iHsTTpeXOqWk0XmgnC'
              'gO18e4Hv0P5WKICCull+PCh+OXQYTK5x0UwQPNOGN20rQu5zR9C0ph0hFQxk'
              'WLa/ft206pBZmWDf4HiyAawXPoR1AMWAh/t0cjh8gRTTNfHeog==',

          // me.carda.awesome_notifications_fcm_example
          '2024-01-02==lYUBqt9kKmObnP7UzWd2KK9FOTOySkVATX/j/CGEzSlSKsQx5y5S9'
              'RKHG1lP1TZ5KHO6+wwkNbzxmni4uJ418WM3ywTY199bHAp5MHWxZEEgvMMG4/'
              '/V2W0acFhSgxH6GL/6XNYvhS2RwaX7X/z4NX7Z4dgZVOn0VW3GRyg7I/zLcgl'
              'Dhh+n9obRuGnZI+Xakw2id97PSG4QZOCw15A0LzE1lip/Fzj0cMRsqpvcAW2K'
              'VWYZm5ZmK2yKVcop1kxiq1faZGL1fBteJCQ8YeQKpqS+aaVmexdJXmB7sJVl0'
              '5o87ORRfijpO+Q6gmTYfjYxoiQMismHUx6NAnoB/txaLw=='
        ],
        debug: debug);
         bool data = await AwesomeNotifications().isNotificationAllowed();
  }

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  static ReceivePort? receivePort;
  static Future<void> initializeIsolateReceivePort() async {
    receivePort = ReceivePort('Notification action port in main isolate')
      ..listen(
          (silentData) => onActionReceivedImplementationMethod(silentData));

    IsolateNameServer.registerPortWithName(
        receivePort!.sendPort, 'notification_action_port');
  }

  ///  *********************************************
  ///     LOCAL NOTIFICATION EVENTS
  ///  *********************************************

  static Future<void> getInitialNotificationAction() async {
    ReceivedAction? receivedAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: true);
    if (receivedAction == null) return;

    // Fluttertoast.showToast(
    //     msg: 'Notification action launched app: $receivedAction',
    //   backgroundColor: Colors.deepPurple
    // );
    print('App launched by a notification action: $receivedAction');
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      // For background actions, you must hold the execution until the end
      print(
          'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
      await executeLongTaskInBackground();
      return;
    } else {
      if (receivePort == null) {
        // onActionReceivedMethod was called inside a parallel dart isolate.
        SendPort? sendPort =
            IsolateNameServer.lookupPortByName('notification_action_port');

        if (sendPort != null) {
          // Redirecting the execution to main isolate process (this process is
          // only necessary when you need to redirect the user to a new page or
          // use a valid context)
          sendPort.send(receivedAction);
          return;
        }
      }
    }

    return onActionReceivedImplementationMethod(receivedAction);
  }

  static Future<void> onActionReceivedImplementationMethod(
      ReceivedAction receivedAction) async {
    
  }

  ///  *********************************************
  ///     REMOTE NOTIFICATION EVENTS
  ///  *********************************************

  /// Use this method to execute on background when a silent data arrives
  /// (even while terminated)
  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    

    print('"SilentData": ${silentData.toString()}');

    if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {
      print("bg");
    } else {
      print("FOREGROUND");
    }

    print('mySilentDataHandle received a FcmSilentData execution');
    await executeLongTaskInBackground();
  }

  /// Use this method to detect when a new fcm token is received
  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String token) async {
    if (token.isNotEmpty) {
     

      debugPrint('Firebase Token:"$token"');
    } else {
     

      debugPrint('Firebase Token deleted');
    }

    _instance._firebaseToken = token;
    _instance.notifyListeners();
  }

  /// Use this method to detect when a new native token is received
  @pragma("vm:entry-point")
  static Future<void> myNativeTokenHandle(String token) async {
    
    debugPrint('Native Token:"$token"');

    _instance._nativeToken = token;
    _instance.notifyListeners();
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************

  static Future<void> executeLongTaskInBackground() async {
    print("starting long task");
    await Future.delayed(const Duration(seconds: 4));
    final url = Uri.parse("http://google.com");
   // final re = await http.get(url);
   // print(re.body);
    print("long task done");
  }

  ///  *********************************************
  ///     REQUEST NOTIFICATION PERMISSIONS
  ///  *********************************************

  static Future<bool> displayNotificationRationale() async {
    bool userAuthorized = false;
    // BuildContext context = MyApp.navigatorKey.currentContext!;
    // await showDialog(
    //     context: context,
    //     builder: (BuildContext ctx) {
    //       return AlertDialog(
    //         title: Text('Get Notified!',
    //             style: Theme.of(context).textTheme.titleLarge),
    //         content: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Row(
    //               children: [
    //                 Expanded(
    //                   child: Image.asset(
    //                     'assets/animated-bell.gif',
    //                     height: MediaQuery.of(context).size.height * 0.3,
    //                     fit: BoxFit.fitWidth,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             const SizedBox(height: 20),
    //             const Text(
    //                 'Allow Awesome Notifications to send you beautiful notifications!'),
    //           ],
    //         ),
    //         actions: [
    //           TextButton(
    //               onPressed: () {
    //                 Navigator.of(ctx).pop();
    //               },
    //               child: Text(
    //                 'Deny',
    //                 style: Theme.of(context)
    //                     .textTheme
    //                     .titleLarge
    //                     ?.copyWith(color: Colors.red),
    //               )),
    //           TextButton(
    //               onPressed: () async {
    //                 userAuthorized = true;
    //                 Navigator.of(ctx).pop();
    //               },
    //               child: Text(
    //                 'Allow',
    //                 style: Theme.of(context)
    //                     .textTheme
    //                     .titleLarge
    //                     ?.copyWith(color: Colors.deepPurple),
    //               )),
    //         ],
    //       );
     //   });
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  ///  *********************************************
  ///     LOCAL NOTIFICATION CREATION METHODS
  ///  *********************************************

  static Future<void> createNewNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

    if (!isAllowed) {
      isAllowed = await displayNotificationRationale();
    }

    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1, // -1 is replaced by a random number
            channelKey: 'alerts',
            title: 'Huston! The eagle has landed!',
            body:
                "A small step for a man, but a giant leap to Flutter's community!",
            bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
            largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'notificationId': '1234567890'}),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
          NotificationActionButton(
              key: 'REPLY',
              label: 'Reply Message',
              requireInputText: true,
              actionType: ActionType.SilentAction),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true)
        ]);
  }

  static Future<void> resetBadge() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> deleteToken() async {
    await AwesomeNotificationsFcm().deleteToken();
    await Future.delayed(Duration(seconds: 5));
    await requestFirebaseToken();
  }

  ///  *********************************************
  ///     REMOTE TOKEN REQUESTS
  ///  *********************************************

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

// class NotificationService {
//   final PermissionHandler permissionHandler;
//   NotificationService({required this.permissionHandler});

//   static Future<void> initializeNotifications() async {
//     await AwesomeNotifications().initialize(
//       null,
//       [
//         NotificationChannel(
//           channelGroupKey: 'high_importance_channel',
//           channelKey: 'high_importance_channel',
//           channelName: 'Basic notifications',
//           channelDescription: 'Notification channel for basic tests',
//           defaultColor: const Color(0xFF9D50DD),
//           ledColor: Colors.white,
//           importance: NotificationImportance.Max,
//           channelShowBadge: true,
//           onlyAlertOnce: true,
//           playSound: true,
//           criticalAlerts: true,
//         )
//       ],
//       channelGroups: [
//         NotificationChannelGroup(
//           channelGroupKey: 'high_importance_channel_group',
//           channelGroupName: 'Group 1',
//         )
//       ],
//       debug: true,
//     );

//     await AwesomeNotifications().isNotificationAllowed().then(
//       (isAllowed) async {
//         if (!isAllowed) {
//           await AwesomeNotifications().requestPermissionToSendNotifications();
//         }
//       },
//     );

//     await AwesomeNotifications().setListeners(
//       onActionReceivedMethod: onActionReceivedMethod,
//       onNotificationCreatedMethod: onNotificationCreatedMethod,
//       onNotificationDisplayedMethod: onNotificationDisplayedMethod,
//       onDismissActionReceivedMethod: onDismissActionReceivedMethod,
//     );
//   }

//   static Future<void> onNotificationCreatedMethod(
//       ReceivedNotification receivedNotification) async {
//     debugPrint('onNotificationCreatedMethod');
//   }

//   static Future<void> onNotificationDisplayedMethod(
//       ReceivedNotification receivedNotification) async {
//     debugPrint('onNotificationDisplayedMethod');
//     // await showNotification(
//     //     title: receivedNotification.title!, body: receivedNotification.body!);  // looped
//   }

//   static Future<void> onDismissActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     debugPrint('onDismissActionReceivedMethod');
//   }

//   /// Use this method to detect when the user taps on a notification or action button
//   static Future<void> onActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     debugPrint('onActionReceivedMethod');
//     final payload = receivedAction.payload ?? {};
//     await showNotification(
//         title: receivedAction.title ?? "no title",
//         body: receivedAction.body ?? "no body"); // looped
//     if (payload["navigate"] == "true") {
//       // MainApp.navigatorKey.currentState?.push(
//       //   MaterialPageRoute(
//       //     builder: (_) => const SecondScreen(),
//       //   ),
//       // );
//     }
//   }

//   static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
//     await showNotification(title: "no title", body: "no body");
//   }

//   static Future<void> showNotification({
//     required final String title,
//     required final String body,
//     final String? summary,
//     final Map<String, String>? payload,
//     final ActionType actionType = ActionType.Default,
//     final NotificationLayout notificationLayout = NotificationLayout.Default,
//     final NotificationCategory? category,
//     final String? bigPicture,
//     final List<NotificationActionButton>? actionButtons,
//     final bool scheduled = false,
//     final int? interval,
//   }) async {
//     assert(!scheduled || (scheduled && interval != null));

//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: -1,
//         channelKey: 'high_importance_channel',
//         title: title,
//         body: body,
//         actionType: actionType,
//         notificationLayout: notificationLayout,
//         summary: summary,
//         category: category,
//         payload: payload,
//         bigPicture: bigPicture,
//         f
//       ),
//       actionButtons: actionButtons,
//       schedule: scheduled
//           ? NotificationInterval(
//               interval: interval,
//               timeZone:
//                   await AwesomeNotifications().getLocalTimeZoneIdentifier(),
//               preciseAlarm: true,
//             )
//           : null,
//     );
//   }
// }
