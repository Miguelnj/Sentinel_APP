import 'package:flutter/foundation.dart';

abstract class AttendeesManagerEvent {}

class AttendeesManagerDeleteAttendeeEntryEvent extends AttendeesManagerEvent {
  final String eventId;
  final String userId;
  AttendeesManagerDeleteAttendeeEntryEvent({@required this.eventId, @required this.userId}) :
        assert(eventId != null, userId != null);
}