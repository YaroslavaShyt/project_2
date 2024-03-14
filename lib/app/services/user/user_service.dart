import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:project_2/domain/user/iuser.dart';
import 'package:project_2/domain/user/iuser_repository.dart';

class UserService extends ChangeNotifier implements IUserService {
  final FirebaseAuth _firebaseAuth;
  final IUserRepository _userRepository;
  IMyUser? _user;

  UserService(
      {required FirebaseAuth firebaseAuth,
      required IUserRepository userRepository})
      : _firebaseAuth = firebaseAuth,
        _userRepository = userRepository;

  @override
  IMyUser? get user => _user;

  @override
  void setUser(IMyUser user) {
    _user = user;
    notifyListeners();
  }

  @override
  Future<IMyUser?> loadUserData() async {
    if (_firebaseAuth.currentUser?.uid != null) {
      IMyUser? data =
          await _userRepository.readUser(id: _firebaseAuth.currentUser!.uid);
      return data;
    }
    return null;
  }
}
