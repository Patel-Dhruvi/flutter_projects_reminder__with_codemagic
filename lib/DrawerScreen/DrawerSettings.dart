import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reminder_things/BlocPattern/ImgBlocPattern.dart';
import 'package:reminder_things/Constants.dart';
import 'package:reminder_things/Model/HeaderImageModel.dart';
import 'package:reminder_things/Model/HeaderTextSizeModel.dart';
import 'package:reminder_things/Utils/GetImageFromDirectory.dart';
import 'package:reminder_things/Utils/PreferencesHelper.dart';

class DrawerSettings extends StatefulWidget {
  @override
  _DrawerSettingsState createState() => _DrawerSettingsState();
}

class _DrawerSettingsState extends State<DrawerSettings> {
  bool isDone = false;
  bool isShowWeekday = false;
  bool isVibrate = true;
  var selectedTextSize;
  var isBottomShitOpen=false;
  ImageBlocPattern imageBlocPattern = ImageBlocPattern();
  GetImageFromDirectory getImageFromDirectory = GetImageFromDirectory();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PreferencesHelper.getDoubleValue(PreferencesHelper.PREF_SELECTED_TEXT_SIZE)
        .then((value) {
      setState(() {
        selectedTextSize = value != 0 ? value : 30;
      });
    });
    var list = imageBlocPattern.getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Settings",
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
        body: getSettingsScreen(context));
  }

  Widget getSettingsScreen(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        child: ListView(
          children: <Widget>[
            FutureBuilder(
        future:  PreferencesHelper.getBoolValue(PreferencesHelper.PREF_IS_TASK_DONE),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          isDone=snapshot.data;
          return ListTileWithSwitch(
            upperText: "Delete done tasks",
            smallText: "Tasks will be deleted when you mark them as done",
            isSet:(snapshot.data!=null)?snapshot.data:false,
            onChange: (value) {
              setState(() {
                isDone = value;
                PreferencesHelper.setBoolValue(PreferencesHelper.PREF_IS_TASK_DONE, isDone);
              });
            },
            onTap: () {
              setState(() {
                isDone = !isDone;
                PreferencesHelper.setBoolValue(PreferencesHelper.PREF_IS_TASK_DONE, isDone);
              });
            },
          );
        }

            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future:  PreferencesHelper.getBoolValue(PreferencesHelper.PREF_SHOW_WEEKDAY_NAME),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return ListTileWithSwitch(
                  upperText: "Show weekday name",
                  smallText: "weekday name will be shown with task's date",
                  isSet: (snapshot.data!=null)?snapshot.data:false,
                  onChange: (value) {
                    setState(() {
                      isShowWeekday = value;
                      PreferencesHelper.setBoolValue(PreferencesHelper.PREF_SHOW_WEEKDAY_NAME, isShowWeekday);
                    });
                  },
                  onTap: () {
                    setState(() {
                      isShowWeekday = !isShowWeekday;
                      PreferencesHelper.setBoolValue(PreferencesHelper.PREF_SHOW_WEEKDAY_NAME, isShowWeekday);
                    });
                  },
                );
              }

            ),
          StreamBuilder(
            stream: imageBlocPattern.imgData,
            builder:(context, AsyncSnapshot<List<HeaderImageModel>> snapshot) {
              return ListTileWidget(
                onTap: () {
                  _showBottomSheet(context,snapshot);
                },
                title: "Set Header Image",
                subtitle: "custome",
              );
            }
          ),
            ListTileWidget(
                onTap: () {
                  _showAlertDialogBox(context);
                },
                title: "Set Header Font Size",
                subtitle: selectedTextSize.toString()),
            ListTileWidget(
              onTap: () {},
              title: "Set Notification Sound",
              subtitle: "Default",
            ),
            FutureBuilder(
              future:  PreferencesHelper.getVibrateBoolValue(PreferencesHelper.PREF_IS_VIBRATE),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return ListTileWithSwitch(
                  upperText: "Vibration",
                  smallText: "Tap to off vibration when notification is arrivied",
                  isSet: (snapshot.data!=null)?snapshot.data:true,
                  onChange: (value) {
                    setState(() {
                      isVibrate = value;
                      PreferencesHelper.setBoolValue(PreferencesHelper.PREF_IS_VIBRATE, isVibrate);
                    });
                  },
                  onTap: () {
                    setState(() {
                      isVibrate = !isVibrate;
                      PreferencesHelper.setBoolValue(PreferencesHelper.PREF_IS_VIBRATE, isVibrate);
                    });
                  },
                );
              }

            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialogBox(BuildContext context) {
    HeaderTextSize headerTextSize = HeaderTextSize();
    List<HeaderTextSize> list = headerTextSize.list;
    int radioBtnId;
    PreferencesHelper.getIntValue(PreferencesHelper.PREF_SELECTED_TEXT_INDEX)
        .then((value) {
      setState(() {
        radioBtnId = value;
      });
    });
    var alertDialog = AlertDialog(
      title: Text("Choose Text Size"),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return ListView(
            children: list
                .map((data) => RadioListTile(
                      title: Text("${data.size}"),
                      groupValue: radioBtnId,
                      value: data.index,
                      onChanged: (value) {
                        setState(() {
                          radioBtnId = value;
                          selectedTextSize = data.size;
                        });
                      },
                    ))
                .toList(),
          );
        },
      ),
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
              PreferencesHelper.setDoubleValue(
                  PreferencesHelper.PREF_SELECTED_TEXT_SIZE, selectedTextSize);
              PreferencesHelper.setIntValue(
                  PreferencesHelper.PREF_SELECTED_TEXT_INDEX, radioBtnId);
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

  _showBottomSheet(
      BuildContext context, AsyncSnapshot<List<HeaderImageModel>> snapshot1,) {
    showModalBottomSheet(
        isScrollControlled: true,
        elevation: 10,
        context: context,
        builder: (builder) {
          return StreamBuilder(
            initialData: snapshot1.data,
            stream: imageBlocPattern.imgData,
              builder: (context, AsyncSnapshot<List<HeaderImageModel>> snapshot) {
              return Container(
                height: 400,
                margin: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        children: <Widget>[
                          GFAvatar(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            backgroundColor: Colors.white,
                            shape: GFAvatarShape.square,
                            size: 100,
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  print("img null");
                                  _selectImage(context);
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.all(38),
                              color: Colors.black.withOpacity(0.2),
                              child: Icon(Icons.add),
                            ),
                          ),
                          SetHeaderImage(
                            imgName: "images/drawerbg.png",
                            image: Image.asset(
                              "images/drawerbg.png",
                              fit: BoxFit.fill,
                              height: 100,
                              width: 100,
                            ),
                          ),
                          SetHeaderImage(
                            imgName: "images/headerbg.png",
                            image: Image.asset(
                              "images/headerbg.png",
                              fit: BoxFit.fill,
                              height: 100,
                              width: 100,
                            ),
                          ),
                          SetHeaderImage(
                            imgName: "images/headerbg1.png",
                            image: Image.asset(
                              "images/headerbg1.png",
                              fit: BoxFit.fill,
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: snapshot.hasData
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder: ((context, index) {
                                final HeaderImageModel imageModel =
                                    snapshot.data[index];
                                return FutureBuilder(
                                    future: getImageFromDirectory
                                        .getHeaderImageFromDirectory(imageModel.imgFileName),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<File> snapshot1) {
                                      if (snapshot1.hasData) {
                                        return Stack(
                                          alignment: Alignment.topRight,
                                          children: <Widget>[
                                            GestureDetector(
                                             onTap: (){
                                               PreferencesHelper.setStringValue(
                                                   PreferencesHelper.PREF_SELECTED_IMAGE, snapshot1.data.path);
                                               PreferencesHelper.setBoolValue(PreferencesHelper.PREF_IS_FILE_IMAGE, true);
                                               PreferencesHelper.setBoolValue(PreferencesHelper.PREF_IS_ASSET_IMAGE, false);
                                               Navigator.of(context).pop();

                                             } ,
                                              child: GFAvatar(
                                                backgroundColor: Colors.white,
                                                shape: GFAvatarShape.square,
                                                size: 100,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: Image.file(
                                                    snapshot1.data,
                                                    fit: BoxFit.fill,
                                                    width: 100,
                                                    height: 100,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0, right: 15.0),
                                              child: GestureDetector(
                                                onTap: (){

                                                  getImageFromDirectory.deleteFile(snapshot1.data);
                                                  imageBlocPattern.deleteTaskById(imageModel.imgId);
                                                },
                                                child: CircleAvatar(
                                                  child: Icon(
                                                    Icons.close,
                                                    color:
                                                        Colors.white.withOpacity(0.6),
                                                  ),
                                                  backgroundColor:
                                                      Colors.black.withOpacity(0.6),
                                                  radius: 12,

                                                ),
                                              ),

                                            )
                                          ],
                                        );
                                      } else {
                                        return Container(
                                          color: Colors.green,
                                          height: 20,
                                        );
                                      }
                                    });
                              }),
                            )
                          : Container(
                              color: Colors.greenAccent,
                              height: 30,
                            ),
                    ),
                  ],
                ),
              );
            }
          );
        });

  }

  void _selectImage(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var filename = basename(image.path);
    final HeaderImageModel headerImageModel = HeaderImageModel(filename);
    imageBlocPattern.insertData(headerImageModel);
    _saveImgInDirectory(filename, image);
  }

  void _saveImgInDirectory(String imgName, File file) async {
    print("save in directory");
    var documentDirectory = await getExternalStorageDirectory();
    var firstPath = documentDirectory.path + "/Pictures";
    await Directory(firstPath).create(recursive: true);
    var filePathAndName = firstPath + '/$imgName';
    print(filePathAndName);
    File file2 = new File(filePathAndName);
    print(file2);
    file2.writeAsBytesSync(file.readAsBytesSync());
  }
}

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({this.title, this.subtitle, this.onTap});

  final String title;
  final String subtitle;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class SetHeaderImage extends StatelessWidget {
  SetHeaderImage({this.imgName, this.image});

  final String imgName;
  final Widget image;
  final ImageBlocPattern imageBlocPattern = ImageBlocPattern();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
          PreferencesHelper.setStringValue(
              PreferencesHelper.PREF_SELECTED_IMAGE, this.imgName);
          PreferencesHelper.setBoolValue(PreferencesHelper.PREF_IS_FILE_IMAGE, false);
          PreferencesHelper.setBoolValue(PreferencesHelper.PREF_IS_ASSET_IMAGE, true);
          print("in tap $imgName");
          Navigator.of(context).pop();

      },
      child: GFAvatar(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        backgroundColor: Colors.white,
        shape: GFAvatarShape.square,
        size: 100,
        child: ClipRRect(borderRadius: BorderRadius.circular(5), child: image),
      ),
    );
  }
}

class ListTileWithSwitch extends StatelessWidget {
  const ListTileWithSwitch(
      {this.upperText, this.smallText, this.isSet, this.onChange, this.onTap});

  final String upperText;
  final String smallText;
  final bool isSet;
  final Function onChange;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(upperText, style: kSettingsUpperText),
      subtitle: Text(smallText, style: kSettingsSmallText),
      trailing: Container(
        width: 60,
        child: Switch(
          value: isSet,
          onChanged: onChange,
          activeTrackColor: kRemindColor,
          activeColor: Colors.orange,
        ),
      ),
    );
  }
}
