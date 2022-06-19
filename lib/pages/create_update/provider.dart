import 'package:flutter/material.dart';
import 'package:note_app_sql_database/models/note.dart';
import 'package:note_app_sql_database/services/sql_database.dart';

class CreateUpdateProvider extends ChangeNotifier {
  // * Fields
  final _formKey = GlobalKey<FormState>();
  bool? _isImportant;
  late String _title;
  late String _description;

  // * Getters & Setters
  GlobalKey<FormState> get key => _formKey;
  bool? get isImportant => _isImportant;
  String get title => _title;
  String get description => _description;

  set isImportant(bool? value) {
    _isImportant = value;
    notifyListeners();
  }

  set title(String value) {
    _title = value;
    notifyListeners();
  }
  set description(String value) {
    _description = value;
    notifyListeners();
  }

  // * Methods
  Future<void> createOrUpdate(Note? note, BuildContext context) async{
    final isValid = _formKey.currentState!.validate();

    if(isValid){
      final isUpdating = note != null;

      if(isUpdating){
        await _updateNote(note);
      }else{
        await _addNote();
      }

      Navigator.pop(context);
    }
  }

  Future _updateNote(Note? _note) async{
    final note = _note!.copy(
      isImportant: isImportant,
      title: title,
      description: description,
    );
    await SQLDatabase.instance.update(note);
  }

  Future _addNote() async{
    final note = Note(
      title: title,
      isImportant: isImportant ?? false,
      description: description,
      createdTime: DateTime.now(),
    );
    await SQLDatabase.instance.create(note);
  }

  isFormValid () => title.isNotEmpty && description.isNotEmpty;

  void onInit(Note? note){
    isImportant = note?.isImportant;
    title = note?.title ?? '';
    description = note?.description ?? '';
  }
}
