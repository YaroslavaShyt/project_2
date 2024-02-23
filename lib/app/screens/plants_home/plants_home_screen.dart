import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/common/widgets/main_elevated_button.dart';
import 'package:project_2/app/screens/plants_home/plants_home_view_model.dart';
import 'package:project_2/app/screens/plants_home/widgets/list_header.dart';
import 'package:project_2/app/screens/plants_home/widgets/plant_list_item.dart';
import 'package:project_2/app/services/network_storage/collections.dart';
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
              onPressed: () => openAddPlantModal(context),
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
                              onEditButtonPressed: () {},
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
                color: AppColors.oliveGreenColor,
              ),
            );
          }),
    );
  }

  void openAddPlantModal(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Нова рослина'),
              TextField(
                controller: nameController,
                onChanged: (value) => plantsHomeViewModel.newPlantName = value,
                decoration: InputDecoration(
                    label: const Text('Назва'),
                    errorText: plantsHomeViewModel.newPlantNameError),
              ),
              TextField(
                controller: quantityController,
                onChanged: (value) =>
                    plantsHomeViewModel.newPlantQuantity = value,
                decoration: InputDecoration(
                    label: const Text('Кількість'),
                    errorText: plantsHomeViewModel.newPlantQuantityError),
              ),
              MainElevatedButton(
                  onButtonPressed: () =>
                      plantsHomeViewModel.onAddPlantButtonPressed(),
                  title: 'Додати')
            ],
          ),
        );
      },
    );
  }
}
