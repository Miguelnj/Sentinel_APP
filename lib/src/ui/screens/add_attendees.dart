import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterappfdp/src/blocs/userList/user_list_bloc.dart';
import 'package:flutterappfdp/src/blocs/userList/user_list_events.dart';
import 'package:flutterappfdp/src/ui/components/bars/bottom_navigation_bar.dart';
import 'package:flutterappfdp/src/ui/components/bars/sentinel_app_bar.dart';
import 'package:flutterappfdp/src/ui/components/user_list/UserList.dart';

class AddAttendees extends StatefulWidget {
  @override
  _AddAttendeesState createState() => _AddAttendeesState();
}

class _AddAttendeesState extends State<AddAttendees> {
  final UserListBloc _userListBloc = UserListBloc();
  String eventId;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    eventId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: SentinelAppBar().buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildHeader(context),
            SizedBox(height: 10),
            buildListOfUsers(context),
          ],
        ),
      ),
      bottomNavigationBar: SentinelBottomNavigationBar(),
    );
  }

  Widget buildListOfUsers(context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.68,
      child: UserList(userListBloc: _userListBloc, eventId: eventId),
    );
  }

  Stack buildHeader(context) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.80,
              child: new TextField(
                onChanged: (text) => _userListBloc.add(SearchUsersGivenTextEvent(input: text)),
                style: new TextStyle(
                  color: Colors.black,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.blue[900]),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.black)),
              ),
            ),
          ],
        )
      ],
    );
  }
}
