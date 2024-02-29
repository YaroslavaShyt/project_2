import 'package:cloud_functions/cloud_functions.dart';

abstract interface class IFunctionsService {
  Future<HttpsCallableResult<T>> call<T>(
      {required String functionName, dynamic arguments});
}
