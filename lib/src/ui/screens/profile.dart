import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/main.dart';
import 'package:flutterappfdp/src/blocs/profile/profile_bloc.dart';
import 'package:flutterappfdp/src/blocs/profile/profile_events.dart';
import 'package:flutterappfdp/src/blocs/profile/profile_states.dart';
import 'package:flutterappfdp/src/models/userModel.dart';
import 'package:flutterappfdp/src/ui/components/bars/bottom_navigation_bar.dart';
import 'package:flutterappfdp/src/ui/components/bars/sentinel_app_bar.dart';
import 'package:flutterappfdp/src/ui/components/status/status.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileBloc _profileBloc = ProfileBloc();

  User _user;
  File _imageFile;
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;

  Future getImageFromCamera() async{
    try{
      PickedFile image = await _picker.getImage(source: ImageSource.camera);
      setState(() {
        _imageFile = File(image.path);
        _profileBloc.add(IndexImageEvent(image: _imageFile));
      });
    }catch (e){
      _pickImageError = e;
    }
  }

  @override
  void initState() {
    _profileBloc.add(FetchUserEvent());
    super.initState();
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SentinelAppBar().buildAppBar(),
      body: BlocBuilder(
        bloc: _profileBloc,
        builder: (context, state) {
          print(state);
          if (state is FetchedUserState){
            _user = state.user;
            return mainView(state.user);
          }
          else if (state is SuccessUploadIndexFaceState)
            return mainView(_user);
          else if (state is ErrorFetchingState)
            return errorProfileView();
          else
            return Status().buildLoadingView();
        },
      ),
      bottomNavigationBar: SentinelBottomNavigationBar(),
    );
  }

  Column mainView(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 10.0),
        Text('User Profile',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
        ),
        SizedBox(height: 60),
        buildLabelTextRow("Username: ", user.username),
        buildLabelTextRow("Name: ", user.name),
        buildLabelTextRow("Surname(s): ", user.surnames),
        SizedBox(height: 60),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
          child: Text("Face Details consists on 1 or more photos of your face with different point of view (angles). "
              "Front photo is necessary"),
        ),
        SizedBox(height: 30),
        FlatButton(
          child: Text(
            "Upload Face Details",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          onPressed: () => getImageFromCamera(),
          color: Colors.blue[900],
        ),
      ],
    );
  }

  Widget errorProfileView() {
    return Center(
      child: Column(
        children: <Widget>[
          Text("Error Fetching User information, try again"),
          SizedBox(height: 20),
          FlatButton(
            color: Colors.blue[900],
            child: Text("Try again"),
            onPressed: () => _profileBloc.add(FetchUserEvent()),
          )
        ],
      ),
    );
  }

  buildLabelTextRow(String label, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}
