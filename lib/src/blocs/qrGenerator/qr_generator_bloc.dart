import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/src/blocs/qrGenerator/qr_generator_events.dart';
import 'package:flutterappfdp/src/blocs/qrGenerator/qr_generator_states.dart';
import 'package:flutterappfdp/src/services/event_repository.dart';

class QRGeneratorBloc extends Bloc<QRGeneratorEvent, QRGeneratorState> {
  EventRepository _eventRepository = EventRepository();

  @override
  void onTransition(Transition<QRGeneratorEvent, QRGeneratorState> transition) {
    super.onTransition(transition);
  }

  @override
  QRGeneratorState get initialState => InitState();

  @override
  Stream<QRGeneratorState> mapEventToState(QRGeneratorEvent event) async* {
    yield LoadingState();
    print(event);
    if (event is QRCheckAssistanceEvent) {
      Map qr = await _eventRepository.getQRCheckRegistry(event.eventId);
      if (qr["uuid"] == null)
        yield EventDetailsErrorHappenedState();
      else
        yield QRCheckAssistanceState(eventId: event.eventId, qrIdentifier: qr["uuid"]);
    }
  }
}
