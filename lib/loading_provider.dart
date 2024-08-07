import 'package:flutter/material.dart';

class LoadingProvider with ChangeNotifier {
  bool _isLoading = true;  // Start with loading set to true

  bool get isLoading => _isLoading;

  void startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    _isLoading = false;
    notifyListeners();
  }
}
