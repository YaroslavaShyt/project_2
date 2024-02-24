import 'package:flutter/material.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:project_2/app/services/auth/iauth_service.dart';

class AuthService extends ChangeNotifier implements IAuthService {
  final ILoginRepository _loginRepository;

  AuthService({required ILoginRepository loginRepository})
      : _loginRepository = loginRepository;

  @override
  Stream<AuthState> get authStateStream => _loginRepository.authState();

  @override
  Future sendOtp({required String phoneNumber}) async {
    _loginRepository.sendOtp(phoneNumber: phoneNumber);
  }

  @override
  Future<void> loginOtp({required String otp}) async {
    _loginRepository.loginOtp(otp: otp);
  }

  @override
  Future<void> logout() async {
    _loginRepository.logout();
  }
}
