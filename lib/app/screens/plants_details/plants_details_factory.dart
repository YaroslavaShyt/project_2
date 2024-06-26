import 'package:flutter/material.dart';
import 'package:project_2/app/screens/plants_details/plants_details_screen.dart';
import 'package:project_2/app/screens/plants_details/plants_details_view_model.dart';
import 'package:project_2/app/services/get_it/get_it.dart';
import 'package:project_2/domain/plants/iplants_repository.dart';
import 'package:provider/provider.dart';

class PlantsDetailsFactory {
  static Widget build(RouteSettings routeSettings) {
    return ChangeNotifierProvider(
      create: (context) => PlantsDetailsViewModel(
          plantId: routeSettings.arguments as String,
          plantsRepository: getItInst.get<IPlantsRepository>()),
      child: Consumer<PlantsDetailsViewModel>(builder: (context, model, child) {
        return PlantsDetailsScreen(
          viewModel: model,
        );
      }),
    );
  }
}
