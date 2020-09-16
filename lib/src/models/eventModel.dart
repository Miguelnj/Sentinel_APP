import 'package:intl/intl.dart';

class EventModel {
  List<Event> _events = [];
  Event _event;

  EventModel.eventListFromJson(Map<String, dynamic> parsedJson) {
    List<Event> temp = [];
    for (int i = 0; i < parsedJson['Items'].length; i++) {
      Event event = Event(parsedJson['Items'][i]);
      temp.add(event);
    }
    _events = temp;
  }

  EventModel.eventFromJson(Map<String, dynamic> parsedJson) {
    _event = Event(parsedJson['Item']);
  }

  Event get event => _event;
  List<Event> get events => _events;
}

class Event{

  String id;
  String name;
  DateTime from;
  DateTime to;
  String location;
  String owner;
  Map<String,dynamic> attendees;

  Event(event){
    id = event['id'];
    name = event['name'];
    from = DateTime.parse((event['date'])['from']);
    to = DateTime.parse((event['date'])['to']);
    location = event['location'];
    owner = event['owner'];
    attendees = event['attendees'];
  }

  String eventDatesToFormattedString() {
    if(from.day == to.day && from.month == to.month && from.year == to.year){
      return  "${DateFormat.yMMMMEEEEd().add_jm().format(from)} "
          "- ${DateFormat.jm().format(to)}";
    }else{
      return "${DateFormat.yMMMMEEEEd().add_jm().format(from)} "
          "\n ${DateFormat.yMMMMEEEEd().add_jm().format(to)}";
    }
  }

  String getFormattedAttendeesNumber(){
    if(attendees == null) return '-';
    int confirmedAssist = 0;
    attendees.values.forEach((status) {
      if(status) confirmedAssist++;
    });
    return '$confirmedAssist/${attendees.length}';
  }

}