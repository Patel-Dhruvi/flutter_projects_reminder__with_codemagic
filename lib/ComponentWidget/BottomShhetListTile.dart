import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder_things/Constants.dart';

class BottomSheetListTile extends StatelessWidget {

  const BottomSheetListTile({this.leading,this.onTap,this.title});

  final IconData leading;
  final String title;
  final Function onTap;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leading,color:Color(0XFF918F8F),size: 30,),
      onTap: onTap,
      title: Text(title,style: kBottomSheetTitleTextStyle,),
    );
  }
}