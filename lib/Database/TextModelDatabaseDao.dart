import 'package:reminder_things/Database/DatabaseHelper.dart';
import 'package:reminder_things/Model/TextModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class TextDatabseDao {
  final dbhelper = DatabaseHelper();

  Future<List<Map<String, dynamic>>> getTextMapList() async {
    Database db = await dbhelper.database;
    var result = await db.query(textTable, orderBy: '$colTextDate ASC');
    return result;
  }

  Future<List<TextModel>> getTextList() async {
    var textMapList = await getTextMapList(); // Get 'Map List' from database
    int count =
        textMapList.length; // Count the number of map entries in db table

    List<TextModel> textList = List<TextModel>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      textList.add(TextModel.fromMapObject(textMapList[i]));
    }

    return textList;
  }

  Future<int> insertTask(TextModel textkModel) async {
    Database db = await dbhelper.database;
    var result = await db.insert(textTable, textkModel.toMap());
    return result;
  }

  Future<int> updateTask(TextModel textModel) async {
    Database db = await dbhelper.database;
    var result = db.update(textTable, textModel.toMap(),
        where: '$colId = ?', whereArgs: [textModel.id]);
    return result;
  }

  Future<int> deleteTask(int id) async {
    var db = await dbhelper.database;
    var result = db.rawDelete('DELETE FROM $textTable WHERE $colId =$id');
    return result;
  }

  Future deleteAllTask()async {
    Database db = await dbhelper.database;
    var result = await db.delete(textTable);
    return result;
  }

  Future<int> getCount() async {
    Database db = await dbhelper.database;
    List<Map<String, dynamic>> allTask =
    await db.rawQuery('SELECT COUNT (*) FROM $textTable ');
    var result = Sqflite.firstIntValue(allTask);
    return result;
  }
}
