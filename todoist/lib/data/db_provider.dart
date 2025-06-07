import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'db_helper.dart';

class DBProvider extends ChangeNotifier{
  DBHelper dbRef;
  DBProvider({required this.dbRef});
  List<Map<String, dynamic>> _mData = [];
  List<Map<String, dynamic>> _filteredTasks = [];

  List<Map<String, dynamic>> getNotes() => _mData;
  List<Map<String, dynamic>> getFilteredNotes() => _filteredTasks;

  Future<void> addTask( String title, String desc,  String date,  String time) async {
    bool check = await dbRef.addTask(mTitle: title, mDesc: desc, mDate: date, mTime: time);
    if(check){
      _mData = await dbRef.getAllTasks();
      notifyListeners();
    }
  }

  Future<void> updateTask( int Sno,  String title,  String desc,  String date,  String time) async {
    bool check = await dbRef.updateTask(mTitle: title, mDesc: desc, mDate: date, mTime: time, mSno: Sno);
    if(check){
      _mData = await dbRef.getAllTasks();
      notifyListeners();
    }
  }

  Future<void> deleteTask({required Sno})async{
    bool check = await dbRef.deleteTask(mSno: Sno);
    if(check){
      _mData = await dbRef.getAllTasks();
      notifyListeners();
    }
  }

  Future<void> getTasksForDate(String date) async {
    final data = await dbRef.getNotesByDate(date);
    _filteredTasks = data;
    notifyListeners();
  }

  Future<void> getInitialTasks() async{
    _mData = await dbRef.getAllTasks();
    notifyListeners();
  }

  Future<void> updateTaskCompletion({required int Sno, required int completed}) async {
    await dbRef.updateTaskCompletion(Sno: Sno, completed: completed);
    await getInitialTasks(); // or getTasksForDate based on current mode
    notifyListeners();
  }

}
