import 'dart:async';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/utils/deep_linking/deep_link_handler.dart';

class NotificationService {
  DeepLinkHandler? _deepLinkHandler;
  int currentStep = 0;
  Timer? udpateNotificationAfter1Second;

  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService(
      {
      required DeepLinkHandler deepLinkHandler}) {
    _instance._deepLinkHandler = deepLinkHandler;
    return _instance;
  }

  NotificationService._internal();

  ReceivedAction? initialAction;

  static Future<void> initNotifications() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (isAllowed) {
      initializeLocalNotifications(debug: false);
      initializeRemoteNotifications(debug: false);
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
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  static Future<void> initializeRemoteNotifications(
      {required bool debug}) async {
    String token = await requestFirebaseToken();
    debugPrint(token);
    await AwesomeNotificationsFcm().initialize(
        onFcmTokenHandle: NotificationService.myFcmTokenHandle,
        onNativeTokenHandle: NotificationService.myNativeTokenHandle,
        onFcmSilentDataHandle: NotificationService.mySilentDataHandle,
        debug: debug);
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction action) async {
    debugPrint("body: ${action.body}");
    // if (action.body != null) {
    //   try {
    //     if (_instance._navigationUtil != null &&
    //         _instance._navigationUtil != null) {
    //       Map<String, String> data =
    //           _instance._deepLinkHandler!.parseLink(action.body!);
    //       _instance._navigationUtil!
    //           .navigateTo(data["route"]!, data: data["data"]);
    //     }
    //   } catch (err) {
    //     debugPrint(err.toString());
    //   }
    // }
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
      double? progress,
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
          progress: progress,
          locked: true,
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

  // Future<void> showProgressNotification(
  //     {required int id,
  //     required currentStep,
  //     required maxStep,
  //     required fragmentation}) async {
  //   udpateNotificationAfter1Second = Timer(const Duration(seconds: 1), () {
  //     _updateCurrentProgressBar(
  //         id: id,
  //         maxStep: maxStep * fragmentation,
  //         progress: currentStep);
  //   });
  //   //  udpateNotificationAfter1Second?.cancel();
  //   //  udpateNotificationAfter1Second = null;
  // }

  // void _updateCurrentProgressBar(
  //     {required int id,
  //     required int maxStep,
  //     required double progress}) async {
  //   await createNewNotification(
  //       title: "Loading",
  //       body: "body",
  //       progress: progress,
  //       layout: NotificationLayout.ProgressBar);
  // }

  Future<void> showProgressNotification(int id) async {
    int maxStep = 10;
    int fragmentation = 4;
    for (var simulatedStep = 1;
        simulatedStep <= maxStep * fragmentation + 1;
        simulatedStep++) {
      currentStep = simulatedStep;
      await Future.delayed(Duration(milliseconds: 1000 ~/ fragmentation));
      if (udpateNotificationAfter1Second != null) continue;
      udpateNotificationAfter1Second = Timer(const Duration(seconds: 1), () {
        _updateCurrentProgressBar(
            id: id,
            simulatedStep: currentStep,
            maxStep: maxStep * fragmentation);
      });
      udpateNotificationAfter1Second?.cancel();
      udpateNotificationAfter1Second = null;
    }
  }
}

void _updateCurrentProgressBar({
  required int id,
  required int simulatedStep,
  required int maxStep,
}) {
  if (simulatedStep < maxStep) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: 'progress_bar',
            title: 'Download finished',
            body: 'filename.txt',
            category: NotificationCategory.Progress,
            payload: {
              'file': 'filename.txt',
              'path': '-rmdir c://ruwindows/system32/huehuehue'
            },
            locked: false));
  } else {
    double progress = simulatedStep / maxStep * 100;
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: 'progress_bar',
            title: 'Downloading fake file in progress ($progress%)',
            body: 'filename.txt',
            category: NotificationCategory.Progress,
            payload: {
              'file': 'filename.txt',
              'path': '-rmdir c://ruwindows/system32/huehuehue'
            },
            notificationLayout: NotificationLayout.ProgressBar,
            progress: progress,
            locked: true));
  }
}
