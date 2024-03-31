import 'package:flutter/material.dart';
import 'package:project_2/app/screens/plants_details/plants_details_view_model.dart';

class PlantsDetailsScreen extends StatelessWidget {
  final PlantsDetailsViewModel viewModel;
  const PlantsDetailsScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(viewModel.plant.name),
      ),
    );
  }
}
