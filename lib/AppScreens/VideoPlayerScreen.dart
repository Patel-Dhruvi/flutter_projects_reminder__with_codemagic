import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen(this.videoFile);

  final File videoFile;

  @override
  _VideoPlayerScreenState createState() =>
      _VideoPlayerScreenState(this.videoFile);
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  _VideoPlayerScreenState(this.videoFile);

  final File videoFile;
  VideoPlayerController _controller;
  ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('filename is :$videoFile');
    _controller = VideoPlayerController.file(videoFile);
    _chewieController = ChewieController(
        videoPlayerController: _controller,
        aspectRatio: 16/9,
        looping: true,
        autoInitialize: true,
        errorBuilder: (context, errormsg) {
          return Center(
            child: Text(errormsg),
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Chewie(
      controller: _chewieController,
    ));
  }
}
