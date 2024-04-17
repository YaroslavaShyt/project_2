import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter_isolate/flutter_isolate.dart';

enum IsolateComponent { sendPort, performedAction }

class IsolateHandler {}
  Future<void> computeIsolate({required Function performedAction}) async {
    final mainIsolatePort = ReceivePort();
    Map payload = {};
    try {
      final isolate = await FlutterIsolate.spawn(
          _isolateEntry, mainIsolatePort.sendPort);
      mainIsolatePort.listen((messageFromMain) {
        if (messageFromMain is SendPort) {
          debugPrint("COMMUNICATION SETUP SUCCESS");
          messageFromMain.send(payload);
          debugPrint("SENT INPUT PAYLOAD TO UPLOAD ISOLATE");
        }
        if (messageFromMain is String) {
          debugPrint(
              "GOT THE UPLOAD RESULT FROM UPLOAD ISOLATE:$messageFromMain");
          isolate.kill();
          mainIsolatePort.close();
        }
      }, onDone: () {
        isolate.kill();
        mainIsolatePort.close();
      }, onError: (e) {
        debugPrint("Error in main Isolate : $e");
        isolate.kill();
        mainIsolatePort.close();
      });
    } catch (err) {
      debugPrint("Error in the main Isolate:$err");
      mainIsolatePort.close();
    }
  }

  void _isolateEntry(SendPort sendPort) async {
    // final mainIsolatePort = data[0];
    // final performedAction = data[1];
    // final uploadIsolatePort = ReceivePort();
    // try {
    //   mainIsolatePort.send(uploadIsolatePort.sendPort);
    //   uploadIsolatePort.listen((messageFromMain) async {
    //     if (messageFromMain is Map) {
    //       final result = await performedAction();
    //       debugPrint("isolate result: $result");
    //       mainIsolatePort.send(result);
    //     }
    //   });
    // } catch (err) {
    //   debugPrint("ERROR IN UPLOAD ISOLATE:$err");
    //   mainIsolatePort.send('');
    // }
  }

