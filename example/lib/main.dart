import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static const adUnitID = "ca-app-pub-3940256099942544/8135179316";

  final _nativeAdmob = NativeAdmob();

  @override
  void initState() {
    super.initState();

    _nativeAdmob.initialize(appID: "ca-app-pub-3940256099942544~3347511713");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              height: 200.0,
              color: Colors.green,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              height: 200.0,
              color: Colors.green,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              height: 200.0,
              color: Colors.green,
            ),
            NativeAdmobBannerView(
              adUnitID: adUnitID,
              style: BannerStyle.dark,
              showMedia: true,
              contentPadding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              height: 200.0,
              color: Colors.green,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              height: 200.0,
              color: Colors.green,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              height: 200.0,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
