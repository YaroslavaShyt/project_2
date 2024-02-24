import 'package:flutter/material.dart';
import 'package:project_2/app/services/auth/iauth_service.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final IAuthService _authService;

  HomeViewModel({required IAuthService authService})
      : _authService = authService;

  Stream<AuthState> get authStateStream => _authService.authStateStream;
}
