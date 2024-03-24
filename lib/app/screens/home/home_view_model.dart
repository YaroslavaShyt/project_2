import 'package:flutter/material.dart';
import 'package:project_2/domain/services/iauth_service.dart';
import 'package:project_2/app/services/notifications/notification_service.dart';
import 'package:project_2/app/utils/permissions/permission_handler.dart';

class HomeViewModel extends ChangeNotifier {
  final IAuthService _authService;
  final PermissionHandler _permissionHandler;
  final NotificationService _notificationService;

  HomeViewModel({
    required IAuthService authService,
    required PermissionHandler permissionHandler,
    required NotificationService notificationService,
  })  : _authService = authService,
        _permissionHandler = permissionHandler,
        _notificationService = notificationService;

  Stream<UserState> get userStateStream => _authService.userStateStream();

  void initNotifications({required Function(String) errorHandler}) {
    _permissionHandler
        .isNotificationPermissionGranted();
  }
}
