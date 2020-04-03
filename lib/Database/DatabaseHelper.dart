
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

String textTable = 'text_table';
String colId = 'id';
String colTextTitle = 'title';
String colTextDescription = 'description';
String colTextDate = 'date';
String colTextTime = 'time';
String colTextRepeat = 'repeat';
String colItemType = 'type';
String colFileName = 'filename';
String colAddress = 'address';
String colImgArray = 'imagearray';


String imgTable="img_table";
String colImgId='imgid';
String colImgFilename='filename';



class DatabaseHelper{

  static DatabaseHelper _databaseHelper;
  static Database _database;



  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if(_databaseHelper == null)
      _databaseHelper=DatabaseHelper._createInstance();
    return _databaseHelper;
  }

  //getter method of databse
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabse();
    }
    return _database;
  }

  Future<Database> initializeDatabse() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'text.db';

    //open/create the database sat given path
    var textDatabse = await openDatabase(path, version: 6, onCreate: _createdb);
    return textDatabse;
  }

}

   void _createdb(Database db,int version) async  {

   await db.execute('CREATE TABLE $textTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTextTitle TEXT, '
       '$colTextDescription TEXT, $colItemType TEXT, $colTextDate TEXT, $colTextTime TEXT, '
       '$colTextRepeat TEXT, $colFileName TEXT, $colAddress TEXT, $colImgArray TEXT)');


   await db.execute('CREATE TABLE $imgTable($colImgId INTEGER PRIMARY KEY AUTOINCREMENT, $colImgFilename TEXT)');
}
