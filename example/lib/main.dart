import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _adUnitID = "ca-app-pub-3940256099942544/8135179316";

  final _nativeAdController = NativeAdmobController();

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
            Container(
              height: 90,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 20.0),
              child: NativeAdmob(
                // Your ad unit id
                adUnitID: _adUnitID,
                numberAds: 3,
                controller: _nativeAdController,
                type: NativeAdmobType.banner,
                options: NativeAdmobOptions(
                  headlineTextStyle: NativeTextStyle(
                    androidTypeface: 'fonts/Raleway-SemiBold.ttf',
                    iosTypeface: 'Raleway-SemiBold',
                  ),
                  advertiserTextStyle: NativeTextStyle(
                    androidTypeface: 'fonts/Raleway-SemiBold.ttf',
                    iosTypeface: 'Raleway-SemiBold',
                  ),
                  callToActionStyle: NativeTextStyle(
                    androidTypeface: 'fonts/Raleway-SemiBold.ttf',
                    iosTypeface: 'Raleway-SemiBold',
                  ),
                  storeTextStyle: NativeTextStyle(
                    androidTypeface: 'fonts/Raleway-SemiBold.ttf',
                    iosTypeface: 'Raleway-SemiBold',
                  ),
                ),
              ),
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
              height: 330,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 20.0),
              child: NativeAdmob(
                // Your ad unit id
                adUnitID: _adUnitID,
                numberAds: 3,
                controller: _nativeAdController,
                type: NativeAdmobType.full,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              height: 200.0,
              color: Colors.blue,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("Refresh Ads"),
          onPressed: () {
            _nativeAdController.reloadAd(forceRefresh: true);
          },
        ),
      ),
    );
  }
}
