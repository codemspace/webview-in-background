import 'package:flutter/material.dart';

class LoadingProvider with ChangeNotifier {
  bool _isLoading = true;  // Start with loading set to true

  bool get isLoading => _isLoading;

  void startLoading() {
    print('------------------ loading start --------------------');
    _isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    print('------------------ loading end --------------------');
    _isLoading = false;
    notifyListeners();
  }
}
