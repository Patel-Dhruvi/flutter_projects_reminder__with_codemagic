import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'PreferencesHelper.dart';


Future setOnceNotification(
    FlutterLocalNotificationsPlugin notifications, {
      @required String title,
      @required String body,
      @required DateTime date,
      int itemid,
      int id = 0,
    }) {
  return _showOnceNotification(notifications,
  title: title, body: body, date: date,id: id,type: _onNotification );
}

Future _showOnceNotification(
    FlutterLocalNotificationsPlugin notifications, {
      @required String title,
      @required String body,
      @required DateTime date,
      @required NotificationDetails type,
      int id = 0,
    }) =>
    notifications.schedule(id, title, body, date, type,
      androidAllowWhileIdle: true
    );


Future setEverydayNotification(
    FlutterLocalNotificationsPlugin notifications, {
      @required String title,
      @required String body,
      @required Time time,
      int itemid,
      int id = 0,
    }) {
  return _showEverydayNotification(notifications,
      title: title, body: body, time:time, id: id,type: _onNotification );
}

Future _showEverydayNotification(
    FlutterLocalNotificationsPlugin notifications, {
      @required String title,
      @required String body,
      @required Time time,
      @required NotificationDetails type,
      int id = 0,
    }) =>
    notifications.showDailyAtTime(id, title, body, time, type,);

Future setWeeklyNotification(
    FlutterLocalNotificationsPlugin notifications, {
      @required String title,
      @required String body,
      @required Day day,
      @required Time time,
      int itemid,
      int id = 0,
    }) {
  return _showWeeklyNotification(notifications,
      title: title, body: body,day:day, time: time,id: id,type: _onNotification );
}

Future _showWeeklyNotification(
    FlutterLocalNotificationsPlugin notifications, {
      @required String title,
      @required String body,
      @required Day day,
      @required Time time,
      @required NotificationDetails type,
      int id = 0,
    }) =>
    notifications.showWeeklyAtDayAndTime(id, title, body, day,time, type,);

NotificationDetails get _onNotification {
  var vibration;
  setVibration().then((value){
  vibration=value;
  print(vibration);
  });
  final androidChannelSpecifics = AndroidNotificationDetails(
    '3',
    'name3',
    'description3',
    importance: Importance.Max,
    priority: Priority.Max,
    enableVibration: vibration,

  );
  final iOSChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
}


setVibration() async{
  return await PreferencesHelper.getVibrateBoolValue(PreferencesHelper.PREF_IS_VIBRATE);
}