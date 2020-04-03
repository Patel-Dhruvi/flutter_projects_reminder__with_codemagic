
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:reminder_things/Model/TextModel.dart';
import 'package:reminder_things/Utils/GetItemTextModel.dart';

import '../Constants.dart';

class GetLocationAddress{

  GetItemTextModel getItemTextModel=GetItemTextModel();

  getItemAddress(int itemId, AsyncSnapshot<List<TextModel>> snapshot) {
    TextModel textModel = getItemTextModel.getItemTextModel(snapshot, itemId);
    if(textModel.address!=null){
      return Visibility(
        visible: textModel.address == null ? false : true,
        child: FutureBuilder(
          future: _getAddressFromLatLng(textModel.address),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.all(0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 0,
                          child: GestureDetector(
                              onTap: () {
                                _openMapActivity(textModel.address);
                              },
                              child: Icon(
                                Icons.location_on,
                                color: kRemindColor,
                              ))),
                      SizedBox(
                        width: 3,
                      ),
                      Expanded(
                          flex: 1,
                          child: Text(
                            snapshot.data,
                            style: kCardViewItemTextStyle,
                          ))
                    ],
                  ));
            } else {
              return Text("Location is not added");
            }
          },
        ),
      );
    }
    else {
      return Container(height: 0, width: 0,);
    }

  }

  _getAddressFromLatLng(String address) async {
    List<String> latlngArray = address.split(":");
    double latitude = double.tryParse(latlngArray[0]);
    var longitude = double.tryParse(latlngArray[1]);
    final coordinates = new Coordinates(latitude, longitude);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
//    print("${first.featureName} : ${first.addressLine}");
    return first.featureName;
  }

  void _openMapActivity(String address) async {
    List<String> latlngArray = address.split(":");
    double latitude = double.tryParse(latlngArray[0]);
    var longitude = double.tryParse(latlngArray[1]);
    if (await MapLauncher.isMapAvailable(MapType.google)) {
      await MapLauncher.launchMap(
          mapType: MapType.google,
          coords: Coords(latitude, longitude),
          title: "Shanghai Tower",
          description: "Asia's tallest building");
    }
  }
}