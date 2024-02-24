import 'package:flutter/material.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';

abstract interface class IAuthService implements ChangeNotifier{
  Stream<AuthState> get authStateStream;

  Future sendOtp({required String phoneNumber});

  Future<void> loginOtp({required String otp});

  Future<void> logout();
}
