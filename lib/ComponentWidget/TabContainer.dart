import 'package:flutter/material.dart';

import '../Constants.dart';


class TabContainer extends StatelessWidget {

  TabContainer({@required this.color,@required this.tabname});

  final Color color;
  final String tabname;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color:color,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        child: Center(
            child: Text(
              tabname,
              style: kTabTextStyle,
            )));
  }
}
