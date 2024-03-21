import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/utils/permissions/permission_handler.dart';

class NotificationService {
  final PermissionHandler _permissionHandler;

  NotificationService({required PermissionHandler permissionHandler})
      : _permissionHandler = permissionHandler;

  Future<void> initializeNotifications() async {
    bool isPermissionGranted =
        await _permissionHandler.isNotificationPermissionGranted();

    if (isPermissionGranted) {
      String token = await getFirebaseMessagingToken();

      if (token.isNotEmpty) {
        AwesomeNotifications().initialize(
            null,
            [
              NotificationChannel(
                channelGroupKey: 'basic_channel_group',
                channelKey: 'basic_channel',
                channelName: 'Basic notifications',
                channelDescription: 'Notification channel for basic tests',
              )
            ],
            channelGroups: [
              NotificationChannelGroup(
                  channelGroupKey: 'basic_channel_group',
                  channelGroupName: 'Basic group')
            ],
            debug: true);

        await AwesomeNotifications().setListeners(
          onActionReceivedMethod: onActionReceivedMethod,
        );
      }
    }
  }

  Future<String> getFirebaseMessagingToken() async {
    String firebaseAppToken = '';
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        firebaseAppToken =
            await AwesomeNotificationsFcm().requestFirebaseAppToken();
        debugPrint(firebaseAppToken);
      } catch (exception) {
        debugPrint('$exception');
      }
    } else {
      debugPrint('Firebase is not available on this project');
    }
    return firebaseAppToken;
  }

  Future<void> showLoadingNotification() async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
        title: "Завантаження",
        displayOnForeground: true,
        displayOnBackground: true,
        bigPicture: null,
        notificationLayout: NotificationLayout.ProgressBar,
      ),
    );
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // debugPrint("worked");
    // AwesomeNotifications().createNotification(
    //   content: NotificationContent(
    //     id: 1,
    //     channelKey: 'basic_channel',
    //     title: "Завантаження",
    //     displayOnForeground: true,
    //     displayOnBackground: true,
    //     bigPicture: null,
    //     notificationLayout: NotificationLayout.ProgressBar,
    //   ),
    // );
  }
}
