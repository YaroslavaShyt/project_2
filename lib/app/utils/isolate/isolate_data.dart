import 'dart:isolate';
import 'dart:ui';

class IsolateData {
  final RootIsolateToken token;
  final Function function;
  final SendPort answerPort;

  IsolateData(
      {required this.answerPort, required this.function, required this.token});
}
