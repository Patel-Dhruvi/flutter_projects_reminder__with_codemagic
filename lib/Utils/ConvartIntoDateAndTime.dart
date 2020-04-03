


import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ConvertIntoDateTime{


  String convertInto24Hours(String time){

    var timeArray = time.split(":");
    var hour;
    var minuteArray=timeArray[1].split(" ");
    var minute=minuteArray[0];

    if(timeArray[1].contains("PM")){
       hour=int.parse(timeArray[0])+12;
       return "$hour:$minute";
    }
    else{
       hour=timeArray[0];
       return "$hour:$minute";
    }
  }

  Day getDayOfWeek(int num){

    switch(num){
      case 1:
        return Day.Monday;
        break;
      case 2:
        return Day.Tuesday;
        break;
      case 3:
        return Day.Wednesday;
        break;
      case 4:
        return Day.Thursday;
        break;
      case 5:
        return Day.Friday;
        break;
      case 6:
        return Day.Saturday;
        break;
      case 7:
        return Day.Sunday;
        break;
      default:
        return null;

    }
  }
}
