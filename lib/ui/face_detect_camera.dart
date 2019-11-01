import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class FaceDetectScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FaceDetectStateWidget();
  }
}

class FaceDetectStateWidget extends State<FaceDetectScreen> {
  File _imageFile;
  List<Face> _faces;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text(
            'Face Detector',
          ),
        ),
        body: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Detect'),
              onPressed: () {
                detectFaces();
              },
            )
          ],
        ));
  }

  Future detectFaces() async {
    final File imageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    final image = FirebaseVisionImage.fromFile(imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector(
        FaceDetectorOptions(
            mode: FaceDetectorMode.fast,
            enableLandmarks: true,
            enableClassification: false,
            enableTracking: true));
    final faces = await faceDetector.processImage(image);

    if (mounted) {
      setState(() {
        _imageFile = imageFile;
        _faces = faces;
      });
    }
  }
}
