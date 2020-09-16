
abstract class QrScanState {}

class QrScanLoading extends QrScanState {}

class QrScanInitial extends QrScanState {}

class QrScanSuccessState extends QrScanState {}

class QrScanFailedState extends QrScanState {}
