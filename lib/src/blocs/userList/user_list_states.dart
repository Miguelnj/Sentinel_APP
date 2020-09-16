import 'package:flutter/foundation.dart';

abstract class UserListState {}

class UninitializedState extends UserListState{}

class ListOfUsersFetchedState extends UserListState{
  List<String> listOfUserNames;
  ListOfUsersFetchedState({@required this.listOfUserNames}) : assert(listOfUserNames != null);
}