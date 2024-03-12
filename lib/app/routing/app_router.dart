import 'package:flutter/material.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/app/screens/plants_home/plants_home_factory.dart';
import 'package:project_2/app/screens/home/home_factory.dart';
import 'package:project_2/app/screens/login/login_factory.dart';
import 'package:project_2/app/screens/sms_login/sms_login_factory.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case routeHome:
        return MaterialPageRoute(
            builder: (_) => _buildHomeSettings(routeSettings));
      case routeLogin:
        return MaterialPageRoute(
            builder: (_) => _buildLoginSettings(routeSettings));
      case routeSMSLogin:
        return MaterialPageRoute(
            builder: (_) => _buildSMSLoginSettings(routeSettings));
      case routePlantsHome:
        return MaterialPageRoute(
            builder: (_) => _buildPlantsHomeSettings(routeSettings));

      default:
        return MaterialPageRoute(builder: (_) => const Placeholder());
    }
  }

  Widget _buildHomeSettings(RouteSettings settings) {
    return HomeFactory.build();
  }

  Widget _buildLoginSettings(RouteSettings settings) {
    return LoginFactory.build();
  }

  Widget _buildPlantsHomeSettings(RouteSettings settings) {
    return PlantsHomeFactory.build([]);
  }

  Widget _buildSMSLoginSettings(RouteSettings settings) {
    return SMSLoginFactory.build(settings.arguments);
  }
}
