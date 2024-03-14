import 'package:flutter/material.dart';
import 'package:project_2/app/common/error_handling/error_handling_mixin.dart';
import 'package:project_2/app/common/widgets/modals/modal_bottom_sheet/modal_bottom_dialog_data.dart';
import 'package:project_2/app/common/widgets/modals/modals_service.dart';
import 'package:project_2/app/common/widgets/modals/pop_up_dialog/pop_up_dialog_data.dart';
import 'package:project_2/app/screens/plants_home/plants_home_view_model.dart';
import 'package:project_2/app/screens/plants_home/widgets/picker_content.dart';
import 'package:project_2/app/screens/plants_home/widgets/plant_list_item.dart';
import 'package:project_2/app/theming/app_colors.dart';
import 'package:project_2/domain/plants/iplant.dart';

class PlantsHomeScreen extends StatefulWidget with ErrorHandlingMixin {
  final PlantsHomeViewModel plantsHomeViewModel;
  const PlantsHomeScreen({super.key, required this.plantsHomeViewModel});

  @override
  State<PlantsHomeScreen> createState() => _PlantsHomeScreenState();
}

class _PlantsHomeScreenState extends State<PlantsHomeScreen> {
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
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Відкриття Drawer
            },
            icon: const Icon(
              Icons.menu,
              color: AppColors.whiteColor,
            ),
          ),
        ),
        actions: [
          widget.plantsHomeViewModel.user == null ||
                  widget.plantsHomeViewModel.user!.profilePhoto == null
              ? const Icon(Icons.person)
              : Image.network(widget.plantsHomeViewModel.user!.profilePhoto!),
          const SizedBox(
            width: 30.0,
          ),
        ],
      ),
      body: StreamBuilder(
          stream: widget.plantsHomeViewModel.getPlantsStream,
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
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: PlantListItem(
                              plant: snapshot.data!.data[index],
                              onEditButtonPressed: () => _showEditPlantModal(
                                  context, snapshot.data!.data[index]),
                              onDeleteButtonPressed: () => widget
                                  .plantsHomeViewModel
                                  .onDeletePlantButtonPressed(
                                      id: snapshot.data!.data[index].id),
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
                  widget.plantsHomeViewModel.user == null ||
                          widget.plantsHomeViewModel.user!.profilePhoto == null
                      ? IconButton(
                          onPressed: () => _showPicker(context),
                          icon: const Icon(Icons.add_a_photo_outlined))
                      : SizedBox(
                          height: 100,
                          child: Image.network(
                              widget.plantsHomeViewModel.user!.profilePhoto!),
                        ),
                  Text(widget.plantsHomeViewModel.user?.name ?? 'Анонім')
                ],
              ),
            ),
            ListTile(
              leading: IconButton(
                  onPressed: () => _showAddPlantModal(context),
                  icon: const Icon(Icons.add)),
              title: const Text("Нова рослина"),
            ),
            ListTile(
              leading: IconButton(
                  onPressed: widget.plantsHomeViewModel.onLogoutButtonPressed,
                  icon: const Icon(Icons.logout_rounded)),
              title: const Text("Вихід"),
            )
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
        firstErrorText: widget.plantsHomeViewModel.newPlantNameError,
        secondErrorText: widget.plantsHomeViewModel.newPlantQuantityError,
        onFirstTextFieldChanged: (value) =>
            widget.plantsHomeViewModel.newPlantName = value,
        onSecondTextFieldChanged: (value) =>
            widget.plantsHomeViewModel.newPlantQuantity = value,
        onButtonPressed: () {
          widget.plantsHomeViewModel.onAddPlantButtonPressed();
        },
      ),
    );
  }

  void _showEditPlantModal(BuildContext context, IPlant plant) {
    widget.plantsHomeViewModel.newPlantName = plant.name;
    widget.plantsHomeViewModel.newPlantQuantity = plant.quantity;

    ModalsService.showBottomModal(
      context: context,
      data: ModalBottomDialogData(
        title: 'Редагувати',
        firstLabel: 'Нова назва',
        secondLabel: 'Нова кількість',
        buttonTitle: 'Зберегти',
        firstFieldValue: plant.name,
        secondFieldValue: plant.quantity,
        firstErrorText: widget.plantsHomeViewModel.newPlantNameError,
        secondErrorText: widget.plantsHomeViewModel.newPlantQuantityError,
        onFirstTextFieldChanged: (value) =>
            widget.plantsHomeViewModel.newPlantName = value,
        onSecondTextFieldChanged: (value) =>
            widget.plantsHomeViewModel.newPlantQuantity = value,
        onButtonPressed: () =>
            widget.plantsHomeViewModel.onUpdatePlantButtonPressed(
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
                onCameraTap: () => widget.plantsHomeViewModel.onAddProfileImage(
                    onError: (err) => widget.showErrorDialog(context, err),
                    type: 'Camera'),
                onGalleryTap: () => widget.plantsHomeViewModel
                    .onAddProfileImage(
                        onError: (err) =>
                            widget.showErrorDialog(context, err))),
            actions: []));
  }
}
