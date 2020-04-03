import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reminder_things/AppScreens/Home.dart';
import 'package:reminder_things/AppScreens/VideoPlayerScreen.dart';
import 'package:reminder_things/BlocPattern/BlocPattern.dart';
import 'package:reminder_things/ComponentWidget/AudioRecord.dart';
import 'package:reminder_things/ComponentWidget/BottomShhetListTile.dart';
import 'package:reminder_things/ComponentWidget/DetailsPageContainer.dart';
import 'package:reminder_things/ComponentWidget/SetMultipleImages.dart';
import 'package:reminder_things/ComponentWidget/SetSingleImageInDetailScreen.dart';
import 'package:reminder_things/Constants.dart';
import 'package:reminder_things/Model/TextModel.dart';
import 'package:reminder_things/Utils/GetImageFromDirectory.dart';
import 'package:reminder_things/Utils/GetItemTextModel.dart';
import 'package:reminder_things/Utils/GetLocationAddress.dart';
import 'package:reminder_things/Utils/PreferencesHelper.dart';
import 'package:reminder_things/Utils/SetNotification.dart';
import 'package:reminder_things/Utils/ShowToast.dart';
import 'package:reminder_things/Utils/ShowWeekdayName.dart';

import 'ImageDisplayScreen.dart';

class AddDetailsScreen extends StatefulWidget {
  AddDetailsScreen({this.isListDataTapped, this.itemId, this.selecteditemType,this.tabSelected});

  final bool isListDataTapped;
  final int itemId;
  final String selecteditemType;
  final int tabSelected;

  @override
  _AddDetailsScreenState createState() => _AddDetailsScreenState(
      isListDataTapped: isListDataTapped,
      itemId: itemId,
      selecteditemType: selecteditemType,
  tabSelected:tabSelected);
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  _AddDetailsScreenState(
      {this.isListDataTapped, this.itemId, this.selecteditemType,this.tabSelected});

  final bool isListDataTapped;
  final int itemId;
  final String selecteditemType;
  final int tabSelected;

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();
  BlocPattern blocPattern = BlocPattern();
  bool isItemSelected;
  var repeatTypeArray = ['Once', 'Everyday', 'Weekly', 'Monthly'];
  var currentSelectedRepeatValue;
  var descriptionValue;
  var itemType;
  var imgPath;
  var fileName;
  var address;
  var isAudioPlaying = false;

//  var isLocationIconTapped = false;
  var isEditTapped = false;
  var isPostPone = false;
  var isTitleValid = false;

  var dateInDateTimeFormat;

  FlutterSound flutterSound = new FlutterSound();
  GetItemTextModel getItemtextModel = GetItemTextModel();
  GetImageFromDirectory getitemPictrure = GetImageFromDirectory();
  GetLocationAddress getLocationAddress = GetLocationAddress();

  var notifications = FlutterLocalNotificationsPlugin();
  List<Asset> images = List<Asset>();
  List<String> multipleImageArray = List<String>();
  String jsonString;
  String _error = 'No Error Dectected';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PersistentBottomSheetController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    itemType = kTextType;
    fileName = kTextType;
    setState(() {
      isItemSelected = isListDataTapped;
      if (isItemSelected) {
        _getDetailsOfItem(itemId);
      } else {
        currentSelectedRepeatValue = "Once";
      }
    });

    final settingsAndroid = AndroidInitializationSettings('flutter_logo');
    final settingsIOS = IOSInitializationSettings();
//        onDidReceiveLocalNotification: (id, title, body, payload) =>
//            onSelectNotification(payload));

    notifications
        .initialize(InitializationSettings(settingsAndroid, settingsIOS));
//        onSelectNotification: onSelectNotification);
  }

  void _getDetailsOfItem(int itemId) {
    getItemtextModel.getTextModel(itemId).then((value) {
      setState(()  {
        titleController.text = value.title;
        timeController.text = value.time;
        discriptionController.text = value.description;
        currentSelectedRepeatValue = value.repeat;
        itemType = value.type;
        fileName = value.filename;
        address = value.address;
        setDate(value.date).then((value){
          dateController.text=value;
        });

        if (value.type.contains(kPictureType)) {
          if (value.imagesarray != null) {
            var d =  jsonDecode(value.imagesarray);
            multipleImageArray = List.from(d);
            print(multipleImageArray);
          } else {
            multipleImageArray.length = 0;
          }
        }
      });
    });
  }

  bool _validateTitle(String value, AsyncSnapshot<List<TextModel>> snapshot) {
    for (int i = 0; i < snapshot.data.length; i++) {
      TextModel textModel = snapshot.data[i];
      if (textModel.title.contains(value)) {
        print("match found");
        return true;
      }
    }
    return false;
  }

  void _showDatePicker(BuildContext context) async {
    var date;
    var month;
    DateTime dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime(2021),
      initialDatePickerMode: DatePickerMode.day,
    );
    date= setDateFormat(dateTime.day);
    month=setMonthFormat(dateTime.month);

    var dateformat = "$date/$month/${dateTime.year}";
    setDate(dateformat).then((value){
      setState(() {
        dateController.text=value;
        print(dateController.text.length);
      });

    });
  }



  void _showTimePicker(BuildContext context) async {
    var hour;
    var minute;
    TimeOfDay time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    String aMpM;
    if (time.hour < 12) {
      aMpM = "AM";
    } else {
      aMpM = "PM";
    }
    hour= setHourFormat(time.hour,time.hourOfPeriod);
    minute=setMinuteFormat(time.minute);
    var timeformat = "$hour:$minute $aMpM";
    timeController.text = timeformat;
  }

  Widget _showDropDownButton(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Theme(
      data: themeData.copyWith(canvasColor: Colors.white),
      child: DropdownButton<String>(
        items: repeatTypeArray.map((String dropDownStringItem) {
          return DropdownMenuItem<String>(
              value: dropDownStringItem, child: Text(dropDownStringItem));
        }).toList(),
        onChanged: (String newValueSelected) {
          setState(() {
            currentSelectedRepeatValue = newValueSelected;
          });
        },
        value: currentSelectedRepeatValue,
        style: kDScreenContainerTrailingTextStyle,
      ),
    );
  }

  void _showDiscriptionAlertDialog(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("Add a Note"),
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      content: TextFormField(
        autofocus: false,
        maxLines: 3,
        decoration: InputDecoration(
            hintText: "Add a Description",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        controller: discriptionController,
      ),
      actions: <Widget>[
        RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
          color: kRemindColor,
        ),
        RaisedButton(
          onPressed: () {
            setState(() {
              descriptionValue = discriptionController.value.text;
            });

            Navigator.pop(context);
          },
          child: Text("Ok"),
          color: kRemindColor,
        )
      ],
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void _showAudioAlertDialog(BuildContext context, String title) {
    var alertDialog = AlertDialog(
      title: Text(
        "Record Audio",
        style: kRecordAudioTextStyle,
      ),
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      content: AudioRecord(title),
      actions: <Widget>[
        RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
          ),
          color: kRemindColor,
        ),
        RaisedButton(
          onPressed: () {
            setState(() {
              itemType = kAudioType;
              fileName = title;
              Navigator.pop(context);
            });
          },
          child: Text("Ok"),
          color: kRemindColor,
        )
      ],
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  _insertData(BuildContext context) {
    if (itemType != null &&
        titleController.text.isNotEmpty &&
        fileName != null) {
      final TextModel textmodel = TextModel(
          itemType,
          titleController.value.text,
          dateController.value.text,
          timeController.value.text,
          descriptionValue,
          currentSelectedRepeatValue,
          fileName,
          address,
          jsonString);
      blocPattern.insertData(textmodel);

      setNotification(
        titleController.value.text,
        discriptionController.value.text,
        dateController.value.text,
        timeController.value.text,
        currentSelectedRepeatValue,
        notifications,
      );
      _navigateToHome(context);
    } else {
      if (titleController.text.isEmpty && fileName == null)
        showToast(
            "Please Enter Your Remind Title and also Select any Type which you want to add in Reminder ");
      else {
        if (titleController.text.isEmpty)
          showToast("Please Enter Your Remind Title");
        else
          showToast("Please Select any Type which you want to add in Reminder");
      }
    }
  }

  _updateData(BuildContext context, int itemId,
      AsyncSnapshot<List<TextModel>> snapshot) {
    final TextModel textmodel = TextModel(
        itemType,
        titleController.value.text,
        dateController.value.text,
        timeController.value.text,
        discriptionController.value.text,
        currentSelectedRepeatValue,
        fileName,
        address,
        jsonString,
        itemId);

    var timeIn24houres =
        convertIntoDateTime.convertInto24Hours(timeController.value.text);
    var timeArray = timeIn24houres.split(":");
    var hourTime = int.parse(timeArray[0]);
    var minuteTime = int.parse(timeArray[1]);

    getItemtextModel.getTextModel(itemId).then((value) {
      if (!value.time.contains(timeController.value.text) &&
          !value.date.contains(dateController.value.text)) {
        print("update time and date");
        setNotification(
            titleController.value.text,
            discriptionController.value.text,
            dateController.value.text,
            timeController.value.text,
            currentSelectedRepeatValue,
            notifications);
        blocPattern.updateData(textmodel);
        _navigateToHome(context);
      } else if (!value.date.contains(dateController.value.text)) {
        print("update date");
        setNotification(
            titleController.value.text,
            discriptionController.value.text,
            dateController.value.text,
            timeController.value.text,
            currentSelectedRepeatValue,
            notifications);
        blocPattern.updateData(textmodel);
        _navigateToHome(context);
      } else if (!value.time.contains(timeController.value.text)) {
        print("update time");
        if (value.type.contains(kRemindOnceType)) {
          if (hourTime < TimeOfDay.now().hour) {
            showToast("Please Select Date");
            print('less hour');
          } else if (hourTime == TimeOfDay.now().hour) {
            print("Equal hour");
            if (minuteTime < TimeOfDay.now().minute) {
              print('less minute same hour');
              showToast("Please Select Date");
            } else {
              print('same minute same hour or greater then minute');
              setNotification(
                  titleController.value.text,
                  discriptionController.value.text,
                  dateController.value.text,
                  timeController.value.text,
                  currentSelectedRepeatValue,
                  notifications);
              blocPattern.updateData(textmodel);
              _navigateToHome(context);
            }
          } else {
            print("gretaer then hour");
            setNotification(
                titleController.value.text,
                discriptionController.value.text,
                dateController.value.text,
                timeController.value.text,
                currentSelectedRepeatValue,
                notifications);
            blocPattern.updateData(textmodel);
            _navigateToHome(context);
          }
        } else {
          setNotification(
              titleController.value.text,
              discriptionController.value.text,
              dateController.value.text,
              timeController.value.text,
              currentSelectedRepeatValue,
              notifications);
          blocPattern.updateData(textmodel);
          _navigateToHome(context);
        }
      } else {
        blocPattern.updateData(textmodel);
        _navigateToHome(context);
      }
    });
  }

  void _selectOption(BuildContext context, String type) {
    var alertDialog = AlertDialog(
      title: Text("Select Options."),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            onTap: () {
              _selectFromGallery(type);
              Navigator.of(context).pop();
            },
            title: type.contains(kPictureType)
                ? Text("Select Image From Gallery")
                : Text("Select Video From Gallery"),
          ),
          ListTile(
            onTap: () {
              _pickFromCamera(type);
              Navigator.of(context).pop();
            },
            title: type.contains(kPictureType)
                ? Text("Pick Image From Camera")
                : Text("Pick Video From Gallery"),
          ),
        ],
      ),
      actions: <Widget>[
        RaisedButton(
          color: kRemindColor,
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void _pickFromCamera(String itemtype) async {
    if (itemtype.contains(kPictureType)) {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        itemType = kPictureType;
        fileName = basename(image.path);
      });
    } else {
      var video = await ImagePicker.pickVideo(
        source: ImageSource.camera,
      );
      setState(() {
        itemType = kVideoType;
        fileName = basename(video.path);
        print(fileName);
      });
    }
  }

  Future<void> getMultipleImages() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      print("multiple images");
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

//     If the widget was removed from the tree while the asynchronous platform
//     message was in flight, we want to discard the reply rather than calling
//     setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _convertIntoJSONString(images);
      _error = error;
      itemType = kPictureType;
      fileName = images[0].name;
      _getImageFileFromAssets(images);
    });
  }

  _convertIntoJSONString(List<Asset> images) {
    print("in json object");

    List<String> assetImages = List<String>();
    for (int i = 0; i < images.length; i++) {
      assetImages.add(images[i].name);
    }
    jsonString = jsonEncode(assetImages);
    print(jsonString);

  }

  _getImageFileFromAssets(List<Asset> images) async {
    print("convert in file");
    var filename;
    for (int i = 0; i < images.length; i++) {
      filename = images[i].name;
      final byteData = await images[i].getByteData();
      Uint8List unit8List = byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      _saveInDirectory(filename, unit8List);
    }
  }

  void _selectFromGallery(String type) async {
    if (type.contains(kPictureType)) {
      getMultipleImages();
    } else {
      var video = await ImagePicker.pickVideo(source: ImageSource.gallery);
      setState(() {
        itemType = kVideoType;
        fileName = basename(video.path);
        _saveInDirectory(fileName, video.readAsBytesSync());
      });
    }
  }

  void _saveInDirectory(String imgName, Uint8List unit8List,
  ) async {
    print("save in directory");
    var documentDirectory = await getExternalStorageDirectory();
    var firstPath = documentDirectory.path + "/Pictures";
    await Directory(firstPath).create(recursive: true);
    var filePathAndName = firstPath + '/$imgName';
    print(filePathAndName);
    File file2 = new File(filePathAndName);
    print(file2);
    file2.writeAsBytesSync(unit8List);
  }

  void _getCurrentLocation(BuildContext context) async {
    print("in location map");
    final result = await Geolocator().isLocationServiceEnabled();

    if (result) {
      print("in address");
      final position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        address = "${position.latitude} : ${position.longitude}";
        print(address);
      });
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Inform You..",
                style: kRecordAudioTextStyle,
              ),
              content: Text(
                "Please Turn On Your GPS Location First",
              ),
              actions: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                  ),
                  color: kRemindColor,
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: StreamBuilder(
            stream: blocPattern.data,
            builder: (BuildContext context,
                AsyncSnapshot<List<TextModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                              child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Container(
                                  color: kAppThemeUpperDarkColor,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            _navigateToHome(context);
                                            },
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: kRemindColor,
                                            size: 50,
                                          )),
                                      Visibility(
                                        visible: isItemSelected
                                            ? isEditTapped ? true : false
                                            : true,
                                        child: FlatButton(
                                            onPressed: () {
                                              isItemSelected
                                                  ? _updateData(
                                                      context, itemId, snapshot)
                                                  : !_validateTitle(
                                                          titleController
                                                              .value.text,
                                                          snapshot)
                                                      ? _insertData(context)
                                                      : showToast(
                                                          "Enter a different title");
                                            },
                                            child: Icon(
                                              Icons.check,
                                              color: kRemindColor,
                                              size: 50,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Material(
                                  color: kAppThemeUpperDarkColor,
                                  child: GestureDetector(
                                    onTap: () {
                                      isEditTapped
                                      // ignore:unnecessary_statements
                                       ? null
                                          : showToast(
                                              "You Can not Directly Edit");
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 25),
                                      decoration: BoxDecoration(
                                          color: kSearchBarColor,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: TextField(
                                          onSubmitted: (value) {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                          },
                                          enabled:
                                              isItemSelected && !isEditTapped
                                                  ? false
                                                  : true,
                                          autofocus: false,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Remind me too..",
                                              hintStyle: TextStyle(
                                                  color: Color(0XFF908F8F),
                                                  fontSize: 15,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: "Roboto")),
                                          cursorColor: kRemindColor,
                                          controller: titleController),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kRemindColor,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: FlatButton(
                                            onPressed: () {
                                              isItemSelected
                                                  ? isEditTapped
                                                      ? _audioClickEvent(
                                                          context)
                                                      : showToast(
                                                          "You Can not Directly Edit")
                                                  : _audioClickEvent(context);
                                            },
                                            child: Icon(
                                              Icons.keyboard_voice,
                                              color:
                                                  itemType.contains(kAudioType)
                                                      ? Colors.orange.shade800
                                                      : Colors.white,
                                              size: 30,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: FlatButton(
                                            onPressed: () {
//                                          isLocationIconTapped = true;
                                              isItemSelected
                                                  ? isEditTapped
                                                      ? _getCurrentLocation(
                                                          context)
                                                      : showToast(
                                                          "You Can not Directly Edit")
                                                  : _getCurrentLocation(
                                                      context);
                                            },
                                            child: Icon(
                                              Icons.location_on,
                                              color: address != null
                                                  ? Colors.orange.shade800
                                                  : Colors.white,
                                              size: 30,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: FlatButton(
                                            onPressed: () {
                                              isItemSelected
                                                  ? isEditTapped
                                                      ? _selectOption(
                                                          context, kVideoType)
                                                      : showToast(
                                                          "You Can not Directly Edit")
                                                  : _selectOption(
                                                      context, kVideoType);
                                            },
                                            child: Icon(
                                              Icons.video_call,
                                              color:
                                                  itemType.contains(kVideoType)
                                                      ? Colors.orange.shade800
                                                      : Colors.white,
                                              size: 30,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: FlatButton(
                                            onPressed: () {
                                              isItemSelected
                                                  ? isEditTapped
                                                      ? _selectOption(
                                                          context, kPictureType)
                                                      : showToast(
                                                          "You Can not Directly Edit")
                                                  : _selectOption(
                                                      context, kPictureType);
                                            },
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: itemType
                                                      .contains(kPictureType)
                                                  ? Colors.orange.shade800
                                                  : Colors.white,
                                              size: 30,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(width: 0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ),
                        Visibility(
                          visible: (itemType.contains(kPictureType) ||
                                  itemType.contains(kVideoType))
                              ? true
                              : false,
                          child: Expanded(
                              child: (images.length == 0 &&
                                      multipleImageArray.length == 0)
                                  ? SetSingleImage(fileName: fileName, itemType: itemType)
                                  : SetMultipleImages(
                                      isItemSelected: isItemSelected,
                                      isEditTapped: isEditTapped,
                                      jsonString: jsonString,
                                      images: images,
                                      multipleImageArray: multipleImageArray,
                                      itemtype: itemType)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                            flex: 4,
                            child: ListView(
                              padding: const EdgeInsets.only(top:8),
                              children: <Widget>[
                                Visibility(
                                    visible: isItemSelected,
                                    child: Card(
                                      margin: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 0,
                                          bottom: 0),
                                      elevation: 5.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                          height: 150,
                                          padding: const EdgeInsets.all(15),
                                          margin: const EdgeInsets.all(0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 1,
                                                child: isItemSelected
                                                    ? _getItemPicture(
                                                        itemId, snapshot)
                                                    : Icon(Icons.filter),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .baseline,
                                                    textBaseline:
                                                        TextBaseline.alphabetic,
                                                    children: <Widget>[
                                                      isItemSelected
                                                          ? getItemtextModel
                                                              .getItemTitle(
                                                                  itemId,
                                                                  snapshot)
                                                          : Text(
                                                              "Tilte is Not Found"),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      isItemSelected
                                                          ? getItemtextModel
                                                              .getItemDate(
                                                                  itemId,
                                                                  snapshot)
                                                          : Text(
                                                              "Date is Not Found"),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      isItemSelected
                                                          ? getItemtextModel
                                                              .getItemDescription(
                                                                  itemId,
                                                                  snapshot,
                                                                  context)
                                                          : Text(
                                                              "Description is Not Found"),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      isItemSelected
                                                          ? getLocationAddress
                                                              .getItemAddress(
                                                                  itemId,
                                                                  snapshot)
                                                          : Text(
                                                              "Description is Not Found"),
                                                    ],
                                                  )),
                                              Expanded(
                                                flex: 0,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Expanded(
                                                        flex: 0,
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              print(
                                                                  "bottomsheet open");
                                                              _showBottomSheet(
                                                                  context,
                                                                  itemId,
                                                                  snapshot);
                                                            },
                                                            child: Icon(Icons
                                                                .more_vert))),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Visibility(
                                                          visible: isItemSelected
                                                              ? (selecteditemType
                                                                      .contains(
                                                                          kAudioType)
                                                                  ? true
                                                                  : false)
                                                              : false,
                                                          child: MaterialButton(
                                                              minWidth: 1,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2),
                                                              onPressed: () {
                                                                TextModel
                                                                    textModel =
                                                                    getItemtextModel.getItemTextModel(
                                                                        snapshot,
                                                                        itemId);
                                                                _pauseAudio(
                                                                    isAudioPlaying,
                                                                    textModel
                                                                        .title);
                                                              },
                                                              color:
                                                                  kRemindColor,
                                                              shape: CircleBorder(
                                                                  side:
                                                                      BorderSide
                                                                          .none),
                                                              child: Icon(
                                                                Icons.pause,
                                                                color: Colors
                                                                    .white,
                                                              ))),
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Visibility(
                                                          visible: isItemSelected
                                                              ? (selecteditemType
                                                                      .contains(
                                                                          kAudioType)
                                                                  ? true
                                                                  : false)
                                                              : false,
                                                          child: MaterialButton(
                                                              minWidth: 1,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2),
                                                              onPressed: () {
                                                                TextModel
                                                                    textModel =
                                                                    getItemtextModel.getItemTextModel(
                                                                        snapshot,
                                                                        itemId);
                                                                _playAudio(
                                                                    textModel
                                                                        .title);
                                                              },
                                                              color:
                                                                  kRemindColor,
                                                              shape: CircleBorder(
                                                                  side:
                                                                      BorderSide
                                                                          .none),
                                                              child: Icon(
                                                                Icons
                                                                    .play_arrow,
                                                                color: Colors
                                                                    .white,
                                                              ))),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                DetailsPageContainer(
                                  onTap: () {
                                    isItemSelected
                                        ? isEditTapped
                                            ? _showDatePicker(context)
                                            : showToast(
                                                "You Can not Directly Edit")
                                        : _showDatePicker(context);
                                  },
                                  leading: Icons.date_range,
                                  title: "Date",
                                  trailing: Container(
                                    width: (dateController.text.length>=11)?105:90,
                                    child: TextFormField(
                                      style: kDScreenContainerTrailingTextStyle,
                                      enabled: false,
                                      showCursor: false,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "09/17/2020",
                                      ),
                                      controller: dateController,
                                    ),
                                  ),
                                ),
                                DetailsPageContainer(
                                  onTap: () {
                                    _changeTime(context);
                                  },
                                  leading: Icons.access_time,
                                  title: "Time",
                                  trailing: Container(
                                    width: 70,
                                    child: TextFormField(
                                      enabled: false,
                                      style: kDScreenContainerTrailingTextStyle,
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      },
                                      showCursor: false,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "12:00 AM",
                                      ),
                                      controller: timeController,
                                    ),
                                  ),
                                ),
                                DetailsPageContainer(
                                    onTap: () {
                                      isItemSelected
                                      ? isEditTapped
                                          // ignore: unnecessary_statements
                                          ? null
                                          : showToast(
                                              "You Can not Directly Edit")
                                      // ignore: unnecessary_statements
                                      :null;
                                    },
                                    leading: Icons.autorenew,
                                    title: "Repeat",
                                    trailing: Container(
                                        width: 90,
                                        child: isItemSelected
                                            ? isEditTapped
                                                ? _showDropDownButton(context)
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0),
                                                    child:
                                                        currentSelectedRepeatValue !=
                                                                null
                                                            ? Text(
                                                                currentSelectedRepeatValue,
                                                                style:
                                                                    kDScreenContainerTrailingTextStyle,
                                                              )
                                                            : Text(
                                                                "Once",
                                                                style:
                                                                    kDScreenContainerTrailingTextStyle,
                                                              ),
                                                  )
                                            : _showDropDownButton(context))),
                                DetailsPageContainer(
                                    onTap: () {
                                      isItemSelected
                                          ? isEditTapped
                                              ? _showDiscriptionAlertDialog(
                                                  context)
                                              : showToast(
                                                  "You Can not Directly Edit")
                                          : _showDiscriptionAlertDialog(
                                              context);
                                    },
                                    leading: Icons.insert_drive_file,
                                    title: "Note",
                                    trailing: FlatButton(
                                      child: Icon(
                                        Icons.mode_edit,
                                        size: 25,
                                      ),
                                      onPressed: () {
                                        isItemSelected
                                            ? isEditTapped
                                                ? _showDiscriptionAlertDialog(
                                                    context)
                                                : showToast(
                                                    "You Can not Directly Edit")
                                            : _showDiscriptionAlertDialog(
                                                context);
                                      },
                                    )),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ))
                      ]);
                } else {
                  return Container(child: Text("NO Data"));
                }
              } else {
                return Container(
                  child: Center(
                    child: Text("No Data"),
                  ),
                );
              }
            }),
      ),
      onWillPop: () {
        _navigateToHome(context);
        return null;
      },
    );
  }

  _getItemPicture(
    itemId,
    snapshot,
  ) {
    TextModel textModel = getItemtextModel.getItemTextModel(snapshot, itemId);
    return FutureBuilder(
      future: getitemPictrure.getImageFromDirectory(textModel),
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return textModel.type.contains(kVideoType)
                ? GestureDetector(
                    onTap: () {
                      print("video tap");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FutureBuilder(
                                    future:
                                        getitemPictrure.getvideoFile(textModel),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        return VideoPlayerScreen(snapshot.data);
                                      } else {
                                        return Text("Failure");
                                      }
                                    },
                                  )));
                    },
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {},
                              child: Image.file(
                                snapshot.data,
                                fit: BoxFit.fill,
                                height: 100,
                              )),
                          Icon(
                            Icons.play_circle_filled,
                            color: Colors.white.withOpacity(0.6),
                            size: 40,
                          )
                        ],
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ImageDisplay(snapshot.data)));
                    },
                    child: Center(
                      child: Image.file(
                        snapshot.data,
//                    fit: BoxFit.fill,
                      ),
                    ),
                  );
          } else {
            return Container(
              child: Text("Image is Can't load"),
            );
          }
        } else {
          if (textModel.type.contains(kTextType)) {
            return Center(
                child: Icon(Icons.filter, size: 80, color: kRemindColor));
          } else if (textModel.type.contains(kAudioType)) {
            return GestureDetector(
              onTap: () {
                _playAudio(textModel.title);
              },
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.asset(
                      "images/audiobg.png",
                    ),
                    Image.asset("images/audioicon.png"),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              width: 0.0,
              height: 0.0,
            );
          }
        }
      },
    );
  }

  _playAudio(String title) async {
    var documentDirectory = await getExternalStorageDirectory();
    var firstPath = documentDirectory.path + "/audio" + "/$title.aac";
    String path = await flutterSound.startPlayer(firstPath);
    setState(() {
      this.isAudioPlaying = true;
    });
    await flutterSound.setVolume(1.0);
    print('startPlayer: $path');
  }

  _pauseAudio(bool isAudioPlaying, String title) async {
    print("audio in pause method");
    await flutterSound.pausePlayer();
    setState(() {
      isAudioPlaying = false;
    });
  }

  _showBottomSheet(BuildContext context, int itemId,
      AsyncSnapshot<List<TextModel>> snapshot) {
    showModalBottomSheet(
      isScrollControlled: true,
        elevation: 10,
        context: context, builder: (builder) {
      return Container(
//              height: 400,
        padding: const EdgeInsets.only(top:5,bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            BottomSheetListTile(
              onTap: () {
                Navigator.of(context).pop();
                _showDoneAlertDialog(context,snapshot);
                },
              title: "Done",
              leading: Icons.check,
            ),
            BottomSheetListTile(
              onTap: () {
                Navigator.of(context).pop();
                setState(() {
                  isPostPone = true;
                  showToast("You can only change your Time");
                });
              },
              title: "Postpone",
              leading: Icons.alarm,
            ),
            BottomSheetListTile(
              onTap: () {
                Navigator.of(context).pop();
                setState(() {
                  isEditTapped = true;
                });
              },
              title: "Edit",
              leading: Icons.edit,
            ),
            BottomSheetListTile(
              onTap: () {
                Navigator.of(context).pop();
                _deleteData(itemId, snapshot, context);
              },
              title: "Delete",
              leading: Icons.delete,
            )
          ],
        ),
      );
    });


  }

  void _changeTime(BuildContext context) {
    if (isItemSelected) {
      if (isEditTapped)
        _showTimePicker(context);
      else if (isPostPone)
        _showTimePicker(context);
      else {
        showToast("You Can not Directly Edit");
      }
    } else {
      _showTimePicker(context);
    }
  }

  void _deleteData(int itemId, AsyncSnapshot<List<TextModel>> snapshot,
      BuildContext context) {
    getitemPictrure.deleteFileFromDirectory(itemId);
    blocPattern.deleteTaskById(itemId);
    _navigateToHome(context);
  }

  void _navigateToHome(BuildContext context) {

        Navigator.pushReplacementNamed(context, '/home',
        arguments: Home(preSelectedTab:tabSelected));

//    int count = 0;
//    Navigator.of(context).popUntil((_) => count++ >= 2);
//    Navigator.pushNamed(context, '/home');
  }

  void _audioClickEvent(BuildContext context) {
    titleController.text.isNotEmpty
        ? _showAudioAlertDialog(context, titleController.value.text)
        : showToast("Please First Enter your Audio Title");
  }

  void _showDoneAlertDialog(BuildContext context, AsyncSnapshot<List<TextModel>> snapshot) {
var alertDialog=AlertDialog(
  title: Text("Your Task was done?"),
  content: Text("If you press OK then your task will be deleted"),
  actions: <Widget>[
    RaisedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        "Cancel",
      ),
      color: kRemindColor,
    ),
    RaisedButton(
      onPressed: () async {
        Navigator.of(context).pop();
        if(await PreferencesHelper.getBoolValue(PreferencesHelper.PREF_IS_TASK_DONE)){
            _deleteData(itemId, snapshot, context);
          }
          else{
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Tap to on delete Option in settings menu"),
                    actions: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "OK",
                        ),
                        color: kRemindColor,
                      ),
                    ],
                  );
                });}
          },
      child: Text("Ok"),
      color: kRemindColor,
    )
  ],
);
showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }





//  Future onSelectNotification(String payload) async {
//    showDialog(
//      context: this.context,
//      builder: (_) {
//        return new AlertDialog(
//          title: Text("payload"),
//          content: Text("Payload : $payload"),
//          actions: <Widget>[
//            RaisedButton(
//              child:Text("Ok") ,
//              onPressed: () {
//                Navigator.pop(this.context);
//              },
//            )
//          ],
//        );
//      },
//    );
//  }

}


