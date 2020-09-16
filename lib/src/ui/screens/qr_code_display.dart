import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/src/blocs/qrGenerator/qr_generator_bloc.dart';
import 'package:flutterappfdp/src/blocs/qrGenerator/qr_generator_events.dart';
import 'package:flutterappfdp/src/blocs/qrGenerator/qr_generator_states.dart';
import 'package:flutterappfdp/src/ui/components/bars/bottom_navigation_bar.dart';
import 'package:flutterappfdp/src/ui/components/bars/sentinel_app_bar.dart';
import 'package:flutterappfdp/src/ui/components/status/status.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeDisplay extends StatefulWidget {

  QRCodeDisplay({@required this.eventId}) : assert(eventId != null);

  final String eventId;

  @override
  _QRCodeDisplayState createState() => _QRCodeDisplayState();
}

class _QRCodeDisplayState extends State<QRCodeDisplay> {
  Timer _timer;
  int _start = 5;
  bool _startTimerShouldStart = true;
  QRGeneratorBloc _qrGeneratorBloc = QRGeneratorBloc();

  void startTimer() {
    _startTimerShouldStart = false;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1){
            _timer.cancel();
            _start = 5;
            _startTimerShouldStart = true;
            _qrGeneratorBloc.add(QRCheckAssistanceEvent(eventId: widget.eventId));
          }
          else _start = _start - 1;
        },
      ),
    );
  }

  @override
  void initState() {
    _qrGeneratorBloc.add(QRCheckAssistanceEvent(eventId: widget.eventId));
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SentinelAppBar().buildAppBar(),
      body: BlocBuilder(
        bloc: _qrGeneratorBloc,
        builder: (context, state){
          if(state is QRCheckAssistanceState){
            if(_startTimerShouldStart) startTimer();
            return buildCodeView(state.qrIdentifier);
          }else{
            return Status().buildLoadingView();
          }
        },
      ),
      bottomNavigationBar: SentinelBottomNavigationBar(),
    );
  }

  Center buildCodeView(String qrIdentifier) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 40),
          Text(
            "$_start",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 40),
          QrImage(
            data: qrIdentifier,
            version: QrVersions.auto,
            size: 320,
            gapless: false,
          ),
          SizedBox(height: 40),
          RaisedButton(
            child: Text("Close"),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
  }
}
