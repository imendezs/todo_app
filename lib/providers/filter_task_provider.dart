import 'package:flutter/material.dart';

class FilterTaskProvider extends ChangeNotifier {
  List<String> selectedStatuses = [];
  List<String> selectedPriorities = [];

  void updateStatuses(List<String> newStatuses) {
    selectedStatuses = newStatuses;
    notifyListeners();
  }

  void updatePriorities(List<String> newPriorities) {
    selectedPriorities = newPriorities;
    notifyListeners();
  }

  void resetFilters() {
    selectedStatuses.clear();
    selectedPriorities.clear();
    notifyListeners();
  }
}
