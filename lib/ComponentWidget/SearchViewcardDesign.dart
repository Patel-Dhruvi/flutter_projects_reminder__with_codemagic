

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder_things/Model/TextModel.dart';
import 'package:reminder_things/Utils/GetImageFromDirectory.dart';

import '../Constants.dart';
import 'ImagePreviewMyThingsTabList.dart';
import 'TabRemindMeWidget.dart';

Widget listViewSearchCardDesign(TextModel textModel) {
  GetImageFromDirectory getImageFromDirectory = GetImageFromDirectory();
  return FutureBuilder(
      future: getImageFromDirectory.getImageFromDirectory(textModel),
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
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
                        child: ImagePreview(
                            textModel, snapshot, 170.0, 100.0)),
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
                          Text(textModel.description,
                            style: kListCategoryDateStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,)
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
                    ListTextWidget(title: textModel.date),
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
        );

      });
}

Widget displayInCenter() {
  return Center(
      child: Text(
        "No Data is found in Your Remind Me list",
        style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: "Roboto"),
      ));
}