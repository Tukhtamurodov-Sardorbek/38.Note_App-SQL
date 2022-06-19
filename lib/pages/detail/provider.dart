import 'package:flutter/material.dart';
import 'package:note_app_sql_database/models/note.dart';
import 'package:note_app_sql_database/services/sql_database.dart';

class DetailProvider extends ChangeNotifier {
  // * Fields
  late int _id;
  late Note _note;
  bool _isLoading = false;

  // * Getters & Setters
  int get id => _id;
  set id (int value) {
    _id = value;
    notifyListeners();
  }

  Note get note => _note;
  set note(Note value) {
    _note = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    if(value != _isLoading){
      _isLoading = value;
      notifyListeners();
    }
  }

  // * Methods
  Future refreshNote() async {
    isLoading = true;
    note = await SQLDatabase.instance.read(id);
    isLoading = false;
  }

}
