import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:notes/main.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {

  //Don't wanna create multiple instances of this class so we make a only constructor of this class with ._ which doesn't allow to make multiple instances of a class
  DBHelper._();

  //As we don't have permission now to make instances of this class outside of this class... so we created a instance inside this class with static keyword... now we can use this anywhere outside without creating multiple instances...it means there is only a single instance of this class which can used every where in the project... ,,
  static final DBHelper getInstance = DBHelper._();

  ///Table notes
  static final TABLE_NOTE = "note";
  static final COLUMN_NOTE_SNO = "sno";
  static final COLUMN_NOTE_TITLE = "title";
  static final COLUMN_NOTE_DESC = "desc";

  //Create an instance of Database class which is from sqflite pkg
  //The ? after database represents the var myDB can be null
  Database? myDB;

  ///db open (path -> if esixts then open else create db)

  //Its job: ensure that the database is opened only once and reused afterward.
  //myDB!: The ! (bang operator) asserts it's not null — you're telling Dart “trust me, it's not null”
  Future<Database> getDB() async{
    if(myDB!=null){
      return myDB!;
    } else {
      myDB = await openDB();
      return myDB!;
    }
  }

  Future<Database> openDB() async{

    //Uses path_provider to get a directory on the device where the app can store files.
    Directory appDir = await getApplicationDocumentsDirectory();

    //This will create a noteDB.db named file in the specified directory
    String dbPath = join(appDir.path, "noteDB.db");

    //Opens the SQLite database file at the path created above.
    //If it doesn’t exist, it gets created.
    //dbPath: Where the DB file is stored.
    // onCreate: Callback that runs only once, when the DB is first created.
    return await openDatabase(dbPath, onCreate: (db, version){

      /// create all tables here
      db.execute("create table $TABLE_NOTE ($COLUMN_NOTE_SNO INTEGER PRIMARY KEY AUTOINCREMENT, $COLUMN_NOTE_TITLE TEXT, $COLUMN_NOTE_DESC TEXT)");

    }, version: 1);
  }

  ///all querries
  ///insertion in table
  Future<bool> addNote({required String mTitle, required String mDesc}) async{
    var db = await getDB();

    int rowsEffected = await db.insert(TABLE_NOTE, {
      COLUMN_NOTE_TITLE: mTitle,
      COLUMN_NOTE_DESC: mDesc
    });
    return rowsEffected>0;
  }

  ///getData from table
  Future<List<Map<String, dynamic>>> getAllNotes() async{

    var db = await getDB();
    List<Map<String, dynamic>> mData = await db.query(TABLE_NOTE);
    return mData;
  }

  Future<bool> updateNote({required String mTitle, required String mDesc, required int mSno}) async{
    var db = await getDB();

    int rowsEffected = await db.update('$TABLE_NOTE', {
      COLUMN_NOTE_TITLE: mTitle,
      COLUMN_NOTE_DESC: mDesc
    }, where: "$COLUMN_NOTE_SNO = $mSno" );
    return rowsEffected>0;
  }

  Future<bool> deleteNotes({required mSno}) async{
    var db = await getDB();

    int rowsEffected = await db.delete('$TABLE_NOTE', where: "$COLUMN_NOTE_SNO = $mSno");
     return rowsEffected>0;
  }

}