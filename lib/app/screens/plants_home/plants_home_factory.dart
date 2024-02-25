import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/screens/plants_home/plants_home_screen.dart';
import 'package:project_2/app/screens/plants_home/plants_home_view_model.dart';
import 'package:project_2/app/services/user/iuser_service.dart';
import 'package:project_2/app/services/networking/collections.dart';
import 'package:project_2/app/services/networking/firebase_storage.dart';
import 'package:project_2/data/login/login_repository.dart';
import 'package:project_2/data/plants/plants_repository.dart';
import 'package:provider/provider.dart';

class PlantsHomeFactory {
  static Widget build(routeArguments) {
    return ChangeNotifierProvider(
      create: (context) => PlantsHomeViewModel(
          navigationUtil: context.read<INavigationUtil>(),
          plantsRepository: PlantsRepository(
              networkService: FirebaseStorage(
                  collection: plantsCollection,
                  firestore: FirebaseFirestore.instance)),
          userService: context.read<IUserService>(),
          loginRepository:
              LoginRepository(firebaseAuth: FirebaseAuth.instance)),
      child: Consumer<PlantsHomeViewModel>(builder: (context, model, child) {
        return PlantsHomeScreen(
          plantsHomeViewModel: model,
        );
      }),
    );
  }
}
