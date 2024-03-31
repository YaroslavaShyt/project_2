import 'package:project_2/app/common/widgets/modals/modal_bottom_sheet/modal_bottom_dialog_data.dart';
import 'package:project_2/app/common/widgets/modals/pop_up_dialog/pop_up_dialog_data.dart';
import 'package:project_2/app/screens/plants_home/widgets/build_drawer_item.dart';
import 'package:project_2/app/screens/plants_home/widgets/plant_list_item.dart';
import 'package:project_2/app/common/error_handling/error_handling_mixin.dart';
import 'package:project_2/app/screens/plants_home/plants_home_view_model.dart';
import 'package:project_2/app/screens/plants_home/widgets/picker_content.dart';
import 'package:project_2/app/screens/plants_home/widgets/clear_cache.dart';
import 'package:project_2/app/common/widgets/modals/modals_service.dart';
import 'package:project_2/app/common/widgets/chached_image.dart';
import 'package:project_2/app/theming/app_colors.dart';
import 'package:project_2/domain/plants/iplant.dart';
import 'package:flutter/material.dart';

class PlantsHomeScreen extends StatefulWidget with ErrorHandlingMixin {
  final PlantsHomeViewModel viewModel;
  const PlantsHomeScreen({super.key, required this.viewModel});

  @override
  State<PlantsHomeScreen> createState() => _PlantsHomeScreenState();
}

class _PlantsHomeScreenState extends State<PlantsHomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.askPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkWoodGeenColor,
        automaticallyImplyLeading: false,
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Plant App",
            style: TextStyle(
                color: AppColors.whiteColor, fontWeight: FontWeight.bold),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: Scaffold.of(context).openDrawer,
            icon: const Icon(
              Icons.menu,
              color: AppColors.whiteColor,
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: widget.viewModel.downloadPlants,
              icon: const Icon(
                Icons.download,
                color: AppColors.whiteColor,
              )),
          widget.viewModel.user == null ||
                  widget.viewModel.user!.profilePhoto == null
              ? const Icon(Icons.person)
              : CachedImageWidget(
                  imageUrl: widget.viewModel.user!.profilePhoto!),
          const SizedBox(
            width: 30.0,
          ),
        ],
      ),
      body: StreamBuilder(
          stream: widget.viewModel.getPlantsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        itemCount: snapshot.data?.data.length ?? 0,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => widget.viewModel
                                .navigateToPlantDetails(
                                    snapshot.data!.data[index]),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: PlantListItem(
                                plant: snapshot.data!.data[index],
                                onEditButtonPressed: () => _showEditPlantModal(
                                    context, snapshot.data!.data[index]),
                                onDeleteButtonPressed: () => widget.viewModel
                                    .onDeletePlantButtonPressed(
                                        id: snapshot.data!.data[index].id),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.darkWoodGeenColor,
              ),
            );
          }),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  widget.viewModel.user == null ||
                          widget.viewModel.user!.profilePhoto == null
                      ? IconButton(
                          onPressed: () => _showPicker(context),
                          icon: const Icon(Icons.add_a_photo_outlined))
                      : SizedBox(
                          height: 100,
                          child: CachedImageWidget(
                              imageUrl: widget.viewModel.user!.profilePhoto!),
                        ),
                  Text(widget.viewModel.user?.name ?? 'Анонім')
                ],
              ),
            ),
            buildDrawerItem(
                Icons.add, 'Нова рослина', () => _showAddPlantModal(context)),
            const ClearCacheWidget(),
            buildDrawerItem(Icons.logout_rounded, 'Вихід',
                widget.viewModel.onLogoutButtonPressed),
          ],
        ),
      ),
      backgroundColor: AppColors.darkWoodGeenColor,
    );
  }

  void _showAddPlantModal(BuildContext context) {
    ModalsService.showBottomModal(
      context: context,
      data: ModalBottomDialogData(
          title: 'Нова рослина',
          firstLabel: 'Назва',
          secondLabel: 'Кількість',
          buttonTitle: 'Додати',
          firstErrorText: widget.viewModel.newPlantNameError,
          secondErrorText: widget.viewModel.newPlantQuantityError,
          onFirstTextFieldChanged: (value) =>
              widget.viewModel.newPlantName = value,
          onSecondTextFieldChanged: (value) =>
              widget.viewModel.newPlantQuantity = value,
          onButtonPressed: widget.viewModel.onAddPlantButtonPressed),
    );
  }

  void _showEditPlantModal(BuildContext context, IPlant plant) {
    widget.viewModel.newPlantName = plant.name;
    widget.viewModel.newPlantQuantity = plant.quantity;

    ModalsService.showBottomModal(
      context: context,
      data: ModalBottomDialogData(
        title: 'Редагувати',
        firstLabel: 'Нова назва',
        secondLabel: 'Нова кількість',
        buttonTitle: 'Зберегти',
        firstFieldValue: plant.name,
        secondFieldValue: plant.quantity,
        firstErrorText: widget.viewModel.newPlantNameError,
        secondErrorText: widget.viewModel.newPlantQuantityError,
        onFirstTextFieldChanged: (value) =>
            widget.viewModel.newPlantName = value,
        onSecondTextFieldChanged: (value) =>
            widget.viewModel.newPlantQuantity = value,
        onButtonPressed: () => widget.viewModel.onUpdatePlantButtonPressed(
          id: plant.id,
        ),
      ),
    );
  }

  void _showPicker(context) {
    ModalsService.showPopUpModal(
        context: context,
        data: PopUpDialogData(
            title: 'Завантажити фото ',
            content: PickerContent(
                onCameraTap: () => widget.viewModel.onAddProfileImage(
                    onError: (err) => widget.showErrorDialog(context, err),
                    type: PhotoSourceType.camera),
                onGalleryTap: () => widget.viewModel.onAddProfileImage(
                    onError: (err) => widget.showErrorDialog(context, err))),
            actions: []));
  }
}
