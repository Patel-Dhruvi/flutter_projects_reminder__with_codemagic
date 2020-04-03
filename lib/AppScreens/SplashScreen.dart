import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reminder_things/AppScreens/Home.dart';
import 'package:reminder_things/Constants.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds:3),()=> Navigator.pushReplacementNamed(context, '/home',arguments: Home(preSelectedTab:0,)));

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kAppThemeLightColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(100.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              textBaseline: TextBaseline.ideographic,
              children: <Widget>[
                Image.asset('images/blub.png',fit: BoxFit.cover,),
                Stack(
                  children: <Widget>[
                    Image.asset(
                      'images/brain.png',
                    ),
                    Positioned(
                        left: 80,
                        top: 60,
                        bottom: 70,
                        right: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 0,
                              child: Image.asset(
                                'images/RectangleLine.png',
                                fit: BoxFit.cover,),
                            ),
                            Expanded(
                                child: Image.asset('images/Letterh.png',
                                    fit: BoxFit.cover)),
                          ],
                        )),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
