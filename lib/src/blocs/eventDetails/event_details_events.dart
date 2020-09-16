
import 'package:flutter/foundation.dart';
import 'package:flutterappfdp/src/models/eventModel.dart';

abstract class EventDetailsEvent{}

class EventDetailsInvokedEvent extends EventDetailsEvent{
    final String eventId;
    EventDetailsInvokedEvent({@required this.eventId}) : assert(eventId != null);
}

class EventDetailsSendSumUpEmail extends EventDetailsEvent {
    final String eventId;
    EventDetailsSendSumUpEmail({@required this.eventId}) : assert(eventId != null);
}