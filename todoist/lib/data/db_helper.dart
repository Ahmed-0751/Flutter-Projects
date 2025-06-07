import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {

  DBHelper._();
  static final DBHelper getInstance = DBHelper._();

  Database? myDB;

  static final String TODO_TABLE = "todo";
  static final String COLUMN_TODO_SNO = "sno";
  static final String COLUMN_TODO_TITLE = "title";
  static final String COLUMN_TODO_DESC = "desc";
  static final String COLUMN_TODO_DATE = "date";
  static final String COLUMN_TODO_TIME = "time";
  static final String COLUMN_TODO_COMPLETE = "completed";



  Future<Database> getDB() async{
    if(myDB != null){
      return myDB!;
    } else {
      myDB = await openDB();
      return myDB!;
    }
  }

  Future<Database> openDB() async{
    Directory appDir = await getApplicationDocumentsDirectory();
    
    String dbPath = join(appDir.path, "todoist.db");

    return await openDatabase(dbPath, onCreate: (db, version) async {

      ///Create all tables here
      db.execute("create table $TODO_TABLE  ("
          "$COLUMN_TODO_SNO INTEGER PRIMARY KEY AUTOINCREMENT, "
          "$COLUMN_TODO_TITLE TEXT, "
          "$COLUMN_TODO_DESC TEXT, "
          "$COLUMN_TODO_DATE DATE, "
          "$COLUMN_TODO_TIME TIME, "
          "$COLUMN_TODO_COMPLETE INTEGER DEFAULT 0"
          ")");

    }, version: 1
    );
  }

  Future<bool> addTask({required String mTitle, required String mDesc, required String mDate, required String mTime}) async{
    var db = await getDB();
      int rowsEffected = await db.insert("$TODO_TABLE", {
      COLUMN_TODO_TITLE: mTitle,
      COLUMN_TODO_DESC: mDesc,
      COLUMN_TODO_DATE: mDate,
      COLUMN_TODO_TIME: mTime
    });
      return rowsEffected>0;
  }

  Future<bool> updateTask({required int mSno, required String mTitle, required String mDesc, required String mDate, required String mTime}) async{
    var db = await getDB();
    int rowsEffected = await db.update(
      TODO_TABLE,
      {
        COLUMN_TODO_TITLE: mTitle,
        COLUMN_TODO_DESC: mDesc,
        COLUMN_TODO_DATE: mDate,
        COLUMN_TODO_TIME: mTime
      },
      where: '$COLUMN_TODO_SNO = ?',
      whereArgs: [mSno],
    );  // ✅

    return rowsEffected>0;
  }


  Future<List<Map<String, dynamic>>> getAllTasks() async{
    var db = await getDB();
    List<Map<String,dynamic>> _mData = await db.query(TODO_TABLE);
    return _mData;
  }

  Future<bool> deleteTask({required mSno}) async{
    var db = await getDB();
    int rowsEffected = await db.delete(TODO_TABLE, where: '$COLUMN_TODO_SNO = $mSno');
    return rowsEffected>0;
  }

  Future<List<Map<String, dynamic>>> getNotesByDate(String date) async {
    final db = await getDB();
    return await db.query(
      TODO_TABLE,
      where: '$COLUMN_TODO_DATE = ?',
      whereArgs: [date],
    );
  }

  Future<void> updateTaskCompletion({required int Sno, required int completed}) async {
    final db = await getDB();
    await db.update(
      TODO_TABLE,
      {'$COLUMN_TODO_COMPLETE': completed},
      where: '$COLUMN_TODO_SNO = ?',
      whereArgs: [Sno],
    );
  }


}