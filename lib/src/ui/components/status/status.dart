import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Status{
  SpinKitCircle buildLoadingView() {
    return SpinKitCircle(
        color: Colors.lightBlue,
        size: 50.0
    );
  }
}