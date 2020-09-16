import 'package:flutter/foundation.dart';

abstract class CreateEventEvent {}

class EventCreationSubmittedEvent extends CreateEventEvent{
  String name;
  String location;
  DateTime startDate;
  DateTime endDate;
  EventCreationSubmittedEvent({@required this.name, @required this.location,
    @required this.startDate, @required this.endDate}) :
        assert(name != null, location != null),assert(startDate != null, endDate != null);
}