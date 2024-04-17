import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/utils/deep_linking/deep_link_handler.dart';

class NotificationService {
  DeepLinkHandler? _deepLinkHandler;
  INavigationUtil? _navigationUtil;
  int currentStep = 0;
  Timer? udpateNotificationAfter1Second;

  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService({required DeepLinkHandler deepLinkHandler}) {
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
    if (action.body != null) {
      try {
        if (_instance._navigationUtil != null &&
            _instance._navigationUtil != null) {
          Map<String, String> data =
              _instance._deepLinkHandler!.parseLink(action.body!);
          _instance._navigationUtil!
              .navigateTo(data["route"]!, data: data["data"]);
        }
      } catch (err) {
        debugPrint(err.toString());
      }
    }
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
      required int id,
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
    debugPrint("\n\nPROGRESS IN NOTIFICATION: $progress\n\n");
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: id,
          channelKey: 'alerts',
          title: title,
          body: body,
          notificationLayout: layout,
          progress: progress,
          locked: false,
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

  Future<void> deleteNotification({required int id}) async {
    await AwesomeNotifications().cancel(id);
  }

  Future<void> showProgressNotification({
    required int id,
    required currentStep,
    required maxStep,
  }) async {
    udpateNotificationAfter1Second = Timer(const Duration(milliseconds: 5), () {
      _updateCurrentProgressBar(
          id: id, maxStep: maxStep, progress: currentStep / maxStep);
    });
  }

  void _updateCurrentProgressBar(
      {required int id, required int maxStep, required double progress}) async {
    await createNewNotification(
        id: id,
        title: "Loading",
        body: "body",
        progress: progress,
        layout: NotificationLayout.ProgressBar);
  }
}
