import 'package:flutter/foundation.dart';

abstract class QrScanEvent {}

class QrScanSubmitScannedCodeEvent extends QrScanEvent {
  final String uuid;
  QrScanSubmitScannedCodeEvent({@required this.uuid}) : assert(uuid != null);
}