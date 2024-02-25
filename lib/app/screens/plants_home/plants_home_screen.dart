import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/common/modals/modal_bottom_sheet/modal_bottom_sheet_content_data.dart';
import 'package:project_2/app/common/modals/modals_service.dart';
import 'package:project_2/app/screens/plants_home/plants_home_view_model.dart';
import 'package:project_2/app/screens/plants_home/widgets/list_header.dart';
import 'package:project_2/app/screens/plants_home/widgets/plant_list_item.dart';
import 'package:project_2/app/services/networking/collections.dart';
import 'package:project_2/app/theming/app_colors.dart';

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
              onPressed: () => ModalsService.showBottomModal(
                  context: context,
                  data: ModalBottomSheetContentData(
                    title: 'Нова рослина',
                    firstLabel: 'Назва',
                    secondLabel: 'Кількість',
                    buttonTitle: 'Додати',
                    onFirstTextFieldChanged: (value) =>
                        plantsHomeViewModel.newPlantName = value,
                    onSecondTextFieldChanged: (value) =>
                        plantsHomeViewModel.newPlantQuantity = value,
                    onButtonPressed:
                        plantsHomeViewModel.onAddPlantButtonPressed,
                  )),
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: plantsHomeViewModel.onLogoutButtonPressed,
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(plantsCollection)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  const ListHeader(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 400.0,
                    child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        itemCount: snapshot.data?.docs.length ?? 0,
                        itemBuilder: (context, index) {
                          QueryDocumentSnapshot<Map<String, dynamic>>? data =
                              snapshot.data?.docs[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: PlantListItem(
                              title: data?.data()["name"] ?? 'custom name',
                              quantity: data?.data()["quantity"] ?? '0',
                              onEditButtonPressed: () {
                                plantsHomeViewModel.newPlantName =
                                    data?.data()["name"] ?? 'custom name';
                                plantsHomeViewModel.newPlantQuantity =
                                    data?.data()["quantity"] ?? '0';
                                ModalsService.showBottomModal(
                                    context: context,
                                    data: ModalBottomSheetContentData(
                                        title: 'Редагувати',
                                        firstLabel: 'Нова назва',
                                        secondLabel: 'Нова кількість',
                                        buttonTitle: 'Зберегти',
                                        firstFieldValue: data?.data()["name"] ??
                                            '',
                                        secondFieldValue:
                                            data?.data()["quantity"] ?? '',
                                        onFirstTextFieldChanged: (value) =>
                                            plantsHomeViewModel.newPlantName =
                                                value,
                                        onSecondTextFieldChanged: (value) =>
                                            plantsHomeViewModel
                                                .newPlantQuantity = value,
                                        onButtonPressed: () =>
                                            plantsHomeViewModel
                                                .onUpdatePlantButtonPressed(
                                                    id: data?.id ?? '')));
                              },
                              onDeleteButtonPressed: () => plantsHomeViewModel
                                  .onDeletePlantButtonPressed(
                                      id: data?.id ?? ''),
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
}
