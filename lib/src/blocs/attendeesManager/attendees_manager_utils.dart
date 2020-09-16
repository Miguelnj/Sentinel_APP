import 'package:flutter/foundation.dart';

class AttendeesManagerArguments {
  String eventId;
  Map<String, dynamic> attendees;

  AttendeesManagerArguments({@required this.eventId, @required this.attendees});
}