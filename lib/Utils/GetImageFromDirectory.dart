import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:reminder_things/Model/HeaderImageModel.dart';
import 'package:reminder_things/Model/TextModel.dart';
import 'package:reminder_things/Utils/GetItemTextModel.dart';
import 'package:thumbnails/thumbnails.dart';

import '../Constants.dart';

class GetImageFromDirectory {
  GetItemTextModel getItemTextModel = GetItemTextModel();

  Future<File> getImageFromDirectory(TextModel textModel) async {
    var path = textModel.filename;
    final documentDirectory = await getExternalStorageDirectory();
    var firstPath = File(documentDirectory.path + '/Pictures' + '/$path');
    if (textModel.type.contains(kPictureType)) {
      return firstPath;
    } else if (textModel.type.contains(kVideoType)) {
      var thumnail = await _getThumbnail(firstPath);
      return thumnail;
    } else {
      return null;
    }
  }

  Future<File> getHeaderImageFromDirectory(String path) async {
    final documentDirectory = await getExternalStorageDirectory();
    var firstPath = File(documentDirectory.path + '/Pictures' + '/$path');
    return firstPath;

  }


  Future<File> _getThumbnail(File firstPath) async {
    final documentDirectory = await getExternalStorageDirectory();
    var thumbnailpath = File(documentDirectory.path + '/Pictures');
    String thumb = await Thumbnails.getThumbnail(
        thumbnailFolder: thumbnailpath.path,
        videoFile: firstPath.path,
        imageType: ThumbFormat.PNG,
        //this image will store in created folderpath
        quality: 30);
    var thumbnailFile = File(thumb);
    return thumbnailFile;
  }

  Future<File> getvideoFile(TextModel textModel) async {
    var path = textModel.filename;
    final documentDirectory = await getExternalStorageDirectory();
    var firstPath = File(documentDirectory.path + '/Pictures' + '/$path');
    return firstPath;
  }

  Future<File> getMultipleImageFromDirectory(
      String multipleImage, itemType) async {
    var path = multipleImage;
    final documentDirectory = await getExternalStorageDirectory();
    var firstPath = File(documentDirectory.path + '/Pictures' + '/$path');
    if (itemType.contains(kPictureType)) {
      return firstPath;
    } else if (itemType.contains(kVideoType)) {
      var thumnail = await _getThumbnail(firstPath);
      return thumnail;
    } else {
      return null;
    }
  }

  deleteFileFromDirectory(int itemid) async {
    var firstPath;
    TextModel textModel = await getItemTextModel.getTextModel(itemid);
    final documentDirectory = await getExternalStorageDirectory();
    var imageString = textModel.imagesarray;
    var path = textModel.filename;
    firstPath = File(documentDirectory.path + '/Pictures' + '/$path');

    if (textModel.type.contains(kPictureType)) {
      if (imageString != null) {
        var imageArray = jsonDecode(imageString);
        for (int i = 0; i < imageArray.length; i++) {
          firstPath =
              File(documentDirectory.path + '/Pictures' + '/${imageArray[i]}');
          if (await firstPath.exists()) {
            deleteFile(firstPath);
          }
        }
      } else {
        if (await firstPath.exists()) {
          deleteFile(firstPath);
        }
      }
    } else if (textModel.type.contains(kVideoType)) {
      if (await firstPath.exists()) {
        var thumnail = await _getThumbnail(firstPath);
        deleteFile(firstPath);
        deleteFile(thumnail);
      }
    } else if (textModel.type.contains(kAudioType)) {
      var title = textModel.title;
      var audiopath = File(documentDirectory.path + '/audio' + '/$title.aac');
      if (await audiopath.exists()) {
        deleteFile(audiopath);
      }
    }
  }

  void deleteFile(File firstPath) {
    print("in delete");
    firstPath.delete(recursive: true);
    print("image file deleted: $firstPath");
  }
}
