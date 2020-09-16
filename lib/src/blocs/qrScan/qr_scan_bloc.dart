import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/src/blocs/qrScan/qr_scan_events.dart';
import 'package:flutterappfdp/src/blocs/qrScan/qr_scan_states.dart';
import 'package:flutterappfdp/src/services/event_repository.dart';

class QrScanBloc extends Bloc<QrScanEvent, QrScanState> {
  EventRepository _eventRepository = EventRepository();

  @override
  QrScanState get initialState => QrScanInitial();

  @override
  Stream<QrScanState> mapEventToState(QrScanEvent event) async* {
    yield QrScanLoading();
    if (event is QrScanSubmitScannedCodeEvent) {
      int currentTimestamp = (DateTime.now().millisecondsSinceEpoch / 1000).round();
      int statusCode = await _eventRepository.scannedQRCodeSubmit(event.uuid, currentTimestamp);
      if(statusCode == 200 || statusCode == 201) yield QrScanSuccessState();
      else yield QrScanFailedState();
    }
  }
}
