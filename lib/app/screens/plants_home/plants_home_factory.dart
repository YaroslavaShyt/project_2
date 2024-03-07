import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/screens/plants_home/plants_home_screen.dart';
import 'package:project_2/app/screens/plants_home/plants_home_view_model.dart';
import 'package:project_2/app/services/get_it/get_it.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:project_2/domain/plants/iplants_repository.dart';
import 'package:provider/provider.dart';

class PlantsHomeFactory {
  static Widget build(routeArguments) {
    return ChangeNotifierProvider(
      create: (context) => PlantsHomeViewModel(
          navigationUtil: context.read<INavigationUtil>(),
          plantsRepository: getItInst.get<IPlantsRepository>(),
          loginRepository: getItInst.get<ILoginRepository>()),
      child: Consumer<PlantsHomeViewModel>(builder: (context, model, child) {
        return PlantsHomeScreen(
          plantsHomeViewModel: model,
        );
      }),
    );
  }
}
