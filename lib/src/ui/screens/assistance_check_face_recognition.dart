import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterappfdp/src/blocs/faceRecognition/face_recognition_bloc.dart';
import 'package:flutterappfdp/src/blocs/faceRecognition/face_recognition_events.dart';
import 'package:flutterappfdp/src/ui/components/bars/bottom_navigation_bar.dart';
import 'package:flutterappfdp/src/ui/components/bars/sentinel_app_bar.dart';
import 'package:image_picker/image_picker.dart';

class FaceRecognitionView extends StatefulWidget {
  @override
  _FaceRecognitionViewState createState() => _FaceRecognitionViewState();
}

class _FaceRecognitionViewState extends State<FaceRecognitionView> {

  FaceRecognitionBloc _faceRecognitionBloc = FaceRecognitionBloc();

  String _eventId;
  File _videoFile;
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;

  Future getVideoFromCamera() async{
    try{
      PickedFile image = await _picker.getVideo(source: ImageSource.camera);
      setState(() {
        _videoFile = File(image.path);
        _faceRecognitionBloc.add(SubmitVideoEvent(video: _videoFile, eventId: _eventId));
      });
    }catch (e){
      _pickImageError = e;
    }
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _faceRecognitionBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    _eventId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: SentinelAppBar().buildAppBar(),
      body: mainView(),
      bottomNavigationBar: SentinelBottomNavigationBar(),
    );
  }

  Column mainView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 10.0),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Face Recognition Assistance Check',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 60),
        SizedBox(height: 60),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Face Recognition requires a clear video of the faces."),
              SizedBox(height: 15),
              Text("The video must be recorded in landscape format."),
              SizedBox(height: 15,),
              Text('The recorded faces must have been uploaded by every user in the "Profile->Upload Face Details" options.'),
            ],
          ),
        ),
        SizedBox(height: 30),
        FlatButton(
          child: Text(
            "Open video camera",
            style: TextStyle(
                color: Colors.white
            ),
          ),
          onPressed: () => getVideoFromCamera(),
          color: Colors.blue[900],
        ),
      ],
    );
  }

}
