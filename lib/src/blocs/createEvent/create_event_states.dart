abstract class CreateEventState {}

class InitState extends CreateEventState {}
class LoadingState extends CreateEventState {}
class EventCreationSuccessful extends CreateEventState {}
class EventCreationUnsuccessful extends CreateEventState {}