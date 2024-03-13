import 'package:project_2/data/user/user.dart';

enum AuthState { authenticated, notAuthenticated }

abstract interface class ILoginRepository {
  Future<void> sendOtp({required String phoneNumber});
  Future<String?> loginOtp({required String otp});
  Future<void> logout();
  Stream<AuthState> authState();
  Future<MyUser> loginGoogle();
}
