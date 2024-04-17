import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_isolate/flutter_isolate.dart';

class IsolateHandler {
  static Function? compute;

  Future<void> computeIsolate(
      {required Map<String, dynamic> payload,
      required Function(SendPort sendPort) performAction}) async {
    final ReceivePort mainIsolatePort = ReceivePort();
    compute = payload["function"];
    Map<String, dynamic> data = {
      "path": payload["path"],
      "filePath": payload["filePath"]
    };
    try {
      final FlutterIsolate uploadIsolate = await FlutterIsolate.spawn(
        performAction,
        mainIsolatePort.sendPort,
      );
      mainIsolatePort.listen((message) {
        if (message is SendPort) {
          debugPrint("COMMUNICATION SETUP SUCCESS");
          message.send(data);
          debugPrint("SENT INPUT PAYLOAD TO UPLOAD ISOLATE");
        }
        if (message is String) {
          debugPrint("GOT THE PAYLOAD FROM UPLOAD ISOLATE: $message");
          uploadIsolate.kill();
          mainIsolatePort.close();
        }
      });
    } catch (err) {
      mainIsolatePort.close();
    } finally {
      debugPrint("ISOLATE FINISHED WORK");
    }
  }
}
