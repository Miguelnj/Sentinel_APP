import 'package:flutter/foundation.dart';

abstract class UserListEvent{}

class SearchUsersGivenTextEvent extends UserListEvent{
  String input;
  SearchUsersGivenTextEvent({@required this.input}) : assert(input != null);
}

class StoreSelectedUserEvent extends UserListEvent{
  String username;
  String eventId;

  StoreSelectedUserEvent({@required this.username, @required this.eventId}) : assert(username != null, eventId != null);
}