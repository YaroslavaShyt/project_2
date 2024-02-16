import 'package:flutter/material.dart';

class BaseChangeNotifier extends ChangeNotifier {
  bool _isDataLoading = false;
  bool _isDataLoaded = false;

  bool get isDataLoading => _isDataLoading;
  bool get isDataLoaded => _isDataLoaded;

  void setIsDataLoading(bool value) {
    _isDataLoading = value;
    notifyListeners();
  }

  void setIsDataLoaded(bool value) {
    _isDataLoaded = value;
    notifyListeners();
  }
}
