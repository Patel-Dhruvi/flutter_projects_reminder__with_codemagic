import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder_things/AppScreens/AddDetailsScreen.dart';
import 'package:reminder_things/Model/TextModel.dart';
import 'package:reminder_things/Utils/GetImageFromDirectory.dart';
import 'package:reminder_things/Utils/ShowWeekdayName.dart';
import '../Constants.dart';
import 'ImagePreviewMyThingsTabList.dart';

Widget tabMyThingsWidget(BuildContext context,
    AsyncSnapshot<List<TextModel>> snapshot, TextModel selected,
    bool isSearchViewopen, int tabSelected) {
  return Scaffold(
    resizeToAvoidBottomPadding: false,
    body: SafeArea(
        child: isSearchViewopen
            ? Container(
            height: 190,
            width: 140,
            child: listViewCardDesign(context, selected, tabSelected))
            : _displayMyThingsList(snapshot, context, tabSelected)


    ),
  );
}

Widget _displayMyThingsList(AsyncSnapshot<List<TextModel>> snapshot,
    BuildContext context, int tabSelected) {
  List<TextModel> textList = List<TextModel>();
  List<TextModel> audioList = List<TextModel>();
  List<TextModel> pictureList = List<TextModel>();
  List<TextModel> videoList = List<TextModel>();

  if (snapshot.hasData) {
    for (int i = 0; i < snapshot.data.length; i++) {
      TextModel textModel = snapshot.data[i];
      if (textModel.type != null) {
        if (textModel.type.contains(kTextType)) {
          textList.add(textModel);
        } else if (textModel.type.contains(kAudioType,)) {
          audioList.add(textModel);
        } else if (textModel.type.contains(kPictureType)) {
          pictureList.add(textModel);
        } else if (textModel.type.contains(kVideoType)) {
          videoList.add(textModel);
        }
      } else {
        int id = textModel.id;
        print("delete data is is :$id");
//        blocPattern.deleteTaskById(id);
      }
    }
    if(textList.length==0 && audioList.length==0 && pictureList.length==0 &&  videoList.length==0)
      {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.hourglass_empty,
                color: Color(0XFF908F8F),
                size: 100,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "No Tasks",
                style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal,
              fontFamily: "Roboto",
              fontSize: 18,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "No Relevant tasks found",
                style: kDScreenContainerTrailingTextStyle,
              ),
            ],
          ),
        );
      }
    else{
      return Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            _getItemTypeLable(textList, "My Text"),
            getAllThings(context, textList, tabSelected),
            _getItemTypeLable(pictureList, "My Photos"),
            getAllThings(context, pictureList, tabSelected),
            _getItemTypeLable(videoList, "My Videos"),
            getAllThings(context, videoList, tabSelected),
            _getItemTypeLable(audioList, "My Audios"),
            getAllThings(context, audioList, tabSelected),
          ],
        ),
      );
    }

  } else {
    return CircularProgressIndicator();
  }
}

Widget _getItemTypeLable(List<TextModel> typeList, String typeText) {
  return typeList.length == 0 ?
  Container(height: 0, width: 0,) :
  Text(typeText, style: kListViewLabelStyle);
}

Widget getAllThings(BuildContext context, List<TextModel> textList,
    int tabSelected) {
  if (textList.length != 0) {
    return Container(
      height: 190,
      width: 140,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: textList.length,
          itemBuilder: (context, itemPosition) {
            TextModel textmodel = textList[itemPosition];
            return listViewCardDesign(
                context,
                textmodel,
                tabSelected
            );
          }),
    );
  } else {
    return Container(height: 0,width: 0,);
//      Container(height: 0, width: 0,);
  }
}

Widget listViewCardDesign(context,
    TextModel textModel, int tabSelected,) {
  GetImageFromDirectory getImageFromDirectory = GetImageFromDirectory();
  return FutureBuilder(
      future: getImageFromDirectory.getImageFromDirectory(textModel),
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        return GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/details',
                  arguments: AddDetailsScreen(
                      isListDataTapped: true,
                      itemId: textModel.id,
                      selecteditemType: textModel.type,
                      tabSelected: tabSelected));
            },
            child: Card(
              elevation: 6.0,
              margin: const EdgeInsets.fromLTRB(10, 15, 10, 15),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: 130,
                height: 190,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: ImagePreview(textModel, snapshot, 130.0, 190.0),
                    ),
                    Expanded(
                        flex: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, top: 10),
                          child: Text(
                            textModel.title,
                            style: kListCategoryTextStyle,
                          ),
                        )),
                    Expanded(
                        flex: 0,
                        child: SizedBox(
                          height: 5,
                        )),
                    Expanded(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, bottom: 10),
                        child: FutureBuilder(
                          future:setDate(textModel.date),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                          return  Text(snapshot.data!=null?snapshot.data:textModel.date,
                          style: kListCategoryDateStyle,
                      );
                      },),
                      ),
                    )
                  ],
                ),
              ),
            ));
      });
}