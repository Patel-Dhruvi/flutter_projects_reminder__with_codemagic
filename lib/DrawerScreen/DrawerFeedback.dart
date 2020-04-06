import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constants.dart';


class DrawerFeedback extends StatefulWidget {
  @override
  _DrawerFeedbackState createState() => _DrawerFeedbackState();
}

class _DrawerFeedbackState extends State<DrawerFeedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Feedback",
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
      body:feedbackScreen(context) ,
    );
  }

 Widget feedbackScreen(BuildContext context) {
    return SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
//          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text("Hello!"),
            Text(kFeedbackText,textAlign: TextAlign.center,),
            SizedBox(
              height: 10,
            ),
            Image.asset("images/feedback.png",alignment: Alignment.center,)
          ],

        )
    );
 }
}

