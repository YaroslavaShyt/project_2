import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/common/error_handling/error_handling_mixin.dart';
import 'package:project_2/app/common/widgets/chached_image.dart';
import 'package:project_2/app/common/widgets/modals/modals_service.dart';
import 'package:project_2/app/common/widgets/modals/pop_up_dialog/pop_up_dialog_data.dart';
import 'package:project_2/app/screens/plants_details/plants_details_view_model.dart';
import 'package:project_2/app/screens/plants_details/widgets/category_row.dart';
import 'package:project_2/app/screens/plants_details/widgets/files_list.dart';
import 'package:project_2/app/screens/plants_details/widgets/video_grid.dart';
import 'package:project_2/app/screens/plants_home/widgets/picker_content.dart';
import 'package:project_2/app/theming/app_colors.dart';
import 'package:project_2/domain/plants/iplant.dart';

class PlantsDetailsScreen extends StatefulWidget with ErrorHandlingMixin {
  final PlantsDetailsViewModel viewModel;
  const PlantsDetailsScreen({super.key, required this.viewModel});

  @override
  State<PlantsDetailsScreen> createState() => _PlantsDetailsScreenState();
}

class _PlantsDetailsScreenState extends State<PlantsDetailsScreen> {
  late Stream<IPlant> _stream;
  @override
  void initState() {
    super.initState();
    _stream = widget.viewModel.plantStateStream(id: widget.viewModel.plantId);
    _stream.listen((event) {
      widget.viewModel.initControllers(event.videos);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: StreamBuilder<IPlant>(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    IPlant plant = snapshot.data!;
                    return Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width,
                            child: CachedImageWidget(imageUrl: plant.image)),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              plant.name,
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
                        CategoryRow(
                            onPressed: () => _showPicker(context,
                                isVideo: false, isGalleryOptionProvided: true),
                            title: "all_users_photos".tr().toString()),
                        FilesList(
                            onTap: ({required int index}) => widget.viewModel
                                .navigateToCarouselScrollPage(
                                    data: plant.photos,
                                    index: index,
                                    isVideo: false),
                            files: plant.photos,
                            isVideo: false),
                        CategoryRow(
                            onPressed: () => _showPicker(
                                  context,
                                  isVideo: true,
                                  isGalleryOptionProvided: false,
                                ),
                            title: "all_users_videos".tr().toString()),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: VideoGrid(
                              controllers: widget.viewModel.controllers,
                              addControllers: widget.viewModel.addControllers,
                              disposeControllers:
                                  widget.viewModel.disposeControllers,
                              videoControllerStream:
                                  widget.viewModel.videoGridStream,
                              onVideoPreviewTap: ({required int index}) =>
                                  widget.viewModel.navigateToCarouselScrollPage(
                                      data: plant.videos,
                                      index: index,
                                      isVideo: true)),
                        )
                      ],
                    );
                  }
                  return const CircularProgressIndicator(
                    color: AppColors.oliveGreenColor,
                  );
                } else if (snapshot.hasError) {
                  return Text("Error occured: ${snapshot.error.toString()}");
                } else {
                  return const CircularProgressIndicator(
                    color: AppColors.oliveGreenColor,
                  );
                }
              })),
      backgroundColor: AppColors.darkWoodGeenColor,
    );
  }

  void _showPicker(context,
      {required bool isGalleryOptionProvided, required bool isVideo}) {
    Modals.showPopUpModal(
      context: context,
      data: PopUpDialogData(
          title: 'load'.tr().toString(),
          content: PickerContent(
              onCameraTap: () => widget.viewModel.addPlantFileFromCamera(
                    context,
                    isVideo: isVideo,
                  ),
              onGalleryTap: isGalleryOptionProvided
                  ? () => widget.viewModel.addPlantFileFromGallery(
                      isVideo: isVideo,
                      onError: (err) => widget.showErrorDialog(context, err))
                  : null),
          actions: []),
    );
  }
}
