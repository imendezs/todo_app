import 'package:flutter/material.dart';

class UpdateTaskStatusProvider extends ChangeNotifier {
  String _taskStatus = "Pendiente";
  bool _isButtonDisabled = false;

  String get taskStatus => _taskStatus;
  bool get isButtonDisabled => _isButtonDisabled;

  void setTaskStatus(String status) {
    _taskStatus = status;
    notifyListeners();
  }

  void setButtonDisabled(bool value) {
    _isButtonDisabled = value;
    notifyListeners();
  }
}
