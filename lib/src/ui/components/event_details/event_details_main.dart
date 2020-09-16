import 'package:flutter/material.dart';
import 'package:flutterappfdp/src/blocs/attendeesCheck/attendees_page_utils.dart';
import 'package:flutterappfdp/src/blocs/attendeesManager/attendees_manager_utils.dart';
import 'package:flutterappfdp/src/blocs/eventDetails/event_details_bloc.dart';
import 'package:flutterappfdp/src/models/eventModel.dart';
import 'package:flutterappfdp/src/models/event_storage.dart';

class EventDetailsMain extends StatefulWidget {

  @override
  _EventDetailsMainState createState() => _EventDetailsMainState();
}

class _EventDetailsMainState extends State<EventDetailsMain> {

  EventStorage _eventStorage = EventStorage();
  final EventDetailsBloc _eventDetailsBloc = EventDetailsBloc();
  Event _event;

  @override
  void initState() {
    super.initState();
    _event = _eventStorage.event;
  }


  @override
  void dispose() {
    super.dispose();
    _eventDetailsBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return eventDetailsView(context, _event);
  }

  SingleChildScrollView eventDetailsView(BuildContext context, event) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          topContent(context),
          buildInformationRows(event),
          buildButtonsGroup(event, context),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }

  Column buildButtonsGroup(Event event, context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 15.0,
        ),
        FlatButton.icon(
          color: Colors.grey[300],
          label: Text('Attendees  ' + event.getFormattedAttendeesNumber()),
          icon: Icon(
            Icons.person_outline,
            color: Colors.grey[800],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
          ),
          onPressed: () async{
            await Navigator.of(context).pushNamed('/events/details/manage',
                arguments: AttendeesManagerArguments(eventId: event.id, attendees: event.attendees));
            setState(() {
              _event = _eventStorage.event;
            });
            },
        ),
        SizedBox(
          height: 15.0,
        ),
        FlatButton(
          onPressed: () => showConfirmSendEmailDialog(context),
          color: Colors.deepPurple[500],
          child: Text(
            'Get event info by e-mail',
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        FlatButton(
          onPressed: () {
            _settingModalBottomSheet(context);
          },
          color: Colors.deepPurple[500],
          child: Text(
            'Start assistance check',
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
          ),
        ),
      ],
    );
  }

  Column buildInformationRows(event) {
    return Column(
      children: <Widget>[
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Text(
                event.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Text(
                event.location,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Text(
                event.eventDatesToFormattedString(),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget topContent(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10.0),
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: new BoxDecoration(
              image: new DecorationImage(image: new AssetImage('assets/sample.png'), fit: BoxFit.cover)),
        ),
        Container(
          padding: EdgeInsets.only(left: 10.0),
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: new BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                Colors.white.withOpacity(0.95),
                Colors.white.withOpacity(0.8),
                Colors.white.withOpacity(0.6),
                Colors.white.withOpacity(0),
              ], stops: [
                0.05,
                0.1,
                0.15,
                0.25
              ])),
        ),
      ],
    );
  }

  void _settingModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.edit),
                  title: new Text('Manually check assistance'),
                  onTap: () async {
                    Navigator.pop(context);
                    await Navigator.of(context).pushNamed('/events/details/attendees',
                        arguments: AttendeesPageArguments(eventId: _event.id, attendees: _event.attendees));
                    setState(() {
                      _event = _eventStorage.event;
                    });
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.add_to_queue),
                  title: new Text('QR Code assistance check'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed('/qr/generator', arguments: _event.id);
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.camera_alt),
                  title: new Text('Facial recognition assistance check'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed('/events/facial', arguments: _event.id);
                  },
                ),
              ],
            ),
          );
        });
  }

  showConfirmSendEmailDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm send email"),
      content: Text("Are you sure you want to send an email with the current status of the event?"),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Continue"),
          onPressed: () {
            _eventDetailsBloc.sendEventSumUpEmail(_event.id);
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
