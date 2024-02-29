import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/screens/plants_home/plants_home_screen.dart';
import 'package:project_2/app/screens/plants_home/plants_home_view_model.dart';
import 'package:project_2/app/services/networking/functions/firebase_functions_service.dart';
import 'package:project_2/app/services/plants/plants_modification_service.dart';
import 'package:project_2/app/services/networking/storage/collections.dart';
import 'package:project_2/app/services/networking/storage/firebase_storage.dart';
import 'package:project_2/data/login/login_repository.dart';
import 'package:project_2/data/plants/plants_repository.dart';
import 'package:provider/provider.dart';

class PlantsHomeFactory {
  static Widget build(routeArguments) {
    return ChangeNotifierProvider(
      create: (context) => PlantsHomeViewModel(
          modificationService: PlantsModificationService(
              functionsService: FirebaseFunctionsService()),
          navigationUtil: context.read<INavigationUtil>(),
          plantsRepository: PlantsRepository(
              networkService: FirebaseStorage(
                  collection: plantsCollection,
                  firestore: FirebaseFirestore.instance)),
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
