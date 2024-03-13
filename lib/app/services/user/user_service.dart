import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_2/data/user/user.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:project_2/domain/user/iuser.dart';

class UserService extends ChangeNotifier implements IUserService {
  final FirebaseAuth _firebaseAuth;
  IMyUser? _user;

  UserService({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth {
    if (_firebaseAuth.currentUser?.uid != null) {
      IMyUser user = MyUser(
          id: _firebaseAuth.currentUser!.uid,
          name: _firebaseAuth.currentUser!.displayName!,
          email: _firebaseAuth.currentUser!.email,
          profilePhoto: _firebaseAuth.currentUser!.photoURL);
      setUser(user);
    }
  }

  @override
  IMyUser? get user => _user;
  @override
  void setUser(IMyUser user) {
    _user = user;
    notifyListeners();
  }
}
