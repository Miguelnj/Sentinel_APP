import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterappfdp/src/ui/screens/add_attendees.dart';
import 'package:flutterappfdp/src/ui/screens/assistance_check_face_recognition.dart';
import 'package:flutterappfdp/src/ui/screens/attendees_page.dart';
import 'package:flutterappfdp/src/ui/screens/create_event.dart';
import 'package:flutterappfdp/src/ui/screens/event_details.dart';
import 'package:flutterappfdp/src/ui/screens/events.dart';
import 'package:flutterappfdp/src/ui/screens/login.dart';
import 'package:flutterappfdp/src/ui/screens/manage_attendees_list.dart';
import 'package:flutterappfdp/src/ui/screens/profile.dart';
import 'package:flutterappfdp/src/ui/screens/qr_code_display.dart';
import 'package:flutterappfdp/src/ui/screens/qr_code_scan.dart';
import 'package:flutterappfdp/src/ui/screens/register.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => LoginPage(),
    '/events/list': (context) => EventScreen(),
    '/events/create': (context) => CreateEvent(),
    '/events/details': (context) => EventDetails(),
    '/profile': (context) => Profile(),
    '/qr/scan': (context) => QRScan(),
    '/events/details/manage/add': (context) => AddAttendees(),
    '/events/facial': (context) => FaceRecognitionView(),
    '/register': (context) => Register(),
  },
  onGenerateRoute: (RouteSettings settings) {
    print('build route for ${settings.name}');
    var routes = <String, WidgetBuilder>{
      "/events/details/attendees": (context) => AttendeesPage(attendeesPageArguments: settings.arguments),
      '/qr/generator': (context) => QRCodeDisplay(eventId: settings.arguments),
      '/events/details/manage': (context) => ManageAttendees(attendeesPageArguments: settings.arguments),
    };
    WidgetBuilder builder = routes[settings.name];
    return MaterialPageRoute(builder: (ctx) => builder(ctx));
  },
));

int currentNavigationIndex = 0;

final storage = new FlutterSecureStorage();