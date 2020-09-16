import 'dart:io';

import 'package:flutter/foundation.dart';

class FaceRecognitionEvent {}

class SubmitVideoEvent extends FaceRecognitionEvent{
  File video;
  String eventId;
  SubmitVideoEvent({@required this.video, @required this.eventId}) : assert(video != null);
}