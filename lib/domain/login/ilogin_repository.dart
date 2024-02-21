import 'package:firebase_auth/firebase_auth.dart';

abstract interface class ILoginRepository {
  Future sendOtp({required String phoneNumber});
  Future loginOtp({required String otp});
  Future logout();
  Stream<User?> get userStream;
}
