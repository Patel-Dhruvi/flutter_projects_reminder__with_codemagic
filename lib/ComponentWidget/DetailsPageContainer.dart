import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constants.dart';

class DetailsPageContainer extends StatelessWidget {
  const DetailsPageContainer(
      {this.leading, this.title, this.trailing, this.onTap});

  final IconData leading;
  final String title;
  final Widget trailing;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: kAppThemeUpperDarkColor,
          borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(leading,color: Colors.black,),
        title: Text(title,style: kDetailsScreenContainerTextStyle,),
        trailing: trailing,
      ),
    );
  }
}