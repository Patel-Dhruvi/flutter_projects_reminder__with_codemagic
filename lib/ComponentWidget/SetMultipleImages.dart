import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:reminder_things/Utils/GetImageFromDirectory.dart';

class SetMultipleImages extends StatelessWidget {
  SetMultipleImages({
    @required this.isItemSelected,
    @required this.isEditTapped,
    @required this.jsonString,
    @required this.images,
    @required this.multipleImageArray,
    @required this.itemtype,
  });

  final bool isItemSelected;
  final bool isEditTapped;
  final String jsonString;
  final List<Asset> images;
  final List<String> multipleImageArray;
  final String itemtype;
  final GetImageFromDirectory _getImageFromDirectory=GetImageFromDirectory();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top:15),
        child: isItemSelected
            ? (isEditTapped && jsonString != null)
                ? AssetImageDesign(images: images)
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: multipleImageArray.length,
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                          future: _getImageFromDirectory.getMultipleImageFromDirectory(
                              multipleImageArray[index],itemtype),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data != null) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage: FileImage(snapshot.data)),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          });
                    },
                  )
                : AssetImageDesign(images: images));
  }
}

class AssetImageDesign extends StatelessWidget {
  AssetImageDesign({
    @required this.images,
  });

  final List<Asset> images;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
        itemBuilder: (context, index) {
          Asset asset = images[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                child: AssetThumb(
                  asset: asset,
                  width: 300,
                  height: 300,
                )
//                                  Image.asset(file.path,height: 70,width: 70,fit: BoxFit.fill,)
                ),
          );
        });
  }
}
