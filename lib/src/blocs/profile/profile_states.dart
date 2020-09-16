import 'package:flutter/foundation.dart';
import 'package:flutterappfdp/src/models/userModel.dart';

abstract class ProfileState {}

class InitState extends ProfileState{}

class LoadingState extends ProfileState{}

class FetchedUserState extends ProfileState{
  User user;
  FetchedUserState({@required this.user}) : assert(user != null);
}

class ErrorFetchingState extends ProfileState{}

class SuccessUploadIndexFaceState extends ProfileState{}