import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:project_2/app/services/networking/functions/firebase_functions_service.dart';
import 'package:project_2/app/services/networking/storage/firebase_storage.dart';
import 'package:project_2/data/login/login_repository.dart';
import 'package:project_2/data/plants/plants_repository.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:project_2/domain/plants/iplants_repository.dart';

final getItInst = GetIt.I;

Future init() async {
  getItInst.registerFactory<IPlantsRepository>(() => PlantsRepository(
      networkService: FirebaseStorage(firestore: FirebaseFirestore.instance),
      firebaseFunctionsService: FirebaseFunctionsService()));

  getItInst.registerFactory<ILoginRepository>(
      () => LoginRepository(firebaseAuth: FirebaseAuth.instance));
}
