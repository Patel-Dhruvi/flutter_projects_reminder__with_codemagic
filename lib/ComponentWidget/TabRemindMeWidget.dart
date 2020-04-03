import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder_things/AppScreens/AddDetailsScreen.dart';
import 'package:reminder_things/Model/TextModel.dart';
import 'package:reminder_things/Utils/GetImageFromDirectory.dart';
import 'package:reminder_things/Utils/ShowWeekdayName.dart';

import '../Constants.dart';
import 'ImagePreviewMyThingsTabList.dart';

Widget tabRemindMeWidget(
    BuildContext context,
    AsyncSnapshot<List<TextModel>> snapshot,
    String date,
    TextModel selected,
    bool isSearchViewOpen,
    int tabSelected) {
  return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
    body: SafeArea(
          child: Column(
        children: <Widget>[
          Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.today, color: Color(0XFF908F8F)),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Today", style: kListViewLabelStyle)
                ],
              ),
            ),
          ),
          Expanded(
            flex:3,
              child: isSearchViewOpen
                  ? selected != null
                      ? ListView(
                          children: <Widget>[
                            listViewRemindeMeCardDesign(selected, tabSelected)
                          ],
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        )
                  : _displayList(snapshot, date, tabSelected)),
        ],
      )),
  );

}

Widget _displayList(
    AsyncSnapshot<List<TextModel>> snapshot, date, int tabSelected) {
  List<TextModel> todayList = List<TextModel>();
  if (snapshot.hasData) {
    if (snapshot.data != null) {
      for (int i = 0; i < snapshot.data.length; i++) {
        TextModel textModel = snapshot.data[i];
        if (textModel.date.contains(date)) {
          todayList.add(textModel);
        }
      }
      if (todayList.length != 0) {
        return listViewBuilder(todayList, tabSelected);
      } else {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
    } else {
      return Text("Data Not Found");
    }
  } else {
    return Container(
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

Widget listViewBuilder(List<TextModel> todayList, int tabSelected) {
  return ListView.builder(
      itemCount: todayList.length,
      itemBuilder: (context, position) {
        return listViewRemindeMeCardDesign(todayList[position], tabSelected);
      });
}

Widget listViewRemindeMeCardDesign(TextModel textModel, int tabSelected) {
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
                  tabSelected: tabSelected,
                ));
          },
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.fromLTRB(15, 15, 15, 10),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child:
                              ImagePreview(textModel, snapshot, 170.0, 100.0)),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Title",
                                  style: kListCategoryTextStyle,
                                ),
                                ListTextWidget(title: textModel.title),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Description",
                                  style: kListCategoryTextStyle,
                                ),
                                Text(
                                  textModel.description,
                                  style: kListCategoryDateStyle,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      ListViewIconWidget(
                        iconData: Icons.alarm,
                      ),
                      ListTextWidget(
                        title: textModel.time,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ListViewIconWidget(
                        iconData: Icons.date_range,
                      ),
                      FutureBuilder(
                        future:setDate(textModel.date),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          return  ListTextWidget(title: snapshot.data!=null?snapshot.data:textModel.date);
                        },),

                      SizedBox(
                        width: 10,
                      ),
                      ListViewIconWidget(
                        iconData: Icons.autorenew,
                      ),
                      ListTextWidget(
                        title: textModel.repeat,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      });
}

class ListViewIconWidget extends StatelessWidget {
  ListViewIconWidget({this.iconData});

  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      color: Color(0XFFDADADA),
    );
  }
}

class ListTextWidget extends StatelessWidget {
  const ListTextWidget({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: kListCategoryDateStyle,
    );
  }
}
