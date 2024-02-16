abstract interface class ILoginRepository{
  Future sendOtp({required String phoneNumber});
  Future loginOtp({required String otp});
}