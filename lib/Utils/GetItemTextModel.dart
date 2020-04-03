
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder_things/Database/DataRepository.dart';
import 'package:reminder_things/Model/TextModel.dart';

import '../Constants.dart';

class GetItemTextModel{


  DataRepository dataRepository =DataRepository();

  getTextModel(int itemId) async {

    List<TextModel>  textmodelList =await dataRepository.getAllData();
    for (int i = 0; i <= textmodelList.length; i++) {
      TextModel textModel = textmodelList[i];
      if (textModel.id == itemId) {
        return textModel;
      }
    }
  }

  getItemTextModel(AsyncSnapshot<List<TextModel>> snapshot, int itemId) {
    for (int i = 0; i <= snapshot.data.length; i++) {
      TextModel textModel = snapshot.data[i];
      if (textModel.id == itemId) {
        return textModel;
      }
    }
  }


  getItemTitle(int itemId, AsyncSnapshot<List<TextModel>> snapshot) {
    TextModel textModel = getItemTextModel(snapshot, itemId);
    return Container(
        child: Text(
          textModel.title,
          style: kCardViewItemTextStyle,
        ));
  }

  getItemDate(int itemId, AsyncSnapshot<List<TextModel>> snapshot) {

    TextModel textModel = getItemTextModel(snapshot, itemId);
    return Container(
        child: Text(
          textModel.date,
          style: kCardViewItemTextStyle,
        ));
  }

  getItemDescription(int itemId, AsyncSnapshot<List<TextModel>> snapshot, BuildContext context,) {

    TextModel textModel = getItemTextModel(snapshot, itemId);
        if(textModel.description!=null){
          return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    textModel.description,
                    maxLines: 1,
                    overflow: textModel.description.length>25?TextOverflow.ellipsis:TextOverflow.visible,
                    softWrap: true,
                    style: kCardViewItemTextStyle,
                  ),
                  textModel.description.length > 25
                      ? InkWell(
                    onTap: () {
                      _showDescriptionDialog(context, textModel);
                    },
                    child: Text(
                      "Show more",
                      style: TextStyle(
                          color: kRemindColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                      : Container(
                    height: 0,
                    width: 0,
                  )
                ],
              ));
        }
        else{
          return Container(height: 0,width: 0,);
        }


  }

  _showDescriptionDialog(BuildContext context, TextModel textModel) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      title: Text("Your Description is :"),
      content: Text(textModel.description),
      actions: <Widget>[
        RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Ok"),
          color: kRemindColor,
        )
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

}
