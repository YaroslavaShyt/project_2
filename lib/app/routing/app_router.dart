import 'package:flutter/material.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/app/screens/camera/camera_factory.dart';
import 'package:project_2/app/screens/plants_details/plants_details_factory.dart';
import 'package:project_2/app/screens/plants_home/plants_home_factory.dart';
import 'package:project_2/app/screens/home/home_factory.dart';
import 'package:project_2/app/screens/login/login_factory.dart';
import 'package:project_2/app/screens/video/video_factory.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case routeHome:
        return MaterialPageRoute(
            builder: (_) => _buildHomeSettings(routeSettings));
      case routeLogin:
        return MaterialPageRoute(
            builder: (_) => _buildLoginSettings(routeSettings));
      case routePlantsHome:
        return MaterialPageRoute(
            builder: (_) => _buildPlantsHomeSettings(routeSettings));
      case routePlantsDetails:
        return MaterialPageRoute(
            builder: (_) => _buildPlantsDetailsSettings(routeSettings));
      case routeCamera:
        return MaterialPageRoute(
            builder: (_) => _buildCameraSettings(routeSettings));
      case routeVideo:
        return MaterialPageRoute(
            builder: (_) => _buildVideoSettings(routeSettings));

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

  Widget _buildPlantsDetailsSettings(RouteSettings settings) {
    return PlantsDetailsFactory.build(settings);
  }

  Widget _buildCameraSettings(RouteSettings settings) {
    return CameraFactory.build(settings);
  }

  Widget _buildVideoSettings(RouteSettings settings) {
    return VideoFactory.build(settings);
  }
}
