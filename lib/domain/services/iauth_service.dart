import 'package:flutter/material.dart';

enum UserState {ready, notReady} 

abstract interface class IAuthService implements ChangeNotifier{
  Stream<UserState> userStateStream();

  void closeStream();

  Future sendOtp({required String phoneNumber});

  Future<void> loginOtp({required String otp});

  Future<void> loginGoogle();

  Future<void> logout();
}
