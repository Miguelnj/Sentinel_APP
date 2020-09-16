import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/src/blocs/attendeesCheck/attendees_events.dart';
import 'package:flutterappfdp/src/blocs/attendeesCheck/attendees_states.dart';
import 'package:flutterappfdp/src/models/eventModel.dart';
import 'package:flutterappfdp/src/models/event_storage.dart';
import 'package:flutterappfdp/src/services/event_repository.dart';

class AttendeesBloc extends Bloc<AttendeesEvent, AttendeesState> {
  EventRepository _eventRepository = EventRepository();
  EventStorage _eventStorage = EventStorage();

  @override
  AttendeesState get initialState => InitState();

  @override
  void onTransition(Transition<AttendeesEvent, AttendeesState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<AttendeesState> mapEventToState(AttendeesEvent event) async* {
    yield LoadingState();
    if (event is AttendeesSaveChangesEvent) {
      int responseStatus = await _eventRepository.updateAttendeesOfEvent(event.id, event.attendees);
      Event storageEvent = _eventStorage.event;
      storageEvent.attendees = Map.from(event.attendees);
      _eventStorage.event = storageEvent;
      if (responseStatus == 200) yield InitState();
    }
  }
}
