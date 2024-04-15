import 'package:flutter/material.dart';
import 'package:project_2/app/common/error_handling/error_handling_mixin.dart';
import 'package:project_2/app/common/widgets/modals/modals_service.dart';
import 'package:project_2/app/common/widgets/modals/pop_up_dialog/pop_up_dialog_data.dart';
import 'package:project_2/app/screens/plants_details/plants_details_view_model.dart';
import 'package:project_2/app/screens/plants_details/widgets/files_list.dart';
import 'package:project_2/app/screens/plants_home/widgets/picker_content.dart';
import 'package:project_2/app/theming/app_colors.dart';

class PlantsDetailsScreen extends StatefulWidget with ErrorHandlingMixin {
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
  void dispose() {
    widget.viewModel.disposeControllers();
    super.dispose();
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
                      )),
                ],
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    "Усі фото",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor),
                  ),
                ],
              ),
              FilesList(
                  onTap: () => _showPicker(context, isVideo: false, isGalleryOptionProvided: true),
                  files: widget.viewModel.plant!.photos,
                  isVideo: false),
              const Row(
                children: [
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    "Усі відео",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor),
                  ),
                ],
              ),
              FilesList(
                  onTap: () => _showPicker(context, isVideo: true, isGalleryOptionProvided: false),
                  files: widget.viewModel.plant!.videos,
                  controllers: widget.viewModel.controllers,
                  isVideo: true),
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

  void _showPicker(context,
      {required bool isGalleryOptionProvided, required bool isVideo}) {
    Modals.showPopUpModal(
        context: context,
        data: PopUpDialogData(
            title: 'Завантажити файл',
            content: PickerContent(
                onCameraTap: () => widget.viewModel.addPlantFileFromCamera(
                    onError: (err) => widget.showErrorDialog(context, err),
                    isVideo: isVideo),
                onGalleryTap: isGalleryOptionProvided
                    ? () => widget.viewModel.addPlantFileFromGallery(
                        isVideo: isVideo,
                        onError: (err) => widget.showErrorDialog(context, err))
                    : null),
            actions: []));
  }
}
