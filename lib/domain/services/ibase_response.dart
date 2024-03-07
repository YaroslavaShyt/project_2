abstract interface class IBaseResponse {
  final int? code;
  final bool? success;
  final String? error;
  final Map<String, dynamic>? data;

  IBaseResponse(
      {this.code,
      this.success,
      this.data,
      this.error});
}
