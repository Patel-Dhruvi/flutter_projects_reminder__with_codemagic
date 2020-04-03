import 'dart:io';

import 'package:flutter/material.dart';


class ImageDisplay extends StatefulWidget {

  ImageDisplay(this.imageFile);

  final File imageFile;

  @override
  _ImageDisplayState createState() => _ImageDisplayState(this.imageFile);
}

class _ImageDisplayState extends State<ImageDisplay> {

  _ImageDisplayState(this.imageFile);

  final File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Image.file(imageFile),
      ),
    );
  }
}
