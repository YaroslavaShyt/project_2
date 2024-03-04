import 'package:cloud_functions/cloud_functions.dart';

class FirebaseFunctionsService {
  Future<HttpsCallableResult<T>> call<T>(
      {required String functionName, dynamic arguments}) async {
    return await FirebaseFunctions.instance
        .httpsCallable(functionName)
        .call<T>(arguments);
  }
}
