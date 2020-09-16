import 'package:flutter/foundation.dart';

abstract class QRGeneratorEvent {}

class QRCheckAssistanceEvent extends QRGeneratorEvent {
  final String eventId;
  QRCheckAssistanceEvent({@required this.eventId}) : assert(eventId != null);
}