import 'dart:io';

import 'package:flutter/foundation.dart';

abstract class ProfileEvent{}

class FetchUserEvent extends ProfileEvent {}

class IndexImageEvent extends ProfileEvent {
  File image;
  IndexImageEvent({@required this.image}) : assert(image != null);
}