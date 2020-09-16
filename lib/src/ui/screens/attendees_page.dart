import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/src/blocs/attendeesCheck/attendees_bloc.dart';
import 'package:flutterappfdp/src/blocs/attendeesCheck/attendees_events.dart';
import 'package:flutterappfdp/src/blocs/attendeesCheck/attendees_page_utils.dart';
import 'package:flutterappfdp/src/blocs/attendeesCheck/attendees_states.dart';
import 'package:flutterappfdp/src/ui/components/bars/bottom_navigation_bar.dart';
import 'package:flutterappfdp/src/ui/components/bars/sentinel_app_bar.dart';
import 'package:flutterappfdp/src/ui/components/status/status.dart';

class AttendeesPage extends StatefulWidget {
  AttendeesPage({@required  this.attendeesPageArguments}) : assert(attendeesPageArguments != null);

  final AttendeesPageArguments attendeesPageArguments;

  @override
  _AttendeesPageState createState() => _AttendeesPageState();
}

class _AttendeesPageState extends State<AttendeesPage> {
  final AttendeesBloc _attendeesBloc = AttendeesBloc();

  Map<String, dynamic> _attendees;
  bool _isSaveChangesButtonDisable = true;

  @override
  void initState() {
    _attendees = Map.from(widget.attendeesPageArguments.attendees);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkIfButtonShouldBeDisabled();

    return Scaffold(
      appBar: SentinelAppBar().buildAppBar(),
      body: BlocBuilder(
        bloc: _attendeesBloc,
        builder: (context, state) {
          if (state is InitState) {
            return buildMainView(context);
          }else {
            return Status().buildLoadingView();
          }
        },
      ),
      bottomNavigationBar: SentinelBottomNavigationBar(),
    );
  }

  Column buildMainView(BuildContext context) {
    return Column(
      children: <Widget>[
        buildHeader(),
        SizedBox(height: 10),
        buildListOfAttendees(context),
        buildButtonGroup(),
      ],
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
    if (_attendees == null || _attendees.length == 0) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.64,
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
      height: MediaQuery.of(context).size.height * 0.64,
      child: ListView.builder(
          itemCount: _attendees.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (BuildContext ctxt, int index) {
            return ListTile(
              leading: Icon(Icons.person),
              title: Text(_attendees.keys.toList()[index]),
              subtitle: getTextGivenBool(_attendees, index),
              trailing: Checkbox(
                  value: _attendees.values.toList()[index],
                  checkColor: Colors.green,
                  activeColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      String key = _attendees.keys.toList()[index];
                      _attendees.update(key, (val) => val = value);
                    });
                  }),
            );
          }),
    );
  }

  Text getTextGivenBool(Map<String, dynamic> attendees, index) {
    if (attendees.values.toList()[index]) {
      return Text("YES", style: TextStyle(color: Colors.green));
    } else {
      return Text("NO", style: TextStyle(color: Colors.red));
    }
  }

  void checkIfButtonShouldBeDisabled() {
    if (mapEquals(widget.attendeesPageArguments.attendees, _attendees))
      _isSaveChangesButtonDisable = true;
    else
      _isSaveChangesButtonDisable = false;
  }

  addEventSaveChangesToBloc() {
    _attendeesBloc.add(AttendeesSaveChangesEvent(attendees: _attendees, id: widget.attendeesPageArguments.eventId));
  }

  Widget buildButtonGroup() {
    return ButtonBar(
      mainAxisSize: MainAxisSize.min,
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          onPressed: () => _isSaveChangesButtonDisable ? null : addEventSaveChangesToBloc(),
          child: Text(
            "Save changes",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
        )
      ],
    );
  }
}
