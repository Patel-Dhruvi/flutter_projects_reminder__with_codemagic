import 'dart:async';

import 'package:reminder_things/Database/DataRepository.dart';
import 'package:reminder_things/Model/TextModel.dart';

class BlocPattern {

  final DataRepository _dataRepository = DataRepository();
  final _dataController=StreamController<List<TextModel>>.broadcast();
  get data => _dataController.stream;


  BlocPattern() {
    getAllData();
  }

  getAllData() async {
    _dataController.sink.add(await _dataRepository.getAllData());
  }


  insertData(TextModel textModel) async {
    await _dataRepository.insertData(textModel);
    getAllData();
  }

  updateData(TextModel textModel) async {
    await _dataRepository.updateData(textModel);
    getAllData();
  }

  deleteTaskById(int id) async {
    await _dataRepository.deleteDataById(id);
    getAllData();
  }

  dispose() {
    _dataController.close();

  }
}
