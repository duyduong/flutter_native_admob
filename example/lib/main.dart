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
              // Your ad unit id
              adUnitID: _adUnitID,

              // Styling native view with options
              options: const BannerOptions(
                backgroundColor: Colors.white,
                indicatorColor: Colors.black,
                ratingColor: Colors.yellow,
                adLabelOptions: const TextOptions(
                  fontSize: 12,
                  color: Colors.white,
                  backgroundColor: Color(0xFFFFCC66),
                ),
                headlineTextOptions: const TextOptions(
                  fontSize: 16,
                  color: Colors.black,
                ),
                advertiserTextOptions: const TextOptions(
                  fontSize: 14,
                  color: Colors.black,
                ),
                bodyTextOptions: const TextOptions(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                storeTextOptions: const TextOptions(
                  fontSize: 12,
                  color: Colors.black,
                ),
                priceTextOptions: const TextOptions(
                  fontSize: 12,
                  color: Colors.black,
                ),
                callToActionOptions: const TextOptions(
                  fontSize: 15,
                  color: Colors.white,
                  backgroundColor: Color(0xFF4CBE99),
                ),
              ),

              // Whether to show media or not
              showMedia: true,

              // Content paddings
              contentPadding: EdgeInsets.all(10),

              onCreate: (controller) {
                // controller.setOptions(BannerOptions()); // change view styling options
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
