import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/src/blocs/userList/user_list_bloc.dart';
import 'package:flutterappfdp/src/blocs/userList/user_list_events.dart';
import 'package:flutterappfdp/src/blocs/userList/user_list_states.dart';
import 'package:flutterappfdp/src/models/event_storage.dart';

class UserList extends StatefulWidget {
  UserList({@required this.userListBloc, @required this.eventId}) : assert(userListBloc != null, eventId != null);

  final UserListBloc userListBloc;
  final String eventId;

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  final EventStorage _eventStorage = EventStorage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: widget.userListBloc,
      builder: (context, state) {
        if (state is ListOfUsersFetchedState) {
          return Container(
            child: ListView.builder(
                itemCount: state.listOfUserNames.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext ctxt, int index) {
                  return ListTile(
                    leading: Icon(Icons.person),
                    title: Text(state.listOfUserNames[index]),
                    trailing: FlatButton(
                      onPressed: () {
                        widget.userListBloc.add(StoreSelectedUserEvent(eventId: widget.eventId, username: state.listOfUserNames[index]));
                        setState(() {
                          _eventStorage.event.attendees.putIfAbsent(state.listOfUserNames[index], () => false);
                        });
                      },
                      child: Text(
                        "Add to event",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                  );
                }),
          );
        } else {
          return Center(
            child: Text("Search user by usernames"),
          );
        }
      },
    );
  }
}
