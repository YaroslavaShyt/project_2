import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:project_2/app/services/notifications/notifications_service.dart';

Future<void> onBackgroundMessageArrived(RemoteMessage message) async {
  print("Background message: ${message.notification?.body}");
  NotificationService().showNotifications(
      title: message.notification?.title ?? "no title",
      body: message.notification?.body ?? "no body");
}

