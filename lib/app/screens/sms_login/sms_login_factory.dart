import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/screens/sms_login/sms_login_screen.dart';
import 'package:project_2/app/screens/sms_login/sms_login_view_model.dart';
import 'package:project_2/app/services/encryption/encryption_service.dart';
import 'package:project_2/app/services/get_it/get_it.dart';
import 'package:project_2/app/services/networking/firebase_storage/firebase_storage_service.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:project_2/domain/user/iuser_repository.dart';
import 'package:provider/provider.dart';

class SMSLoginFactory {
  static Widget build(routeArguments) {
    return ChangeNotifierProvider(
      create: (context) => SMSLoginViewModel(
          encryptionService: getItInst.get<EncryptionService>(),
          otp: routeArguments["otp"],
          firebaseStorageService: getItInst.get<FirebaseStorageService>(),
          userRepository: getItInst.get<IUserRepository>(),
          navigationUtil: context.read<INavigationUtil>(),
          userService: context.read<IUserService>(),
          loginRepository: getItInst.get<ILoginRepository>()),
      child: Consumer<SMSLoginViewModel>(builder: (context, model, child) {
        return SMSLoginScreen(
          smsLoginViewModel: model,
        );
      }),
    );
  }
}
