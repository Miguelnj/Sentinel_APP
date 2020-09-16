import 'package:flutter/material.dart';
import 'package:flutterappfdp/main.dart';

class SentinelBottomNavigationBar extends StatefulWidget {
  @override
  _SentinelBottomNavigationBarState createState() => _SentinelBottomNavigationBarState();
}

class _SentinelBottomNavigationBarState extends State<SentinelBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
          ),
        ],
      ),
      child: BottomNavigationBar(
        items: [
          buildBottomNavigationBarItem(Icons.event, '/home'),
          buildBottomNavigationBarItem(Icons.camera_alt, '/add'),
          buildBottomNavigationBarItem(Icons.account_circle, '/profile'),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int index) => buildMainView(index),
      ),
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
      IconData icon, String destination) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: Colors.grey[900],
      ),
      title: Text(''),
    );
  }

  buildMainView(index) {
    if(index == currentNavigationIndex) return;
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/events/list');
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/qr/scan');
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed('/profile');
        break;
      default:
        Navigator.of(context).pushReplacementNamed('/events/list');
        break;
    }
    currentNavigationIndex = index;
  }

}