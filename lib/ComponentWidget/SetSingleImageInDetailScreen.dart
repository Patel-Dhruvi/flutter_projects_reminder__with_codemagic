
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder_things/Utils/GetImageFromDirectory.dart';

import '../Constants.dart';

class SetSingleImage extends StatelessWidget {


  SetSingleImage({@required this.fileName, @required this.itemType,}) ;


  final fileName;
  final itemType;
  final GetImageFromDirectory _getImageFromDirectory=GetImageFromDirectory();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getImageFromDirectory
            .getMultipleImageFromDirectory(
            fileName, itemType),
        builder: (BuildContext context,
            AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            if (snapshot.data != null) {
              if (itemType.contains(kPictureType)) {
                return Container(
                    width: 90.0,
                    height: 90.0,
                    margin: const EdgeInsets.only(
                        top: 15, left: 30),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: FileImage(
                                snapshot.data))));
              } else {
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      width: 90.0,
                      height: 90.0,
                      margin: const EdgeInsets.only(
                          top: 15, left: 30),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: FileImage(
                                  snapshot.data))),
                      child: Icon(
                          Icons.play_circle_filled,
                          color: Colors.white
                              .withOpacity(0.6)),
                    )
                  ],
                );
              }
            } else {
              return CircularProgressIndicator();
            }
          }
          else{
            return Container(height: 0,width: 0,);
          }

        }
        );
  }
}