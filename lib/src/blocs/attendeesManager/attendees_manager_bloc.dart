import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/src/blocs/attendeesManager/attendees_manager.events.dart';
import 'package:flutterappfdp/src/blocs/attendeesManager/attendees_manager_states.dart';
import 'package:flutterappfdp/src/services/event_repository.dart';

class AttendeesManagerBloc extends Bloc<AttendeesManagerEvent, AttendeesManagerState> {
  EventRepository _eventRepository = EventRepository();

  @override
  AttendeesManagerState get initialState => InitState();

  @override
  void onTransition(Transition<AttendeesManagerEvent, AttendeesManagerState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<AttendeesManagerState> mapEventToState(AttendeesManagerEvent event) async* {
    if(event is AttendeesManagerDeleteAttendeeEntryEvent){
      int statusCode = await _eventRepository.deleteAttendeeOfEvent(event.eventId, event.userId);
      if(statusCode != 200) yield EventDetailsErrorHappenedState();
    }
  }
}
