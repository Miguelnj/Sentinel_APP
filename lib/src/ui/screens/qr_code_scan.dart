import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterappfdp/src/blocs/qrScan/qr_scan_bloc.dart';
import 'package:flutterappfdp/src/blocs/qrScan/qr_scan_events.dart';
import 'package:flutterappfdp/src/blocs/qrScan/qr_scan_states.dart';
import 'package:flutterappfdp/src/ui/components/bars/bottom_navigation_bar.dart';
import 'package:flutterappfdp/src/ui/components/bars/sentinel_app_bar.dart';

class QRScan extends StatefulWidget {
  @override
  _QRScan createState() => _QRScan();
}

class _QRScan extends State<QRScan> {
  QrScanBloc _qrScanBloc = QrScanBloc();

  void main() async {
    var result = await BarcodeScanner.scan();
    if (result.type == ResultType.Barcode &&
        result.format == BarcodeFormat.qr) {
      _qrScanBloc.add(QrScanSubmitScannedCodeEvent(uuid: result.rawContent));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _qrScanBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SentinelAppBar().buildAppBar(),
      body: BlocBuilder(
          bloc: _qrScanBloc,
          builder: (context, state) {
            if (state is QrScanInitial) {
              main();
              return buildWaitingForScanView();
            } else if (state is QrScanSuccessState) {
              return buildSuccessSubmitView();
            } else if (state is QrScanFailedState) {
              return buildFailedSubmitView();
            }
            return buildLoadingView();
          }),
      bottomNavigationBar: SentinelBottomNavigationBar(),
    );
  }

  Padding buildWaitingForScanView() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Waiting for the scan...",
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            buildOpenScannerButton(),
          ],
        ));
  }

  SpinKitCircle buildLoadingView() {
    return SpinKitCircle(color: Colors.lightBlue, size: 50.0);
  }

  Widget buildSuccessSubmitView() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Successfully assigned to event!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            buildOpenScannerButton(),
          ],
        ));
  }

  Widget buildFailedSubmitView() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              color: Colors.red,
              child: Text(
                'Oops!! Something went bad',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            buildOpenScannerButton(),
          ],
        ));
  }

  Widget buildOpenScannerButton() {
    return FlatButton(
      onPressed: () => main(),
      color: Colors.blue,
      child: Text(
        'Open Scanner',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }
}
