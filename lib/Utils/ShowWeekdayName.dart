

import 'package:intl/intl.dart';

import 'PreferencesHelper.dart';

showWeekDayName(String date){

  var dateArray = date.split("/");
  var dayDate = int.parse(dateArray[0]);
  var monthDate = int.parse(dateArray[1]);
  var yearDate = int.parse(dateArray[2]);
  var datewithtime = DateTime(yearDate, monthDate, dayDate, 00, 00);
  print(datewithtime);
  print(DateFormat.E().format(datewithtime));
  return "${DateFormat.E().format(datewithtime)} $date";

}

Future<String> setDate(String dateformat) async {
  if(await PreferencesHelper.getBoolValue(PreferencesHelper.PREF_SHOW_WEEKDAY_NAME))
  {
    return showWeekDayName(dateformat);
  }
  else{
    return dateformat;
  }

}