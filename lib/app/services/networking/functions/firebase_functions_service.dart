import 'package:cloud_functions/cloud_functions.dart';
import 'package:project_2/domain/services/ifunctions_service.dart';

class FirebaseFunctionsService implements IFunctionsService {
  @override
  Future<HttpsCallableResult<T>> call<T>(
      {required String functionName, dynamic arguments}) async {
    return await FirebaseFunctions.instance
        .httpsCallable(functionName)
        .call<T>(arguments);
  }
}
