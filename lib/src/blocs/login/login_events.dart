import 'package:flutter/foundation.dart';

abstract class LoginEvent{}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  LoginButtonPressed({@required this.username, @required this.password}) :
        assert(username!=null, password!=null);
}