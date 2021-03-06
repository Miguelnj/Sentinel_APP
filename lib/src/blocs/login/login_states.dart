import 'package:flutter/foundation.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure({@required this.error});
}

class LoginSucceed extends LoginState {}
