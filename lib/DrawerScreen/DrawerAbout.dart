
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constants.dart';

class DrawerAbout extends StatefulWidget {
  @override
  _DrawerAboutState createState() => _DrawerAboutState();
}

class _DrawerAboutState extends State<DrawerAbout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About",
          style: TextStyle(color: kRemindColor),
        ),
        elevation: 6.0,
        backgroundColor: kAppThemeLightColor,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: kRemindColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body:aboutScreen(context) ,
    );
  }
}

Widget aboutScreen(BuildContext context) {
  return SafeArea(
    child: Container(
//      padding: const EdgeInsets.fromLTRB(10,20,10,10),
        child: Column(
//      mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex:0,
              child: Padding(
                padding: const EdgeInsets.only(top:20.0),
                child: CircleAvatar(
                  radius: 60,
                 backgroundColor: kAppThemeUpperDarkColor,
                 child: Image.asset("images/reminderlogo.png",width: 50,height: 50,),),
              ),
            ),
            Expanded(
              flex: 0,
              child: SizedBox(
                height: 10,
              ),
            ),
            Expanded(
                flex:0,child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Version"),
                Text("1.0"),
              ],
            )),
            Expanded(
              flex: 0,
              child: SizedBox(
                height: 10,
              ),
            ),
            Expanded(
              flex:0,
              child: Divider(
                height: 2,
                color: kRemindColor,
              ),
            ),

            Expanded(
              flex:3,
              child: Padding(
                padding: const EdgeInsets.only(left:10.0,right:10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text("About Us",style:TextStyle(
                        color: kRemindColor,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        fontFamily:"Roboto" ,
                        fontSize: 20
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(child: Text(kAppDescription,style: kAboutText,textAlign: TextAlign.justify,))
                  ],
                ),
              ),
            ),
            Expanded(
                flex:0,child: Padding(
                  padding: const EdgeInsets.only(bottom:20.0),
                  child: Text("@ 2020"),
                ))

          ],
        ),
      ),

  );
}
