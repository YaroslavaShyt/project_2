import 'package:flutter/material.dart';

class BaseChangeNotifier extends ChangeNotifier {
  bool _isDataLoaded = true;

  bool get isDataLoaded => _isDataLoaded;


  void setIsDataLoaded(bool value) {
    _isDataLoaded = value;
    notifyListeners();
  }
}
