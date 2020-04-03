import 'package:reminder_things/Database/DatabaseHelper.dart';
import 'package:reminder_things/Model/HeaderImageModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class ImageDatabseDao {
  final dbhelper = DatabaseHelper();

  Future<List<Map<String, dynamic>>> getImgMapList() async {
    Database db = await dbhelper.database;
    var result = await db.query(imgTable);
    return result;
  }

  Future<List<HeaderImageModel>> getImgList() async {
    var imgMapList = await getImgMapList(); // Get 'Map List' from database
    int count = imgMapList.length; // Count the number of map entries in db table

    List<HeaderImageModel> imgList = List<HeaderImageModel>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      imgList.add(HeaderImageModel.fromMapObject(imgMapList[i]));
    }

    return imgList;
  }

  Future<int> insertTask(HeaderImageModel headerImageModel) async {
    Database db = await dbhelper.database;
    var result = await db.insert(imgTable, headerImageModel.toMap());
    return result;
  }

  Future<int> updateTask(HeaderImageModel headerImageModel) async {
    Database db = await dbhelper.database;
    var result = db.update(imgTable, headerImageModel.toMap(),
        where: '$colImgId = ?', whereArgs: [headerImageModel.imgId]);
    return result;
  }

  Future<int> deleteTask(int id) async {
    var db = await dbhelper.database;
    var result = db.rawDelete('DELETE FROM $imgTable WHERE $colImgId =$id');
    return result;
  }

  Future deleteAllTask()async {
    Database db = await dbhelper.database;
    var result = await db.delete(imgTable);
    return result;
  }

  Future<int> getCount() async {
    Database db = await dbhelper.database;
    List<Map<String, dynamic>> allImg =
    await db.rawQuery('SELECT COUNT (*) FROM $imgTable ');
    var result = Sqflite.firstIntValue(allImg);
    return result;
  }
}
