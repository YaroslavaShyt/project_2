import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/screens/plants_details/plants_details_screen.dart';
import 'package:project_2/app/screens/plants_details/plants_details_view_model.dart';
import 'package:project_2/domain/plants/iplant.dart';
import 'package:provider/provider.dart';


class PlantsDetailsFactory {
  static Widget build(RouteSettings routeSettings) {
    return ChangeNotifierProvider(
      create: (context) => PlantsDetailsViewModel(
        plant: routeSettings.arguments as IPlant,
        navigationUtil: context.read<INavigationUtil>()
      ),
      child: Consumer<PlantsDetailsViewModel>(builder: (context, model, child) {
        return PlantsDetailsScreen(
          viewModel: model,
        );
      }),
    );
  }
}
