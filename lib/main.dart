import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Detection Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(title: 'Face Detection Demo'),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the MyHomePage widget.
        '/': (context) => MyHomePage(title: 'Face Detection Demo'),
        // When navigating to the "/second" route, build the SecondScreen widget.
        //'/faceDetectCamera': (context) => FaceDetectScreen(),
      },
    );
}

  }
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  PermissionStatus _status;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _imageFile;
  List<Face> _faces;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Detect Faces'),
              onPressed: () {detectFaces();},
            )
          ],
        ),
      ),
    );
  }

  Future<void> detectFaces() async {
    final File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
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
