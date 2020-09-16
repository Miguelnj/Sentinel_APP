import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterappfdp/src/blocs/attendeesManager/attendees_manager.events.dart';
import 'package:flutterappfdp/src/blocs/attendeesManager/attendees_manager_bloc.dart';
import 'package:flutterappfdp/src/blocs/attendeesManager/attendees_manager_utils.dart';
import 'package:flutterappfdp/src/models/event_storage.dart';
import 'package:flutterappfdp/src/ui/components/bars/bottom_navigation_bar.dart';
import 'package:flutterappfdp/src/ui/components/bars/sentinel_app_bar.dart';

class ManageAttendees extends StatefulWidget {
  ManageAttendees({@required this.attendeesPageArguments}) : assert(attendeesPageArguments != null);

  final AttendeesManagerArguments attendeesPageArguments;

  @override
  _ManageAttendeesState createState() => _ManageAttendeesState();
}

class _ManageAttendeesState extends State<ManageAttendees> {
  AttendeesManagerBloc _attendeesManagerBloc = AttendeesManagerBloc();
  EventStorage _eventStorage = EventStorage();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SentinelAppBar().buildAppBar(),
      body: Column(
        children: <Widget>[
          buildHeader(),
          SizedBox(height: 10),
          buildListOfAttendees(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .pushNamed('/events/details/manage/add', arguments: widget.attendeesPageArguments.eventId),
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: SentinelBottomNavigationBar(),
    );
  }

  Stack buildHeader() {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Center(
                child: Text(
                  "Attendees",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              height: 50,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildListOfAttendees(context) {
    if (widget.attendeesPageArguments.attendees == null || widget.attendeesPageArguments.attendees.length == 0) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.68,
        child: Column(
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 200,
            ),
            Text(
              "This event has no attendees",
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      );
    }
    return Container(
      height: MediaQuery.of(context).size.height * 0.68,
      child: ListView.builder(
          itemCount: widget.attendeesPageArguments.attendees.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (BuildContext ctxt, int index) {
            return Dismissible(
              key: Key(widget.attendeesPageArguments.attendees.keys.toList()[index]),
              onDismissed: (direction) {
                setState(() {
                  String key = widget.attendeesPageArguments.attendees.keys.toList()[index];
                  widget.attendeesPageArguments.attendees.remove(key);
                  _eventStorage.event.attendees = widget.attendeesPageArguments.attendees;
                  _attendeesManagerBloc.add(AttendeesManagerDeleteAttendeeEntryEvent(
                      eventId: widget.attendeesPageArguments.eventId, userId: key));
                });
              },
              background: Container(
                alignment: AlignmentDirectional.centerEnd,
                color: Colors.red,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text(widget.attendeesPageArguments.attendees.keys.toList()[index]),
                trailing: Icon(Icons.arrow_back),
              ),
            );
          }),
    );
  }
}
