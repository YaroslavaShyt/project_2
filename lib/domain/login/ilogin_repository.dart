enum AuthState { authenticated, notAuthenticated }

abstract interface class ILoginRepository {
  Future sendOtp({required String phoneNumber});
  Future<void> loginOtp({required String otp});
  Future<void> logout();
  Stream<AuthState> authState();
}
