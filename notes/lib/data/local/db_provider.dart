import 'package:flutter/material.dart';
import 'package:notes/data/local/db_helper.dart';

class DBProvider extends ChangeNotifier {
  DBHelper dbRef;
  DBProvider({required this.dbRef});
  List<Map<String, dynamic>> _mData = [];

  void addNote(String title, String desc) async{
    bool check = await dbRef.addNote(mTitle: title, mDesc: desc);
    if(check){
      _mData = await dbRef.getAllNotes();
      notifyListeners();
    }
  }


  void updateNote(String title, String desc, int Sno) async{
    bool check = await dbRef.updateNote(mTitle: title, mDesc: desc, mSno: Sno);
    if(check){
      _mData = await dbRef.getAllNotes();
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> getNotes() => _mData;

  void getInitialNotes() async{
    _mData = await dbRef.getAllNotes();
    notifyListeners();
  }

  void deleteNote(int Sno) async{
    bool check = await dbRef.deleteNotes(mSno: Sno);
    if(check) {
      _mData = await dbRef.getAllNotes();
      notifyListeners();
    }
  }

}