import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/screens/login/login_screen.dart';
import 'package:project_2/app/screens/login/login_view_model.dart';
import 'package:project_2/data/login/login_repository.dart';
import 'package:provider/provider.dart';

class LoginFactory {
  static Widget build() {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(
          navigationUtil: context.read<INavigationUtil>(),
          loginRepository: LoginRepository(firebaseAuth: FirebaseAuth.instance)),
      child: LoginScreen(),
    );
  }
}
