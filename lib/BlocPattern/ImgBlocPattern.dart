import 'dart:async';

import 'package:reminder_things/Database/ImageRepository.dart';
import 'package:reminder_things/Model/HeaderImageModel.dart';

class ImageBlocPattern {

  final ImageRepository _imgRepository = ImageRepository();

  final _imgController= StreamController<List<HeaderImageModel>>.broadcast();

  get imgData => _imgController.stream;


  ImageBlocPattern() {
    getAllData();
  }

  getAllData() async {
    _imgController.sink.add(await _imgRepository.getImgAllData());
  }


  insertData(HeaderImageModel headerImageModel) async {
    await _imgRepository.insertImgData(headerImageModel);
    getAllData();
  }

  updateData(HeaderImageModel headerImageModel) async {
    await _imgRepository.updateImgData(headerImageModel);
    getAllData();
  }

  deleteTaskById(int id) async {
    await _imgRepository.deleteImgDataById(id);
    getAllData();
  }

  dispose() {
    _imgController.close();

  }
}
