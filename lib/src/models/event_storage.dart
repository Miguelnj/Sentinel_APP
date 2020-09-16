import 'eventModel.dart';

class EventStorage{
  Event event;
  List<Event> events;

  static final EventStorage _instance = EventStorage._internal();

  factory EventStorage() {
    return _instance;
  }

  EventStorage._internal();
}