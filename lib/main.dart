import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/app.dart';
import 'package:project_2/app/routing/app_router.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/navigation_util.dart';
import 'package:project_2/app/services/auth/auth_service.dart';
import 'package:project_2/app/services/get_it/get_it.dart';
import 'package:project_2/domain/services/iauth_service.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:project_2/app/services/user/user_service.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:project_2/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initCloudFunctions();
  initNetworkService();
  initRepos();

  final INavigationUtil navigationUtil = NavigationUtil();
  final AppRouter appRouter = AppRouter();

  final IAuthService authService =
      AuthService(loginRepository: getItInst.get<ILoginRepository>());
  final IUserService userService =
      UserService(firebaseAuth: FirebaseAuth.instance);

  runApp(MultiProvider(
      providers: [
        Provider.value(value: navigationUtil),
        ChangeNotifierProvider.value(value: userService),
        ChangeNotifierProvider.value(value: authService)
      ],
      child: App(
        router: appRouter,
      )));
}
