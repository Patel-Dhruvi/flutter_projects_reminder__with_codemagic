import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reminder_things/Constants.dart';



class AudioRecord extends StatefulWidget {

  AudioRecord(this.audioFilename);

  final audioFilename;

  @override
  _AudioRecordState createState() => _AudioRecordState(audioFilename);
}

class _AudioRecordState extends State<AudioRecord> {

  _AudioRecordState(this.audioFilename);

  final audioFilename;
  FlutterSound flutterSound;
  bool _isRecording = false;
  bool _isPlaying = false;

  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  StreamSubscription _playerSubscription;


  String _recorderTxt = '00:00:00';
  double _dbLevel;

  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;
  t_CODEC _codec = t_CODEC.CODEC_AAC;






  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterSound = new FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);
    initializeDateFormatting();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    flutterSound.stopRecorder();
    super.dispose();
  }
  void startRecorder() async{

    try {

      var documentDirectory = await getExternalStorageDirectory();
      var firstPath = documentDirectory.path + "/audio";
      await Directory(firstPath).create(recursive: true);

      String result = await flutterSound.startRecorder(codec: _codec,uri:'$firstPath/$audioFilename.aac' );
      print('start recorder : $result');


      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
            e.currentPosition.toInt(), isUtc: true);
        String txt = DateFormat('mm:ss:SS', 'en_US').format(date);


      this.setState(() {
        this._recorderTxt = txt.substring(0,8);
      });

      });
      _dbPeakSubscription =
          flutterSound.onRecorderDbPeakChanged.listen((value) {
            print("got update -> $value");
            setState(() {
              this._dbLevel = value;
            });
          });

      this.setState(() {
        this._isRecording = true;
      });
    }
    catch (err) {
      print('startRecorder error: $err');
    }
  }

  void stopRecorder() async {

    try{
      String result1 = await flutterSound.stopRecorder();
      print('stopRecorder: $result1');

      if (_recorderSubscription != null) {
        _recorderSubscription.cancel();
        _recorderSubscription = null;
      }
      if (_dbPeakSubscription != null) {
        _dbPeakSubscription.cancel();
        _dbPeakSubscription = null;
      }

      this.setState(() {
        this._isRecording = false;
      });

    }catch (err) {
      print('stopRecorder error: $err');
    }

  }

  void  startPlayer() async {

    var documentDirectory = await getExternalStorageDirectory();
    var firstPath = documentDirectory.path + "/audio" +"/$audioFilename.aac";

    String path = await flutterSound.startPlayer(firstPath);
    await flutterSound.setVolume(1.0);
    print('startPlayer: $path');

    try{
    _playerSubscription=flutterSound.onPlayerStateChanged.listen((e){
      if (e != null) {
        sliderCurrentPosition = e.currentPosition;
        maxDuration = e.duration;

        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
            e.currentPosition.toInt(),
            isUtc: true);
        String txt = DateFormat('mm:ss:SS', 'pt_BR').format(date);
        this.setState(() {
          this._isPlaying = true;
          this._recorderTxt = txt.substring(0,8);
        });
      }
    });
    }catch (err) {
      print('error: $err');
    }

  }

  void stopPlayer() async{

    try {
      String result = await flutterSound.stopPlayer();
      print('stopPlayer: $result');

      if (_playerSubscription != null) {
        _playerSubscription.cancel();
        _playerSubscription = null;
      }
      this.setState(() {
        this._isPlaying = false;
      });
    } catch (err) {
      print('error: $err');
    }
  }

  void pausePlayer() async {

    String result = await flutterSound.pausePlayer();
    print('pausePlayer: $result');
  }

  void resumePlayer() async {
    String result = await flutterSound.resumePlayer();
    print('resumePlayer: $result');
  }

//   void seekToPlayer(int milliSecs) async {
//    String result = await flutterSound.seekToPlayer(milliSecs);
//    print('seekToPlayer: $result');
//  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Text(
                  this._recorderTxt,
                  style: TextStyle(
                    fontSize: 48.0,
                    color: Colors.black,
                  ),
                ),
              ),
              _isRecording
                  ? LinearProgressIndicator(
                value: 100.0 / 160.0 * (this._dbLevel ?? 1) / 100,
                valueColor: AlwaysStoppedAnimation<Color>(kAppThemeUpperDarkColor),
                backgroundColor: kRemindColor,
              )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 56.0,
                    height: 56.0,
                    margin: EdgeInsets.all(10.0),
                    child: FloatingActionButton(
                      backgroundColor: kRemindColor,
                      onPressed: () {
                        if (!this._isRecording) {
                          return this.startRecorder();
                        }
                        this.stopRecorder();
                      },
                      child:
                      this._isRecording ? Icon(Icons.stop,) : Icon(Icons.mic),
                    ),
                  ),
                ],

              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 56.0,
                    height: 56.0,
                    margin: EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      backgroundColor: kRemindColor,
                      onPressed: () {
                        startPlayer();
                      },
                      child: Icon(Icons.play_arrow),
                    ),
                  ),
                  Container(
                    width: 56.0,
                    height: 56.0,
                    margin: EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      backgroundColor: kRemindColor,
                      onPressed: () {
                        pausePlayer();
                      },
                      child: Icon(Icons.pause),
                    ),
                  ),
                  Container(
                    width: 56.0,
                    height: 56.0,
                    margin: EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      backgroundColor: kRemindColor,
                      onPressed: () {
                        stopPlayer();
                      },
                      child: Icon(Icons.stop),
                    ),
                  ),
                ],

              ),
            ],
          ),


      );

  }
}

