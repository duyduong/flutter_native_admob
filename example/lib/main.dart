import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _adUnitID = "ca-app-pub-3940256099942544/8135179316";

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
              adUnitID: _adUnitID,
              style: BannerStyle.dark,
              showMedia: true,
              contentPadding: EdgeInsets.all(10),
              onCreate: (controller) {
                // controller.setStyle(BannerStyle.light); // Dynamic update style
              },
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
