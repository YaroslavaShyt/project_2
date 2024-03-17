import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> onBackgroundMessageArrived(RemoteMessage message) async {
  print("Background message: ${message.notification!.body}");
}
