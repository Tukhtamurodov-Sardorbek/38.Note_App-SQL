import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app_sql_database/models/note.dart';
import 'package:note_app_sql_database/services/sql_database.dart';

class HomeProvider extends ChangeNotifier {
  // * Fields
  List<Note> _notes = [];
  List<int> _NotesToBeDeleted = [];
  bool _isLoading = false;
  bool _isAscendingOrder = true;
  bool _byTime = true;
  int _currIndex = 0;
  int _currIndex1 = 0;

  final Map<Color, Color> _gradients = {
    const Color(0xffffc837) : const Color(0xffff8008),
    // const Color(0xff8a0dca) : const Color(0xff2410c6),
    const Color(0xffff00d4) : const Color(0xff00ddff),
    const Color(0xffe6fffd) : const Color(0xffb7ccc7),
    const Color(0xffb77aff) : const Color(0xff7e00ff),
    // const Color(0xffe100ff) : const Color(0xff7f00ff),
    // const Color(0xff00aeef) : const Color(0xff2d388a),
    const Color(0xff00c6ff) : const Color(0xff0072ff),
    const Color(0xfff095ff) : const Color(0xfff64848),
    const Color(0xffe8c3fd) : const Color(0xff86c5fc),
    const Color(0xff80f9b7) : const Color(0xff9abdeb),
    const Color(0xff43cbff) : const Color(0xff9708cc),
    const Color(0xfff761a1) : const Color(0xff8c1bab),
    const Color(0xfffffcfc) : const Color(0xff2deffd),
    const Color(0xff02fe00) : const Color(0xff02b200),
    const Color(0xff2aeeff) : const Color(0xff5580eb),
    const Color(0xff4776e6) : const Color(0xff8e54e9),
    const Color(0xfffd0e0e) : const Color(0xff650606),
  };

  late AnimationController _animationController;
  bool _isPlaying = false;


  // * Getters & Setters
  List<Note> get notes => _notes;
  set notes(List<Note> value) {
    _notes = value;
    notifyListeners();
  }

  List<int> get notesToBeDeleted => _NotesToBeDeleted;
  addElement(int id){
    if(!_NotesToBeDeleted.contains(id)){
      _NotesToBeDeleted.add(id);
      notifyListeners();
    }
  }
  removeElement(int id){
    if(_NotesToBeDeleted.contains(id)){
      _NotesToBeDeleted.remove(id);
      notifyListeners();
    }
  }
  clear(){
    if(_NotesToBeDeleted.isNotEmpty){
      _NotesToBeDeleted.clear();
      notifyListeners();
    }
  }

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    if(value != _isLoading){
      _isLoading = value;
      notifyListeners();
    }
  }

  bool get isPlaying => _isPlaying;
  set isPlaying(bool value) {
    if(value != _isPlaying){
      _isPlaying = value;
      notifyListeners();
    }
  }

  AnimationController get animationController => _animationController;
  set animationController (AnimationController value){
    _animationController = value;
    notifyListeners();
  }

  Map<Color, Color> get gradients => _gradients;

  int get currentIndex => _currIndex;
  set currentIndex(int value) {
    if(value != _currIndex){
      _currIndex = value;
      notifyListeners();
    }
  }
  int get currentIndex1 => _currIndex1;
  set currentIndex1(int value) {
    if(value != _currIndex1){
      _currIndex1 = value;
      notifyListeners();
    }
  }

  isAscendingOrder() {
    _isAscendingOrder = !_isAscendingOrder;
    notifyListeners();
  }
  byTime() {
    _byTime = !_byTime;
    notifyListeners();
  }
  isSelected(Note note) {
    note.isSelected = !note.isSelected;
    notifyListeners();
  }


  String time (Note note) => DateFormat.yMMMd().add_jms().format(note.createdTime);
  double minHeight (int index) => _getMinHeight(index);

  // * Methods
  Future refreshNotes() async {
    notes.map((e) => print(e.id));
    for(int i = 0; i< notes.length; i++){
      print(notes[i].id);
    }
    isLoading = true;
    notes = await SQLDatabase.instance.readAll(_isAscendingOrder, _byTime);
    isLoading = false;
  }

  Future closeDatabase() async{
    SQLDatabase.instance.close();
  }

  /// To return different height for different widgets
  double _getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }

  void handleOnPressed() {
    isPlaying = !isPlaying;
    isPlaying ? _animationController.forward() : _animationController.reverse();
  }
}
