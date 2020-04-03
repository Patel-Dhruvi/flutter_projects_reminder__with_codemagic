import 'package:reminder_things/Model/TextModel.dart';

import 'TextModelDatabaseDao.dart';

  class DataRepository{

  final TextDatabseDao databaseDao= TextDatabseDao();

  Future getAllData({String query}) {
    return databaseDao.getTextList();
  }

  Future insertData(TextModel textModel) {
    return databaseDao.insertTask(textModel);
  }

  Future updateData(TextModel textModel) {
    return databaseDao.updateTask(textModel);
  }

  Future deleteDataById(int id) {
    return databaseDao.deleteTask(id);
  }


  Future deleteAllData() {
    return databaseDao.deleteAllTask();
  }


  Future isTitleAvailable(String value) async {
    List<TextModel> list = await getAllData();
    for(int i=0;i<list.length;i++)
    {
      TextModel textModel=list[i];
      if(textModel.type.contains(value)){
        return true;
      }
    }
    return false;
  }


  }