import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/src/blocs/events/event_listing_event.dart';
import 'package:flutterappfdp/src/models/eventModel.dart';
import 'package:flutterappfdp/src/models/event_storage.dart';
import 'package:flutterappfdp/src/services/event_repository.dart';
import 'event_listing_state.dart';

class EventListingBloc extends Bloc<EventListingEvent, EventListingState> {
  final EventRepository eventRepository = EventRepository();
  EventStorage _eventStorage = EventStorage();
  
  @override
  void onTransition(
      Transition<EventListingEvent, EventListingState> transition) {
    super.onTransition(transition);
  }

  @override
  EventListingState get initialState => EventUninitializedState();

  @override
  Stream<EventListingState> mapEventToState(EventListingEvent event) async* {
    List<Event> events;
    yield EventFetchingState();
    try {
      if(event is EventDeleteEvent){
        int statusCode = await eventRepository.deleteEvent(event.eventId);
        if(statusCode == 200) _eventStorage.events.removeWhere((item) => item.id == event.eventId);
        yield EventFetchedAllState();
      }
      if (event is EventFetchAllEvents){
        events = await eventRepository.fetchAllEvents();
        if (events == null || events.length == 0) yield EventEmptyState();
        else if (events != null){
          _eventStorage.events = events;
          yield EventFetchedAllState();
        }
      }
    } catch (_) {
      print(_);
      yield EventErrorState();
    }
  }
}
