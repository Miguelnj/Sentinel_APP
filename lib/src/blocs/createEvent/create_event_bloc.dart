import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/src/blocs/createEvent/create_event_events.dart';
import 'package:flutterappfdp/src/blocs/createEvent/create_event_states.dart';
import 'package:flutterappfdp/src/services/event_repository.dart';

class CreateEventBloc extends Bloc<CreateEventEvent, CreateEventState> {
  final EventRepository eventRepository = EventRepository();

  @override
  void onTransition(
      Transition<CreateEventEvent, CreateEventState> transition) {
    super.onTransition(transition);
  }

  @override
  CreateEventState get initialState => InitState();

  @override
  Stream<CreateEventState> mapEventToState(CreateEventEvent event) async* {
    yield LoadingState();
    if(event is EventCreationSubmittedEvent){
      int statusCode = await eventRepository.createEvent(event.name, event.location, event.startDate, event.endDate);
      if(statusCode == 200 || statusCode == 201) yield EventCreationSuccessful();
      else yield EventCreationUnsuccessful();
    }
  }
}
