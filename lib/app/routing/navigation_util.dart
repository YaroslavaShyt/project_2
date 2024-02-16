import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';

class NavigationUtil implements INavigationUtil {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void navigateBack({dynamic data}) {
    navigatorKey.currentState!.pop(data);
  }

  @override
  void navigateBackUntilNamed(String named) {
    navigatorKey.currentState!.popUntil(ModalRoute.withName(named));
  }

  @override
  bool get canPop {
    return navigatorKey.currentState!.canPop();
  }

  @override
  void navigateBackToStart() {
    while (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop();
    }
  }

  @override
  Future<dynamic> navigateTo<T extends Object?>(
    String routeName, {
    bool allowBackNavigation = true,
    dynamic data,
  }) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: data);
  }

  @override
  Future<dynamic> navigateToAndMakeRoot<T extends Object?>(
    String routeName, {
    bool allowBackNavigation = true,
    dynamic data,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => allowBackNavigation ? false : true,
      arguments: data,
    );
  }

  @override
  Future<dynamic> navigateToAndReplace<T extends Object?>(
    String routeName, {
    dynamic data,
  }) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: data);
  }
}
