import 'package:flutter/foundation.dart';

abstract class EventListingEvent{}

class EventFetchAllEvents extends EventListingEvent{}

class EventDeleteEvent extends EventListingEvent{
  final String eventId;
  EventDeleteEvent({@required this.eventId}) : assert(eventId != null);
}