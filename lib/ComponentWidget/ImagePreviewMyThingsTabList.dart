import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder_things/Model/TextModel.dart';

import '../Constants.dart';

class ImagePreview extends StatelessWidget {

   ImagePreview(this.textModel, this.snapshot, this.width,this.height);

  final AsyncSnapshot<File> snapshot;
  final TextModel textModel;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return _imagePreview(snapshot, textModel,width,height);
  }
}

Widget _imagePreview(AsyncSnapshot<File> snapshot, TextModel textModel, double width, double height) {
  if (snapshot.hasData) {
    if (snapshot.data != null) {
      if (textModel.type.contains(kVideoType)) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(
                snapshot.data,
                fit: BoxFit.fill,
                width: width,
                height: height,
              ),
            ),
            Icon(
              Icons.play_circle_filled,
              color: Colors.white.withOpacity(0.6),
              size: 50,
            )
          ],
        );
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.file(
            snapshot.data,
            fit: BoxFit.fill,
            width: width,
            height: height,
          ),
        );
      }
    } else {
      return Container(
        height: 0,
        width: 0,
        child: Text("can't load image"),
      );
    }
  } else {
    if (textModel.type.contains(kTextType)) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Material(
              color: kAppThemeUpperDarkColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.filter, size: 70, color: kRemindColor),
              )));
    } else if (textModel.type.contains(kAudioType)) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Material(
              color: Colors.black,
              child: Image.asset(
                "images/audiobg.png",
                fit: BoxFit.fill,
                width: width,
                height: height,
              ),
            ),
          ),
          Image.asset("images/audioicon.png"),
        ],
      );
    } else {
      return Container(
        height: 0,
        width: 0,
      );
    }
  }
}
