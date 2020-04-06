import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../Constants.dart';

class DrawerHelp extends StatefulWidget {
  @override
  _DrawerHelpState createState() => _DrawerHelpState();
}

class _DrawerHelpState extends State<DrawerHelp> {
  TextEditingController helpTextController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Help",
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
        body: helpScreen(context),
      ),
    );
  }

  Widget helpScreen(BuildContext context) {

    Future<void> send() async {
      final Email email = Email(
        body: "Hello",
        subject: "Reminder Point",
        recipients: ["dhruvi@olbuz.com"],
        isHTML: false,
      );

      String platformResponse;

      try {
        await FlutterEmailSender.send(email);
        platformResponse = 'success';
      } catch (error) {
        platformResponse = error.toString();
      }

      if (!mounted) return;

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(platformResponse),
      ));
    }
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 0,
            child: helpCardDesign(
              question: kHelpQue1,
              answer: kHelpAns1,
            ),
          ),
          Expanded(
            flex: 0,
            child: helpCardDesign(
              question: kHelpQue2,
              answer: kHelpAns2,
            ),
          ),
          Expanded(
            flex: 0,
            child: helpCardDesign(
              question: kHelpQue3,
              answer: kHelpAns3,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    flex: 0,
                    child: TextField(
                      onSubmitted: (value) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      autofocus: false,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "Write your Question here",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: kRemindColor, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                      controller: helpTextController,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    flex: 0,
                    child: RaisedButton(
                      color: kRemindColor,
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        send();
//                        Navigator.push(context, MaterialPageRoute(builder: (context) => MailOpen()));
                      },
                      child: Text("Send"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class helpCardDesign extends StatelessWidget {
  helpCardDesign({this.question, this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: kSettingsUpperText,
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              answer,
              textAlign: TextAlign.justify,
              style: kSettingsSmallText,
            ),
          )
        ],
      ),
    );
  }
}
