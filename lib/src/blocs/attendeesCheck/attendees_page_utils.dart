import 'package:flutter/foundation.dart';

class AttendeesPageArguments {
  String eventId;
  Map<String, dynamic> attendees;

  AttendeesPageArguments({@required this.eventId, @required this.attendees});
}