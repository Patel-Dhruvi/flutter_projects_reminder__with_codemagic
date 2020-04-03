import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



const kAppThemeLightColor=Color(0XFFfff8e5);
const kAppThemeUpperDarkColor=Color(0XFFffe7b9);
const kRemindColor=Color(0XFFfccc83);
const kUnSelectedLabelColor=Color(0XFFabaaaa);
const kSearchBarColor=Color(0XFFFFF1CE);
const kTextType="text";
const kAudioType="audio";
const kPictureType="picture";
const kVideoType="video";
const kLocationType="location";
const kRemindOnceType="Once";
const kRemindEverydayType="Everyday";
const kRemindWeeklyType="Weekly";
const kRemindMonthlyType="Monthly";

const kAppDescription="This Application is the simple reminder application for personal use.It also has widgets, simple calender, timer and more."
    " In this application you select date or time as you desire and set the reminder, We will remind you on that time. Your task will be delete if you select the task is done."
    "You also select the Video, Pictures, Voice Note and also Location of your place.";

const kTabTextStyle=TextStyle(
fontWeight: FontWeight.normal,
  fontFamily:"Roboto" ,
  fontSize: 20);

const kMainTextStyle=TextStyle(
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    fontFamily:"Roboto" ,
    color: Colors.black,
    letterSpacing: 2,
    fontSize: 24);


const kDrawerTextStyle=TextStyle(
    color: Color(0XFF918f8f),
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    fontFamily:"Roboto" ,
    fontSize: 18
);

const kListCategoryTextStyle=TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontFamily:"Roboto" ,
    fontSize: 14
);

const kListCategoryDateStyle=TextStyle(
    color: Color(0XFF908F8F),
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontFamily:"Roboto" ,
    fontSize: 14
);

const kListViewLabelStyle=TextStyle(
    color: Color(0XFF908F8F),
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    fontFamily:"Roboto" ,
    fontSize: 16
);

const kRecordAudioTextStyle=TextStyle(
    color: Color(0XFF908F8F),
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    fontFamily:"Roboto" ,
    fontSize: 20
);

const kCardViewItemTextStyle=TextStyle(
    color: Color(0XFF918F8F),
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontFamily:"Roboto" ,
    fontSize: 14
);

const kDetailsScreenContainerTextStyle=TextStyle(
    color:Colors.black,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    fontFamily:"Roboto" ,
    fontSize: 20
);

const kDScreenContainerTrailingTextStyle=TextStyle(
    color:Colors.black,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    fontFamily:"Roboto" ,
    fontSize: 16,


);

const kBottomSheetTitleTextStyle=TextStyle(
    color:Color(0XFF918F8F),
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontFamily:"Roboto" ,
    fontSize: 30
);

const kSettingsUpperText=TextStyle(
    color:Colors.black,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontFamily:"Roboto" ,
    fontSize: 18
);

const kSettingsSmallText=TextStyle(
    color:Color(0XFF918f8f),
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontFamily:"Roboto" ,
    fontSize: 15
);

const kAboutText=TextStyle(
    color:Colors.black,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    fontFamily:"Roboto" ,
    fontSize: 18
);

setDateFormat(int day){
    if(day<10)
        return "0$day";
    else
        return day;
}

setMonthFormat(int month){
    if(month<10)
        return "0$month";
    else
        return month;

}

setHourFormat(int hour, int hourOfPeriod){
    if(hour==12){
        return 12;
    }
    else{
        if(hour<10){
            return "0$hourOfPeriod";
        }
        else{
          return hourOfPeriod;
        }
    }
}


setMinuteFormat(int minute){
    if(minute<10){
        return "0$minute";
    }
    else{
        return minute;
    }
}

const kHelpQue1="How to I add the location with task ?";
const kHelpAns1="First you go to the add task screen and then tap to location icon and your location will be add automatically make sure your GPS is on.";

const kHelpQue2="What is the Performed by Postpone option ?";
const kHelpAns2="If you Select the Postpone option then you will be able to change your time only.";

const kHelpQue3="Did not find the answer to your question ?";
const kHelpAns3="In that case,the best option for you would be to contact us directly by under suggested option and explain "
    "your issue in as much detail as possible, you can also include the relevant screenshots and/or screen recordings.";