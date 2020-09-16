import 'package:flutter/foundation.dart';

abstract class AuthenticationEvent {}

class AppStartedEvent extends AuthenticationEvent{}

class LoggedInEvent extends AuthenticationEvent {
  final String token;

  LoggedInEvent({@required this.token}) : assert(token!=null);
}

class LoggedOutEvent extends AuthenticationEvent {}

