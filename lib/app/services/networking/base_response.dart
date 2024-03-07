import 'package:project_2/domain/services/ibase_response.dart';

class BaseResponse implements IBaseResponse {
  @override
  final int? code;

  @override
  bool? success;

  @override
  final String? error;

  @override
  final Map<String, dynamic>? data;

  BaseResponse(
      {this.code,
      this.error,
      this.data,
      this.success});
}
