import 'package:flutter/material.dart';

class AddTaskProvider with ChangeNotifier {
  String _title = '';
  String _description = '';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Getters
  String get title => _title;
  String get description => _description;
  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;


  // Setters with notifyListeners
  void setTitle(String value) {
    _title = value;
    notifyListeners();
  }

  void setDescription(String value) {
    _description = value;
    notifyListeners();
  }

  void setDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
  }

  void setTime(TimeOfDay value) {
    _selectedTime = value;
    notifyListeners();
  }



  void resetForm() {
    _title = '';
    _description = '';
    _selectedDate = null;
    _selectedTime = null;
    notifyListeners();
  }
}
