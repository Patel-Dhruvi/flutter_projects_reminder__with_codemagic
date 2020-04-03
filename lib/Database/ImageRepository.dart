import 'package:reminder_things/Database/HeagerImgDatabaseDao.dart';
import 'package:reminder_things/Model/HeaderImageModel.dart';

class ImageRepository{

  ImageDatabseDao imageDatabaseDao=ImageDatabseDao();

  Future getImgAllData({String query}) {
    return imageDatabaseDao.getImgList();
  }

  Future insertImgData(HeaderImageModel headerImageModel) {
    return imageDatabaseDao.insertTask(headerImageModel);
  }

  Future updateImgData(HeaderImageModel headerImageModel) {
    return imageDatabaseDao.updateTask(headerImageModel);
  }

  Future deleteImgDataById(int id) {
    return imageDatabaseDao.deleteTask(id);
  }


  Future deleteAllImgData() {
    return imageDatabaseDao.deleteAllTask();
  }

}