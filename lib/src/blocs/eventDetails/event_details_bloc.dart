import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/src/blocs/eventDetails/event_details_events.dart';
import 'package:flutterappfdp/src/blocs/eventDetails/event_details_states.dart';
import 'package:flutterappfdp/src/services/event_repository.dart';

class EventDetailsBloc extends Bloc<EventDetailsEvent, EventDetailsState> {
  final EventRepository eventRepository = EventRepository();

  @override
  void onTransition(Transition<EventDetailsEvent, EventDetailsState> transition) {
    super.onTransition(transition);
  }

  @override
  EventDetailsState get initialState => EventDetailsUninitializedState();

  @override
  Stream<EventDetailsState> mapEventToState(EventDetailsEvent event) async* {

  }

  void sendEventSumUpEmail(eventId) async{
    final int statusCode = await eventRepository.sendEventSumUpRequest(eventId);
    print(statusCode);
  }

}
