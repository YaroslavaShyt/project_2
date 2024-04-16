import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:project_2/app/utils/isolate/isolate_data.dart';

class IsolateHandler {
  Future<dynamic> computeIsolate(Future<void> Function() function) async {
    final ReceivePort receivePort = ReceivePort();
    RootIsolateToken rootToken = RootIsolateToken.instance!;
    final isolate = await Isolate.spawn<IsolateData>(
        _isolateEntry,
        IsolateData(
            answerPort: receivePort.sendPort,
            function: function,
            token: rootToken));
    receivePort.listen((message) {
      print("received message: $message");
    }, onDone: () {
      isolate.kill();
      receivePort.close();
    });
  }

  void _isolateEntry(IsolateData isolateData) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(isolateData.token);
    final answer = await isolateData.function();
    isolateData.answerPort.send(answer);
  }
}
