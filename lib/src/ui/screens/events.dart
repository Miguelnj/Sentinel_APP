import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterappfdp/src/blocs/events/event_listing_event.dart';
import 'package:flutterappfdp/src/blocs/events/events_bloc.dart';
import 'package:flutterappfdp/src/models/event_storage.dart';
import 'package:flutterappfdp/src/ui/components/bars/bottom_navigation_bar.dart';
import 'package:flutterappfdp/src/ui/components/bars/sentinel_app_bar.dart';
import 'package:flutterappfdp/src/ui/components/status/status.dart';
import 'package:flutterappfdp/src/ui/screens/create_event.dart';
import 'package:flutterappfdp/src/ui/components/event_listing.dart';
import 'package:flutterappfdp/src/blocs/events/event_listing_state.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  EventListingBloc _eventListingBloc = EventListingBloc();

  @override
  void initState() {
    super.initState();
    _eventListingBloc.add(EventFetchAllEvents());
  }

  @override
  void dispose() {
    super.dispose();
    _eventListingBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SentinelAppBar().buildAppBar(),
      body: BlocBuilder(
        bloc: _eventListingBloc,
        builder: (context, state) {
          if(state is EventUninitializedState) return Status().buildLoadingView();
          if (state is EventEmptyState)
            return buildNoEventsFound();
          else if (state is EventErrorState)
            return buildTryAgainButton();
          else if (state is EventFetchingState) return Status().buildLoadingView();
          else
            return EventListing(_eventListingBloc);
        },
      ),
      bottomNavigationBar: SentinelBottomNavigationBar(),
    );
  }

  Center buildTryAgainButton() {
    return Center(
      child: MaterialButton(
        onPressed: () => _eventListingBloc.add(EventFetchAllEvents()),
        child: Text("Try Again"),
        color: Colors.blue,
      ),
    );
  }

  Widget buildNoEventsFound() {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Center(
            child: Text(
              "No events found",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.pushNamed(context, '/events/create');
          _eventListingBloc.add(EventFetchAllEvents());
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue[900],
      ),
    );
  }
}
