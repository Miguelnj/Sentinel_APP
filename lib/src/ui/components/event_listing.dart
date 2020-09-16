import 'package:flutter/material.dart';
import 'package:flutterappfdp/src/blocs/events/event_listing_event.dart';
import 'package:flutterappfdp/src/blocs/events/events_bloc.dart';
import 'package:flutterappfdp/src/models/eventModel.dart';
import 'package:flutterappfdp/src/models/event_storage.dart';

class EventListing extends StatefulWidget {
  EventListing(this.eventListingBloc);
  final EventListingBloc eventListingBloc;

  @override
  _EventListingState createState() => _EventListingState();
}

class _EventListingState extends State<EventListing> {

  EventStorage _eventStorage = EventStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
          child: Column(children: <Widget>[
            buildFirstRow(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children:
                  _eventStorage.events.map<Widget>((event) => eventTemplate(event)).toList(),
                ),
              ),
            )
          ])
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/events/create'),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue[900],
      ),
    );
  }

  Widget eventTemplate(Event event) {
    return GestureDetector(
      onTap: () {
        _eventStorage.event = event;
        Navigator.of(context).pushNamed('/events/details');
      },
      onLongPress: () {
        showConfirmDeleteDialog(event.id);
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    event.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          event.getFormattedAttendeesNumber(),
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        Icon(
                          Icons.person_outline,
                          color: Colors.grey[800],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.0),
              Row(
                children: <Widget>[
                  Text(
                    event.eventDatesToFormattedString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildFirstRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'All Events',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        FlatButton(
          onPressed: () => widget.eventListingBloc.add(EventFetchAllEvents()),
          color: Colors.blue[900],
          child: Text(
            'Refresh events',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  showConfirmDeleteDialog(String eventId) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm event deletion"),
      content: Text("Are you sure you want to delete this event?"),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Continue"),
          onPressed: () {
            widget.eventListingBloc.add(EventDeleteEvent(eventId: eventId));
            Navigator.pop(context);
          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
