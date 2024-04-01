import 'package:flutter/material.dart';
import 'package:project_2/app/screens/plants_details/plants_details_view_model.dart';
import 'package:project_2/app/theming/app_colors.dart';

class PlantsDetailsScreen extends StatefulWidget {
  final PlantsDetailsViewModel viewModel;
  const PlantsDetailsScreen({super.key, required this.viewModel});

  @override
  State<PlantsDetailsScreen> createState() => _PlantsDetailsScreenState();
}

class _PlantsDetailsScreenState extends State<PlantsDetailsScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadPlantData();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.viewModel.plant != null) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(widget.viewModel.plant!.image)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.viewModel.plant!.name,
                    style: const TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  IconButton(
                      onPressed: widget.viewModel.sharePlant,
                      icon: const Icon(
                        Icons.share,
                        color: AppColors.whiteColor,
                      ))
                ],
              ),
            ],
          ),
        ),
        backgroundColor: AppColors.darkWoodGeenColor,
      );
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.oliveGreenColor,
          ),
        ),
      );
    }
  }
}
