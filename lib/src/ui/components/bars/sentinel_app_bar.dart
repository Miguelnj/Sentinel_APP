import 'package:flutter/material.dart';

class SentinelAppBar {
  Widget buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(40.0),
      child: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue[900]
        ),
        title: Text(
          'Sentinel',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          child: Container(
            color: Colors.black,
            height: 0.2,
          ),
          preferredSize: Size.fromHeight(1.0),
        ),
      ),
    );
  }
}
