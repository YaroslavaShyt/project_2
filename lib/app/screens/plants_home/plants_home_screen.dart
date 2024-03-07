import 'package:flutter/material.dart';
import 'package:project_2/app/common/widgets/modals/modal_bottom_sheet/modal_bottom_dialog_data.dart';
import 'package:project_2/app/common/widgets/modals/modals_service.dart';
import 'package:project_2/app/common/widgets/modals/pop_up_dialog/pop_up_dialog_data.dart';
import 'package:project_2/app/screens/plants_home/plants_home_view_model.dart';
import 'package:project_2/app/screens/plants_home/widgets/list_header.dart';
import 'package:project_2/app/screens/plants_home/widgets/plant_list_item.dart';
import 'package:project_2/app/theming/app_colors.dart';
import 'package:project_2/domain/plants/iplant.dart';

class PlantsHomeScreen extends StatelessWidget {
  final PlantsHomeViewModel plantsHomeViewModel;
  const PlantsHomeScreen({super.key, required this.plantsHomeViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Plant App"),
        actions: [
          IconButton(
              onPressed: () => _changeTitles(context, true),
              icon: const Icon(Icons.text_increase)),
          IconButton(
              onPressed: () => _changeTitles(context, false),
              icon: const Icon(Icons.text_decrease)),
          IconButton(
              onPressed: () => _showAddPlantModal(context),
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: plantsHomeViewModel.onLogoutButtonPressed,
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: StreamBuilder(
          stream: plantsHomeViewModel.getPlantsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  const ListHeader(),
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
                              onDeleteButtonPressed: () => plantsHomeViewModel
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
    );
  }

  void _changeTitles(BuildContext context, bool isUpperCase) {
    plantsHomeViewModel.changeCaseTitles(isUpper: isUpperCase).then((value) {
      if (!value["success"]) {
        _showErrorDialog(context, value["message"] ?? "Виникла помилка");
      }
    });
  }

  void _showAddPlantModal(BuildContext context) {
    ModalsService.showBottomModal(
      context: context,
      data: ModalBottomDialogData(
        title: 'Нова рослина',
        firstLabel: 'Назва',
        secondLabel: 'Кількість',
        buttonTitle: 'Додати',
        firstErrorText: plantsHomeViewModel.newPlantNameError,
        secondErrorText: plantsHomeViewModel.newPlantQuantityError,
        onFirstTextFieldChanged: (value) =>
            plantsHomeViewModel.newPlantName = value,
        onSecondTextFieldChanged: (value) =>
            plantsHomeViewModel.newPlantQuantity = value,
        onButtonPressed: () {
          plantsHomeViewModel.onAddPlantButtonPressed();
        },
      ),
    );
  }

  void _showEditPlantModal(BuildContext context, IPlant plant) {
    plantsHomeViewModel.newPlantName = plant.name;
    plantsHomeViewModel.newPlantQuantity = plant.quantity;

    ModalsService.showBottomModal(
      context: context,
      data: ModalBottomDialogData(
        title: 'Редагувати',
        firstLabel: 'Нова назва',
        secondLabel: 'Нова кількість',
        buttonTitle: 'Зберегти',
        firstFieldValue: plant.name,
        secondFieldValue: plant.quantity,
        firstErrorText: plantsHomeViewModel.newPlantNameError,
        secondErrorText: plantsHomeViewModel.newPlantQuantityError,
        onFirstTextFieldChanged: (value) =>
            plantsHomeViewModel.newPlantName = value,
        onSecondTextFieldChanged: (value) =>
            plantsHomeViewModel.newPlantQuantity = value,
        onButtonPressed: () => plantsHomeViewModel.onUpdatePlantButtonPressed(
          id: plant.id,
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    ModalsService.showPopUpModal(
      context: context,
      data: PopUpDialogData(
        title: 'Помилка',
        content: Text(
          message,
          style: const TextStyle(color: AppColors.whiteColor),
        ),
        actions: [],
      ),
    );
  }
}
