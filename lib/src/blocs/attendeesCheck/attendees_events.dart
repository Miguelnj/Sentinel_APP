import 'package:flutter/foundation.dart';

abstract class AttendeesEvent{}

class AttendeesSaveChangesEvent extends AttendeesEvent{
  final Map<String, dynamic> attendees;
  final String id;
  AttendeesSaveChangesEvent({@required this.attendees, @required this.id}) :
        assert(attendees != null, id != null);
}