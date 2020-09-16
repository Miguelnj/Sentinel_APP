import 'package:flutter/material.dart';
import 'package:flutterappfdp/src/ui/components/bars/bottom_navigation_bar.dart';
import 'package:flutterappfdp/src/ui/components/bars/sentinel_app_bar.dart';
import 'package:flutterappfdp/src/ui/components/event_details/event_details_main.dart';

class EventDetails extends StatefulWidget {
  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SentinelAppBar().buildAppBar(),
      body: EventDetailsMain(),
      bottomNavigationBar: SentinelBottomNavigationBar(),
    );
  }

  Center buildGoToHomeScreenButton() {
    return Center(
      child: MaterialButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text("Go to home screen"),
        color: Colors.blue,
      ),
    );
  }
}
