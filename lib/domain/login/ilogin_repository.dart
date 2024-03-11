import 'package:firebase_auth/firebase_auth.dart';

enum AuthState { authenticated, notAuthenticated }

abstract interface class ILoginRepository {
  Future<void> sendOtp({required String phoneNumber});
  Future<void> loginOtp({required String otp});
  Future<void> logout();
  Stream<AuthState> authState();
  Future<User?> loginGoogle();
  User? get googleUser;
}
