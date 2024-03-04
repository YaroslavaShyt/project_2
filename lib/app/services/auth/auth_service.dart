import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:project_2/domain/services/iauth_service.dart';

class AuthService extends ChangeNotifier implements IAuthService {
  final ILoginRepository _loginRepository;
  final StreamController<UserState> _userStateStreamController =
      StreamController.broadcast();

  AuthService({required ILoginRepository loginRepository})
      : _loginRepository = loginRepository;

  @override
  void closeStream(){
    _userStateStreamController.close();
    _loginRepository.closeAuthStream();
  }

  @override
  Stream<UserState> userStateStream() {
    Stream<UserState> stream = _loginRepository.authState().map((event) {
      switch (event) {
        case AuthState.authenticated:
          return UserState.ready;
        case AuthState.notAuthenticated:
          return UserState.notReady;
      }
    });
    stream.listen((event) {
      _userStateStreamController.add(event);
    });
    
    
    return _userStateStreamController.stream;
  }


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

  @override
  Future<void> loginGoogle() async {
    _loginRepository.loginGoogle();
  }
}
