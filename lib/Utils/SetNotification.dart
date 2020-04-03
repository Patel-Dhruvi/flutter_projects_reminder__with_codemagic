import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../Constants.dart';
import 'ConvartIntoDateAndTime.dart';
import 'LocalNotificationHelper.dart';

ConvertIntoDateTime convertIntoDateTime=ConvertIntoDateTime();
var dayDate;
var monthDate;
var yearDate;
var hourTime;
var minuteTime;

void setNotification(String title, String description, String date, String time, String currentSelectedRepeatValue, FlutterLocalNotificationsPlugin notifications, ) async {
  DateTime datewithtime;
  var timeIn24houres = convertIntoDateTime.convertInto24Hours(time);
  var timeArray = timeIn24houres.split(":");
  hourTime = int.parse(timeArray[0]);
  minuteTime = int.parse(timeArray[1]);
  var dateArray = date.split("/");
  dayDate = int.parse(dateArray[0]);
  monthDate = int.parse(dateArray[1]);
  yearDate = int.parse(dateArray[2]);
  datewithtime = DateTime(yearDate, monthDate, dayDate, hourTime, minuteTime);
  print("$datewithtime date with time");

  if (currentSelectedRepeatValue.contains(kRemindOnceType)) {

    print("In Once");
    await setOnceNotification(
      notifications,
      title: title,
      body: description,
      date: datewithtime
  );
}
  else if(currentSelectedRepeatValue.contains(kRemindEverydayType)){

    print("In everyday");
    var time=Time(hourTime,minuteTime);
    await setEverydayNotification(notifications, title: title, body: description, time: time);

  }
  else if(currentSelectedRepeatValue.contains(kRemindWeeklyType)){

    print("In weekly");
    Day day=convertIntoDateTime.getDayOfWeek(datewithtime.weekday);
    var time=Time(hourTime,minuteTime);
    await setWeeklyNotification(notifications, title: title, body: description, day: day,time: time);

  }
  else if(currentSelectedRepeatValue.contains(kRemindMonthlyType)){

    print("In Monthly");
    if(monthDate==12)
    {
      monthDate=1;
      yearDate=yearDate+1;
    }
    else{
      monthDate=monthDate+1;
      print("$monthDate after monnthly");
    }
    var dateForMonthly = DateTime(yearDate,monthDate,dayDate,hourTime,minuteTime);
    print("$dateForMonthly after monthly");
    await setOnceNotification(
        notifications,
        title: title,
        body: description,
        date: dateForMonthly
    );
  }
}
