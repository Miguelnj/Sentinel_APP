import 'package:flutter/foundation.dart';
import 'package:flutterappfdp/src/models/eventModel.dart';

abstract class EventDetailsState {}

class EventDetailsUninitializedState extends EventDetailsState {}

class EventDetailsInitialState extends EventDetailsState {
  final Event event;

  EventDetailsInitialState({@required this.event}) : assert(event != null);
}

class EventDetailsLoadingState extends EventDetailsState {}

class EventDetailsErrorHappenedState extends EventDetailsState {}
