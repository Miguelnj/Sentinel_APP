import 'package:flutter/foundation.dart';

abstract class QRGeneratorState {}

class InitState extends QRGeneratorState{}

class LoadingState extends QRGeneratorState{}

class EventDetailsErrorHappenedState extends QRGeneratorState {}

class QRCheckAssistanceState extends QRGeneratorState {
  final String eventId;
  final String qrIdentifier;

  QRCheckAssistanceState({@required this.eventId, @required this.qrIdentifier})
      : assert(eventId != null, qrIdentifier != null);
}