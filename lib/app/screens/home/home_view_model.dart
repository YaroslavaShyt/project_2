import 'package:flutter/material.dart';
import 'package:project_2/domain/services/iauth_service.dart';

class HomeViewModel extends ChangeNotifier {
  final IAuthService _authService;

  HomeViewModel({required IAuthService authService})
      : _authService = authService;

  Stream<UserState> get userStateStream => _authService.userStateStream();

  void closeStream() => _authService.closeStream();
}
