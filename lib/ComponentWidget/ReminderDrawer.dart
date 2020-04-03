import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder_things/Utils/PreferencesHelper.dart';

import '../Constants.dart';

Widget getDrawer(BuildContext context) {
  return Drawer(
      child: Container(
          color: kAppThemeUpperDarkColor,
          child: ListView(
            padding: const EdgeInsets.all(0.0),
            children: <Widget>[
              FutureBuilder(
          future: PreferencesHelper.getBoolValue(PreferencesHelper.PREF_IS_FILE_IMAGE),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.data==true){
              return FutureBuilder(
                    future: PreferencesHelper.getStringValue(PreferencesHelper.PREF_SELECTED_IMAGE),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      return DrawerHeader(
                        margin: const EdgeInsets.all(0.0),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:FileImage(File(snapshot.data)),
                                fit: BoxFit.cover)),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: FutureBuilder(
                            future: PreferencesHelper.getDoubleValue(PreferencesHelper.PREF_SELECTED_TEXT_SIZE),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              return Text(getTodayDate(context),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    fontFamily:"Roboto" ,
                                    fontSize: snapshot.data!=0?snapshot.data:30),
                              );
                            }
                            ,
                          ),
                        ),
                      );
                    }

                );
              }
              else{
                return FutureBuilder(
                    future: PreferencesHelper.getStringValue(PreferencesHelper.PREF_SELECTED_IMAGE),
                    builder: (BuildContext context, AsyncSnapshot snapshot1){
                      return DrawerHeader(
                        margin: const EdgeInsets.all(0.0),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: snapshot1.data!=null?AssetImage(snapshot1.data):AssetImage("images/drawerbg.png"),
                                fit: BoxFit.cover)),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: FutureBuilder(
                            future: PreferencesHelper.getDoubleValue(PreferencesHelper.PREF_SELECTED_TEXT_SIZE),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              return Text(getTodayDate(context),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    fontFamily:"Roboto" ,
                                    fontSize: snapshot.data!=0?snapshot.data:30),
                              );
                            }
                            ,
                          ),
                        ),
                      );
                    }

                );
              }}
          ),
              Column(
                children: <Widget>[
                  DrawerCardWidget(
                    child: Column(
                      children: <Widget>[
                        DrawerCardWidget(
                          child: Container(
                            height: 80,
                            child: Center(
                              child: Text(
                                "No tasks to show",
                                style: kDrawerTextStyle,
                              ),
                            ),
                          ),),
                        SizedBox(
                          height: 20,
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.popAndPushNamed(context, '/settings');
                          },
                          leading: Icon(Icons.settings),
                          title: Text("Settings"),
                        ), ListTile(
                          onTap:(){
                            Navigator.popAndPushNamed(context, '/about');
                          },
                          leading: Icon(Icons.info),
                          title: Text("About"),
                        ),
                        ListTile(
                          onTap:(){
                            Navigator.popAndPushNamed(context, '/help');
                          },
                          leading: Icon(Icons.help),
                          title: Text("Help"),
                        ),
                        ListTile(
                          leading: Icon(Icons.feedback),
                          title: Text("Feedback"),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: Icon(Icons.cancel),
                    title: Text("Remove Ads"),
                  ), ListTile(
                    leading: Icon(Icons.share),
                    title: Text("Share the app"),
                  ),
                ],
              ),
            ],
          )
      ));
}


getTodayDate(BuildContext context)  {
   var date=DateTime.now();
  var dateFormat = "${DateFormat.E().format(date)}, ${DateFormat.d().format(date)} ${DateFormat.MMM().format(date)}";
  return dateFormat;
}

class DrawerCardWidget extends StatelessWidget {

  DrawerCardWidget({this.child});

  final Widget child;


  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.only(left:0,top:0,right:0,bottom:0),
        color: kAppThemeUpperDarkColor,
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
        child: child);
  }
}